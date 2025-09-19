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

$type = $_GET['type'] ?? $_POST['type'] ?? '';
$rider_id = intval($_GET['rider_id'] ?? $_POST['rider_id'] ?? 0);

if (empty($rider_id)) {
    echo json_encode(["status" => "error", "message" => "Rider ID is required"]);
    exit;
}

switch ($type) {
    case 'available_orders':
        getAvailableOrders($conn);
        break;
    case 'my_orders':
        getMyOrders($conn, $rider_id);
        break;
    case 'accept_order':
        acceptOrder($conn, $rider_id);
        break;
    case 'pickup_order':
        pickupOrder($conn, $rider_id);
        break;
    case 'deliver_order':
        deliverOrder($conn, $rider_id);
        break;
    case 'update_location':
        updateLocation($conn, $rider_id);
        break;
    default:
        echo json_encode(["status" => "error", "message" => "Invalid type parameter"]);
}

function getAvailableOrders($conn) {
    $sql = "SELECT 
        o.order_id,
        o.order_number,
        o.total_amount,
        o.delivery_fee,
        o.status,
        o.created_at,
        o.pickup_address,
        o.delivery_address,
        o.delivery_lat,
        o.delivery_lng,
        o.pickup_lat,
        o.pickup_lng,
        o.delivery_instructions,
        u.name as customer_name,
        u.phone as customer_phone,
        v.business_name as vendor_name,
        v.business_address as vendor_address
    FROM orders o
    JOIN users u ON o.user_id = u.user_id
    JOIN vendors v ON o.vendor_id = v.vendor_id
    WHERE o.status = 'ready' AND o.rider_id IS NULL
    ORDER BY o.created_at ASC";

    $result = $conn->query($sql);
    $orders = [];

    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $orders[] = $row;
        }
    }

    echo json_encode([
        "status" => "success",
        "orders" => $orders
    ]);
}

function getMyOrders($conn, $rider_id) {
    $status = $_GET['status'] ?? 'all';
    
    $sql = "SELECT 
        o.order_id,
        o.order_number,
        o.total_amount,
        o.delivery_fee,
        o.status,
        o.created_at,
        o.pickup_time,
        o.delivery_time,
        o.pickup_address,
        o.delivery_address,
        o.delivery_lat,
        o.delivery_lng,
        o.pickup_lat,
        o.pickup_lng,
        o.delivery_instructions,
        u.name as customer_name,
        u.phone as customer_phone,
        v.business_name as vendor_name,
        v.business_address as vendor_address
    FROM orders o
    JOIN users u ON o.user_id = u.user_id
    JOIN vendors v ON o.vendor_id = v.vendor_id
    WHERE o.rider_id = ?";

    if ($status !== 'all') {
        $sql .= " AND o.status = ?";
    }
    
    $sql .= " ORDER BY o.created_at DESC";

    $stmt = $conn->prepare($sql);
    if ($status !== 'all') {
        $stmt->bind_param("is", $rider_id, $status);
    } else {
        $stmt->bind_param("i", $rider_id);
    }
    
    $stmt->execute();
    $result = $stmt->get_result();
    $orders = [];

    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $orders[] = $row;
        }
    }

    echo json_encode([
        "status" => "success",
        "orders" => $orders
    ]);
}

function acceptOrder($conn, $rider_id) {
    $input = json_decode(file_get_contents('php://input'), true);
    $order_id = intval($input['order_id'] ?? 0);

    if (empty($order_id)) {
        echo json_encode(["status" => "error", "message" => "Order ID is required"]);
        return;
    }

    // Check if order is still available
    $check_sql = "SELECT status FROM orders WHERE order_id = ? AND status = 'ready' AND rider_id IS NULL";
    $stmt = $conn->prepare($check_sql);
    $stmt->bind_param("i", $order_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        echo json_encode(["status" => "error", "message" => "Order not available or already assigned"]);
        return;
    }

    // Assign order to rider
    $sql = "UPDATE orders SET 
        rider_id = ?, 
        status = 'assigned',
        pickup_time = NOW()
    WHERE order_id = ?";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ii", $rider_id, $order_id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Order accepted successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to accept order"]);
    }
}

function pickupOrder($conn, $rider_id) {
    $input = json_decode(file_get_contents('php://input'), true);
    $order_id = intval($input['order_id'] ?? 0);

    if (empty($order_id)) {
        echo json_encode(["status" => "error", "message" => "Order ID is required"]);
        return;
    }

    $sql = "UPDATE orders SET 
        status = 'picked_up',
        pickup_time = NOW()
    WHERE order_id = ? AND rider_id = ? AND status = 'assigned'";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ii", $order_id, $rider_id);

    if ($stmt->execute() && $stmt->affected_rows > 0) {
        echo json_encode(["status" => "success", "message" => "Order picked up successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to update pickup status"]);
    }
}

function deliverOrder($conn, $rider_id) {
    $input = json_decode(file_get_contents('php://input'), true);
    $order_id = intval($input['order_id'] ?? 0);
    $delivery_otp = $input['delivery_otp'] ?? '';

    if (empty($order_id)) {
        echo json_encode(["status" => "error", "message" => "Order ID is required"]);
        return;
    }

    // Verify OTP if provided
    if (!empty($delivery_otp)) {
        $verify_sql = "SELECT delivery_otp FROM orders WHERE order_id = ? AND rider_id = ?";
        $stmt = $conn->prepare($verify_sql);
        $stmt->bind_param("ii", $order_id, $rider_id);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            if ($row['delivery_otp'] !== $delivery_otp) {
                echo json_encode(["status" => "error", "message" => "Invalid delivery OTP"]);
                return;
            }
        }
    }

    $sql = "UPDATE orders SET 
        status = 'delivered',
        delivery_time = NOW()
    WHERE order_id = ? AND rider_id = ? AND status = 'picked_up'";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ii", $order_id, $rider_id);

    if ($stmt->execute() && $stmt->affected_rows > 0) {
        // Update rider earnings
        updateRiderEarnings($conn, $rider_id, $order_id);
        echo json_encode(["status" => "success", "message" => "Order delivered successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to update delivery status"]);
    }
}

function updateLocation($conn, $rider_id) {
    $input = json_decode(file_get_contents('php://input'), true);
    $lat = $input['latitude'] ?? null;
    $lng = $input['longitude'] ?? null;

    if (empty($lat) || empty($lng)) {
        echo json_encode(["status" => "error", "message" => "Latitude and longitude are required"]);
        return;
    }

    $sql = "UPDATE riders SET 
        current_location_lat = ?,
        current_location_lng = ?,
        last_location_update = NOW()
    WHERE rider_id = ?";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ddi", $lat, $lng, $rider_id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Location updated successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to update location"]);
    }
}

function updateRiderEarnings($conn, $rider_id, $order_id) {
    // Get delivery fee from order
    $sql = "SELECT delivery_fee FROM orders WHERE order_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $order_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $delivery_fee = $row['delivery_fee'];
        
        // Add to rider wallet
        $wallet_sql = "INSERT INTO rider_wallet_transactions 
            (rider_id, order_id, type, amount, description, status, created_at) 
            VALUES (?, ?, 'credit', ?, 'Delivery earnings', 'completed', NOW())";
        
        $stmt = $conn->prepare($wallet_sql);
        $stmt->bind_param("iid", $rider_id, $order_id, $delivery_fee);
        $stmt->execute();
    }
}

$conn->close();
?>