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

// ------------------ GET RIDER PROFILE ------------------
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (!isset($_GET['id']) || empty($_GET['id'])) {
        echo json_encode(["status" => "error", "message" => "User ID is required"]);
        exit;
    }

    $id = intval($_GET['id']);

    $sql = "SELECT
        u.user_id,
        u.name AS user_name,
        u.email AS user_email,
        u.phone AS user_phone,
        r.role_name,
        u.created_at,
        rd.rider_id,
        rd.vehicle_type,
        rd.vehicle_number,
        rd.license_number,
        rd.verification_status,
        rd.rating,
        rd.availability_status,
        rd.current_location_lat,
        rd.current_location_lng,
        rd.bank_account_number,
        rd.upi_id,
        rd.emergency_contact_name,
        rd.emergency_contact_phone
    FROM users u
    JOIN roles ro ON u.role_id = ro.role_id
    JOIN riders rd ON u.user_id = rd.user_id
    WHERE u.user_id = ? AND u.status = 'active'";

    $stmt = $conn->prepare($sql);
    if (!$stmt) {
        echo json_encode(["status" => "error", "message" => "Prepare failed: " . $conn->error]);
        exit;
    }

    $stmt->bind_param("i", $id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        echo json_encode(["status" => "error", "message" => "Rider not found"]);
        exit;
    }

    $rider = $result->fetch_assoc();

    echo json_encode([
        "status" => "success",
        "user_profile" => [
            "rider_id"                => $rider['rider_id'],
            "rider_name"              => $rider['user_name'],
            "rider_email"             => $rider['user_email'],
            "contact_number"          => $rider['user_phone'],
            "vehicle_type"            => $rider['vehicle_type'],
            "vehicle_number"          => $rider['vehicle_number'],
            "license_number"          => $rider['license_number'],
            "verification_status"     => $rider['verification_status'],
            "rating"                  => (float)$rider['rating'],
            "availability_status"     => $rider['availability_status'],
            "current_location_lat"    => $rider['current_location_lat'],
            "current_location_lng"    => $rider['current_location_lng'],
            "bank_account_number"     => $rider['bank_account_number'],
            "upi_id"                  => $rider['upi_id'],
            "emergency_contact_name"  => $rider['emergency_contact_name'],
            "emergency_contact_phone" => $rider['emergency_contact_phone'],
            "created_at"              => $rider['created_at']
        ]
    ]);

    $stmt->close();
    $conn->close();
    exit;
}

// ------------------ UPDATE RIDER PROFILE ------------------
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);

    $rider_id = intval($input['rider_id'] ?? 0);
    $rider_name = $input['rider_name'] ?? null;
    $rider_email = $input['rider_email'] ?? null;
    $contact_number = $input['contact_number'] ?? null;
    $vehicle_type = $input['vehicle_type'] ?? null;
    $vehicle_number = $input['vehicle_number'] ?? null;
    $license_number = $input['license_number'] ?? null;
    $verification_status = $input['verification_status'] ?? null;
    $rating = is_numeric($input['rating']) ? $input['rating'] : 0.0;
    $availability_status = $input['availability_status'] ?? 'available';
    $current_location_lat = $input['current_location_lat'] ?? null;
    $current_location_lng = $input['current_location_lng'] ?? null;
    $bank_account_number = $input['bank_account_number'] ?? null;
    $upi_id = $input['upi_id'] ?? null;
    $emergency_contact_name = $input['emergency_contact_name'] ?? null;
    $emergency_contact_phone = $input['emergency_contact_phone'] ?? null;

    if (empty($rider_id) || empty($rider_name) || empty($rider_email) || empty($contact_number)) {
        echo json_encode(["status" => "error", "message" => "Rider ID, Name, Email, and Contact Number are required"]);
        exit;
    }

    // ------------------ Update riders table ------------------
    $sql_rider = "UPDATE riders SET
        vehicle_type = ?,
        vehicle_number = ?,
        license_number = ?,
        verification_status = ?,
        rating = ?,
        availability_status = ?,
        current_location_lat = ?,
        current_location_lng = ?,
        bank_account_number = ?,
        upi_id = ?,
        emergency_contact_name = ?,
        emergency_contact_phone = ?
    WHERE rider_id = ?";

    $stmt_rider = $conn->prepare($sql_rider);
    if (!$stmt_rider) {
        echo json_encode(["status" => "error", "message" => "Prepare riders failed: " . $conn->error]);
        exit;
    }

    $stmt_rider->bind_param(
        "ssssssssssssi",
        $vehicle_type,
        $vehicle_number,
        $license_number,
        $verification_status,
        $rating,
        $availability_status,
        $current_location_lat,
        $current_location_lng,
        $bank_account_number,
        $upi_id,
        $emergency_contact_name,
        $emergency_contact_phone,
        $rider_id
    );

    $stmt_rider->execute();

    // ------------------ Update users table ------------------
    $sql_user = "UPDATE users SET
        name = ?,
        email = ?,
        phone = ?
    WHERE user_id = (SELECT user_id FROM riders WHERE rider_id = ?)";

    $stmt_user = $conn->prepare($sql_user);
    if (!$stmt_user) {
        echo json_encode(["status" => "error", "message" => "Prepare users failed: " . $conn->error]);
        exit;
    }

    $stmt_user->bind_param(
        "sssi",
        $rider_name,
        $rider_email,
        $contact_number,
        $rider_id
    );

    if ($stmt_user->execute()) {
        echo json_encode(["status" => "success", "message" => "Rider profile updated successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Update failed: " . $stmt_user->error]);
    }

    $stmt_rider->close();
    $stmt_user->close();
    $conn->close();
    exit;
}

// ------------------ INVALID METHOD ------------------
echo json_encode(["status" => "error", "message" => "Invalid request method"]);
$conn->close();
?>