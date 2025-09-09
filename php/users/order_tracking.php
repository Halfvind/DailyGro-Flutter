<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, PUT");
header("Access-Control-Allow-Headers: Content-Type");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "DailyGro";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Database connection failed"]);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];
switch ($method) {
    case 'GET':
        getOrderTracking();
        break;
    case 'PUT':
        updateOrderStatus();
        break;
    default:
        echo json_encode(["status" => "error", "message" => "Method not allowed"]);
}

function getOrderTracking() {
    global $conn;

    if (!isset($_GET['order_id'])) {
        echo json_encode(["status" => "error", "message" => "Order ID is required"]);
        exit;
    }

    $orderId = intval($_GET['order_id']);

    // Corrected: join with addresses using 'address_id' and users for rider info
    $orderSql = "SELECT o.*,
                        a.address_line, a.city, a.state, a.pincode, a.name AS delivery_name, a.phone,
                        ru.name AS rider_name, ru.phone AS rider_phone, r.vehicle_number
                 FROM orders o
                 LEFT JOIN addresses a ON o.address_id = a.address_id
                 LEFT JOIN riders r ON o.rider_id = r.rider_id
                 LEFT JOIN users ru ON r.user_id = ru.user_id
                 WHERE o.order_id = ?";

    $orderStmt = $conn->prepare($orderSql);
    $orderStmt->bind_param("i", $orderId);
    $orderStmt->execute();
    $orderResult = $orderStmt->get_result();

    if ($orderResult->num_rows === 0) {
        echo json_encode(["status" => "error", "message" => "Order not found"]);
        exit;
    }

    $order = $orderResult->fetch_assoc();

    $trackingSql = "SELECT * FROM order_tracking WHERE order_id = ? ORDER BY created_at ASC";
    $trackingStmt = $conn->prepare($trackingSql);
    $trackingStmt->bind_param("i", $orderId);
    $trackingStmt->execute();
    $trackingResult = $trackingStmt->get_result();

    $trackingHistory = [];
    while ($tracking = $trackingResult->fetch_assoc()) {
        $trackingHistory[] = [
            'status' => $tracking['status'],
            'message' => $tracking['message'],
            'location' => $tracking['location'],
            'timestamp' => $tracking['created_at']
        ];
    }

    $statusSteps = [
        'pending' => ['title' => 'Order Placed', 'description' => 'Your order has been placed successfully'],
        'confirmed' => ['title' => 'Order Confirmed', 'description' => 'Your order has been confirmed by the vendor'],
        'preparing' => ['title' => 'Preparing', 'description' => 'Your order is being prepared'],
        'ready' => ['title' => 'Ready for Pickup', 'description' => 'Your order is ready for pickup'],
        'picked_up' => ['title' => 'Picked Up', 'description' => 'Your order has been picked up by the delivery partner'],
        'delivered' => ['title' => 'Delivered', 'description' => 'Your order has been delivered successfully'],
        'cancelled' => ['title' => 'Cancelled', 'description' => 'Your order has been cancelled']
    ];

    $currentStatus = $order['status'];
    $statusKeys = array_keys($statusSteps);
    $statusIndex = array_search($currentStatus, $statusKeys);

    echo json_encode([
        "status" => "success",
        "message" => "Order tracking retrieved successfully",
        "order_tracking" => [
            'order_id' => $order['order_id'],
            'order_number' => $order['order_number'],
            'current_status' => $currentStatus,
            'current_status_info' => $statusSteps[$currentStatus] ?? null,
            'estimated_delivery' => $order['estimated_delivery'],
            'delivery_address' => [
                'name' => $order['delivery_name'],
                'phone' => $order['phone'],
                'address' => $order['address_line'] . ', ' . $order['city'] . ', ' . $order['state'] . ' - ' . $order['pincode']
            ],
            'rider_info' => $order['rider_name'] ? [
                'name' => $order['rider_name'],
                'phone' => $order['rider_phone'],
                'vehicle_number' => $order['vehicle_number']
            ] : null,
            'status_steps' => array_map(function($key, $step) use ($currentStatus, $statusIndex, $statusKeys) {
                $stepIndex = array_search($key, $statusKeys);
                return [
                    'status' => $key,
                    'title' => $step['title'],
                    'description' => $step['description'],
                    'completed' => $stepIndex <= $statusIndex && $currentStatus !== 'cancelled',
                    'active' => $key === $currentStatus
                ];
            }, $statusKeys, $statusSteps),
            'tracking_history' => $trackingHistory,
            'created_at' => $order['created_at']
        ]
    ]);

    $orderStmt->close();
    $trackingStmt->close();
}

function updateOrderStatus() {
    global $conn;

    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['order_id'], $data['status'])) {
        echo json_encode(["status" => "error", "message" => "Order ID and status are required"]);
        exit;
    }

    $orderId = intval($data['order_id']);
    $status = $data['status'];
    $message = $data['message'] ?? '';
    $location = $data['location'] ?? '';

    $validStatuses = ['pending', 'confirmed', 'preparing', 'ready', 'picked_up', 'delivered', 'cancelled'];
    if (!in_array($status, $validStatuses)) {
        echo json_encode(["status" => "error", "message" => "Invalid status value"]);
        exit;
    }

    $conn->begin_transaction();

    try {
        $updateSql = "UPDATE orders SET status = ? WHERE order_id = ?";
        $updateStmt = $conn->prepare($updateSql);
        $updateStmt->bind_param("si", $status, $orderId);
        $updateStmt->execute();

        $trackingSql = "INSERT INTO order_tracking (order_id, status, message, location) VALUES (?, ?, ?, ?)";
        $trackingStmt = $conn->prepare($trackingSql);
        $trackingStmt->bind_param("isss", $orderId, $status, $message, $location);
        $trackingStmt->execute();

        $conn->commit();

        echo json_encode([
            "status" => "success",
            "message" => "Order status updated successfully"
        ]);

        $updateStmt->close();
        $trackingStmt->close();

    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(["status" => "error", "message" => "Failed to update order status: " . $e->getMessage()]);
    }
}

$conn->close();
?>
