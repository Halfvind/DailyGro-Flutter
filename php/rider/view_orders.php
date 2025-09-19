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

$order_id = intval($_GET['order_id'] ?? $_POST['order_id'] ?? 0);
$rider_id = intval($_GET['rider_id'] ?? $_POST['rider_id'] ?? 0);

if (empty($order_id)) {
    echo json_encode(["status" => "error", "message" => "Order ID is required"]);
    exit;
}

// ------------------ GET ORDER TRACKING INFO ------------------
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "SELECT 
        o.order_id,
        o.order_number,
        o.status,
        o.total_amount,
        o.delivery_fee,
        o.pickup_address,
        o.delivery_address,
        o.pickup_lat,
        o.pickup_lng,
        o.delivery_lat,
        o.delivery_lng,
        o.delivery_instructions,
        o.delivery_otp,
        o.created_at,
        o.pickup_time,
        o.delivery_time,
        u.name as customer_name,
        u.phone as customer_phone,
        v.business_name as vendor_name,
        v.business_address as vendor_address,
        v.phone as vendor_phone,
        r.rider_id,
        ru.name as rider_name,
        ru.phone as rider_phone,
        r.vehicle_type,
        r.vehicle_number,
        r.current_location_lat,
        r.current_location_lng,
        r.last_location_update
    FROM orders o
    JOIN users u ON o.user_id = u.user_id
    JOIN vendors v ON o.vendor_id = v.vendor_id
    LEFT JOIN riders r ON o.rider_id = r.rider_id
    LEFT JOIN users ru ON r.user_id = ru.user_id
    WHERE o.order_id = ?";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $order_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        echo json_encode(["status" => "error", "message" => "Order not found"]);
        exit;
    }

    $order = $result->fetch_assoc();

    // Get order tracking history
    $tracking_sql = "SELECT 
        status,
        location_lat,
        location_lng,
        notes,
        created_at
    FROM order_tracking 
    WHERE order_id = ? 
    ORDER BY created_at ASC";

    $stmt = $conn->prepare($tracking_sql);
    $stmt->bind_param("i", $order_id);
    $stmt->execute();
    $tracking_result = $stmt->get_result();

    $tracking_history = [];
    while ($row = $tracking_result->fetch_assoc()) {
        $tracking_history[] = $row;
    }

    echo json_encode([
        "status" => "success",
        "order" => $order,
        "tracking_history" => $tracking_history
    ]);
}

// ------------------ UPDATE ORDER TRACKING ------------------
elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $status = $input['status'] ?? null;
    $latitude = $input['latitude'] ?? null;
    $longitude = $input['longitude'] ?? null;
    $notes = $input['notes'] ?? '';

    if (empty($rider_id)) {
        echo json_encode(["status" => "error", "message" => "Rider ID is required for tracking updates"]);
        exit;
    }

    if (empty($status)) {
        echo json_encode(["status" => "error", "message" => "Status is required"]);
        exit;
    }

    // Verify rider is assigned to this order
    $verify_sql = "SELECT rider_id FROM orders WHERE order_id = ? AND rider_id = ?";
    $stmt = $conn->prepare($verify_sql);
    $stmt->bind_param("ii", $order_id, $rider_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        echo json_encode(["status" => "error", "message" => "Order not assigned to this rider"]);
        exit;
    }

    // Insert tracking record
    $tracking_sql = "INSERT INTO order_tracking 
        (order_id, rider_id, status, location_lat, location_lng, notes, created_at) 
        VALUES (?, ?, ?, ?, ?, ?, NOW())";

    $stmt = $conn->prepare($tracking_sql);
    $stmt->bind_param("iisdds", $order_id, $rider_id, $status, $latitude, $longitude, $notes);

    if ($stmt->execute()) {
        // Update rider's current location if provided
        if (!empty($latitude) && !empty($longitude)) {
            $location_sql = "UPDATE riders SET 
                current_location_lat = ?,
                current_location_lng = ?,
                last_location_update = NOW()
            WHERE rider_id = ?";
            
            $stmt = $conn->prepare($location_sql);
            $stmt->bind_param("ddi", $latitude, $longitude, $rider_id);
            $stmt->execute();
        }

        echo json_encode([
            "status" => "success", 
            "message" => "Tracking updated successfully"
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to update tracking"]);
    }
}

// ------------------ INVALID METHOD ------------------
else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}

$conn->close();
?>