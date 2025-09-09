<?php
// Enable error reporting (for debugging 500 errors)
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST");
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
        if (isset($_GET['order_id'])) {
            getOrderDetails();
        } else {
            getOrdersList();
        }
        break;
    case 'POST':
        createOrder();
        break;
    default:
        echo json_encode(["status" => "error", "message" => "Method not allowed"]);
}

function getOrdersList() {
    global $conn;

    if (!isset($_GET['user_id'])) {
        echo json_encode(["status" => "error", "message" => "User ID is required"]);
        exit;
    }

    $userId = intval($_GET['user_id']);

    $sql = "SELECT o.*, a.address_line, a.city, a.state, a.pincode
            FROM orders o
            LEFT JOIN addresses a ON o.address_id = a.address_id
            WHERE o.user_id = ?
            ORDER BY o.created_at DESC";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $result = $stmt->get_result();

    $orders = [];

    while ($row = $result->fetch_assoc()) {
        $orders[] = [
            'order_id' => $row['order_id'],
            'order_number' => $row['order_number'],
            'total_amount' => (float)$row['total_amount'],
            'status' => $row['status'],
            'payment_status' => $row['payment_status'],
            'delivery_address' => $row['address_line'] . ', ' . $row['city'] . ', ' . $row['state'] . ' - ' . $row['pincode'],
            'created_at' => $row['created_at'],
            'estimated_delivery' => $row['estimated_delivery_date']
        ];
    }

    echo json_encode([
        "status" => "success",
        "message" => "Orders retrieved successfully",
        "orders" => $orders
    ]);

    $stmt->close();
}

function getOrderDetails() {
    global $conn;

    $orderId = intval($_GET['order_id']);

    $orderSql = "SELECT o.*, a.address_line, a.city, a.state, a.pincode, a.name as delivery_name, a.phone
                 FROM orders o
                 LEFT JOIN addresses a ON o.address_id = a.address_id
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

    $itemsSql = "SELECT oi.*, p.name, p.image
                 FROM order_items oi
                 JOIN products p ON oi.product_id = p.product_id
                 WHERE oi.order_id = ?";

    $itemsStmt = $conn->prepare($itemsSql);
    $itemsStmt->bind_param("i", $orderId);
    $itemsStmt->execute();
    $itemsResult = $itemsStmt->get_result();

    $items = [];
    while ($item = $itemsResult->fetch_assoc()) {
        $items[] = [
            'product_id' => $item['product_id'],
            'name' => $item['name'],
            'quantity' => (int)$item['quantity'],
            'price' => (float)$item['unit_price'],
            'total' => (float)$item['total_price'],
            'image' => $item['image']
        ];
    }

    echo json_encode([
        "status" => "success",
        "message" => "Order details retrieved successfully",
        "order" => [
            'order_id' => $order['order_id'],
            'order_number' => $order['order_number'],
            'total_amount' => (float)$order['total_amount'],
            'status' => $order['status'],
            'payment_status' => $order['payment_status'],
            'payment_method' => $order['payment_method'],
            'delivery_address' => [
                'name' => $order['delivery_name'],
                'phone' => $order['phone'],
                'address' => $order['address_line'] . ', ' . $order['city'] . ', ' . $order['state'] . ' - ' . $order['pincode']
            ],
            'created_at' => $order['created_at'],
            'estimated_delivery' => $order['estimated_delivery_date'],
            'items' => $items
        ]
    ]);

    $orderStmt->close();
    $itemsStmt->close();
}

function createOrder() {
    global $conn;

    $data = json_decode(file_get_contents("php://input"), true);

    if (!$data || !isset($data['user_id'], $data['items']) || !is_array($data['items']) || count($data['items']) === 0 || !isset($data['total_amount'])) {
        echo json_encode(["status" => "error", "message" => "User ID, items array, and total amount are required"]);
        exit;
    }

    $userId = intval($data['user_id']);
    $totalAmount = floatval($data['total_amount']);
    $deliveryAddressId = isset($data['address_id']) ? intval($data['address_id']) : 0;

    // Validate enum values
    $validPaymentMethods = ['cash', 'online', 'wallet'];

    $paymentMethod = $data['payment_method'] ?? 'cash';
    if (!in_array($paymentMethod, $validPaymentMethods)) {
        echo json_encode(["status" => "error", "message" => "Invalid payment_method"]);
        exit;
    }

    $orderNumber = 'ORD' . time() . rand(100, 999);

    $conn->begin_transaction();

    try {
        $firstProductId = intval($data['items'][0]['product_id']);
        $vendorFetchSql = "SELECT vendor_id FROM products WHERE product_id = ?";
        $vendorStmt = $conn->prepare($vendorFetchSql);
        $vendorStmt->bind_param("i", $firstProductId);
        $vendorStmt->execute();
        $vendorResult = $vendorStmt->get_result();
        $vendorRow = $vendorResult->fetch_assoc();
        $vendorStmt->close();

        if (!$vendorRow) {
            throw new Exception("Vendor not found for product_id: {$firstProductId}");
        }

        $vendorId = intval($vendorRow['vendor_id']);
        $subtotal = $totalAmount;

        $orderSql = "INSERT INTO orders (user_id, vendor_id, address_id, order_number, subtotal, total_amount, payment_method, payment_status, status, created_at)
                     VALUES (?, ?, ?, ?, ?, ?, ?, 'pending', 'pending', NOW())";
        $orderStmt = $conn->prepare($orderSql);
        $orderStmt->bind_param("iiisdds", $userId, $vendorId, $deliveryAddressId, $orderNumber, $subtotal, $totalAmount, $paymentMethod);
        $orderStmt->execute();

        $orderId = $conn->insert_id;

        $itemSql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?)";
        $itemStmt = $conn->prepare($itemSql);

        foreach ($data['items'] as $item) {
            if (!isset($item['product_id'], $item['quantity'], $item['price'])) {
                throw new Exception("Each item must have product_id, quantity, and price.");
            }

            $productId = intval($item['product_id']);
            $quantity = intval($item['quantity']);
            $unitPrice = floatval($item['price']);
            $totalPrice = $unitPrice * $quantity;

            $itemStmt->bind_param("iiidd", $orderId, $productId, $quantity, $unitPrice, $totalPrice);
            $itemStmt->execute();
        }

        $clearCartSql = "DELETE FROM cart WHERE user_id = ?";
        $clearCartStmt = $conn->prepare($clearCartSql);
        $clearCartStmt->bind_param("i", $userId);
        $clearCartStmt->execute();

        $conn->commit();

        echo json_encode([
            "status" => "success",
            "message" => "Order created successfully",
            "order_id" => $orderId,
            "order_number" => $orderNumber
        ]);

        $orderStmt->close();
        $itemStmt->close();
        $clearCartStmt->close();

    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode([
            "status" => "error",
            "message" => "Failed to create order: " . $e->getMessage()
        ]);
    }
}

$conn->close();
?>
