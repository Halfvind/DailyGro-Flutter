<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header("Content-Type: application/json");

// DB Connection
$servername = "localhost";
$username   = "root";
$password   = "";
$dbname     = "DailyGro";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Database connection failed"]);
    exit;
}

$rider_id = intval($_GET['rider_id'] ?? $_POST['rider_id'] ?? 0);

if (empty($rider_id)) {
    echo json_encode(["status" => "error", "message" => "Rider ID is required"]);
    exit;
}

// ------------------ GET AVAILABILITY STATUS ------------------
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "SELECT 
        availability_status,
        current_location_lat,
        current_location_lng,
        last_location_update
    FROM riders 
    WHERE rider_id = ?";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $rider_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        echo json_encode(["status" => "error", "message" => "Rider not found"]);
        exit;
    }

    $rider = $result->fetch_assoc();

    echo json_encode([
        "status" => "success",
        "availability_status" => $rider['availability_status'],
        "current_location" => [
            "latitude" => $rider['current_location_lat'],
            "longitude" => $rider['current_location_lng'],
            "last_update" => $rider['last_location_update']
        ]
    ]);
}

// ------------------ UPDATE AVAILABILITY STATUS ------------------
elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $availability_status = $input['availability_status'] ?? null;
    $latitude = $input['latitude'] ?? null;
    $longitude = $input['longitude'] ?? null;

    if (empty($availability_status)) {
        echo json_encode(["status" => "error", "message" => "Availability status is required"]);
        exit;
    }

    // Validate availability status
    $valid_statuses = ['available', 'busy', 'offline'];
    if (!in_array($availability_status, $valid_statuses)) {
        echo json_encode(["status" => "error", "message" => "Invalid availability status"]);
        exit;
    }

    $sql = "UPDATE riders SET 
        availability_status = ?";
    
    $params = [$availability_status];
    $types = "s";

    // Update location if provided
    if (!empty($latitude) && !empty($longitude)) {
        $sql .= ", current_location_lat = ?, current_location_lng = ?, last_location_update = NOW()";
        $params[] = $latitude;
        $params[] = $longitude;
        $types .= "dd";
    }

    $sql .= " WHERE rider_id = ?";
    $params[] = $rider_id;
    $types .= "i";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param($types, ...$params);

    if ($stmt->execute()) {
        // Log availability change
        $log_sql = "INSERT INTO rider_availability_logs 
            (rider_id, status, latitude, longitude, created_at) 
            VALUES (?, ?, ?, ?, NOW())";
        
        $log_stmt = $conn->prepare($log_sql);
        $log_stmt->bind_param("isdd", $rider_id, $availability_status, $latitude, $longitude);
        $log_stmt->execute();

        echo json_encode([
            "status" => "success", 
            "message" => "Availability status updated successfully",
            "availability_status" => $availability_status
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to update availability status"]);
    }
}

// ------------------ INVALID METHOD ------------------
else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}

$conn->close();
?>