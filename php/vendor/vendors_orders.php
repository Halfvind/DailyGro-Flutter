<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

require_once '../config.php';

// Normalize GET parameters (fix 'amp;vendor_id' issue)
foreach ($_GET as $key => $value) {
    if (strpos($key, 'amp;') === 0) {
        $_GET[substr($key, 4)] = $value;
    }
}

$method = $_SERVER['REQUEST_METHOD'];
$type   = $_GET['type'] ?? null;

// Debugging logs
file_put_contents('debug.log', "----------------------------------\n", FILE_APPEND);
file_put_contents('debug.log', "Request Method: $method\n", FILE_APPEND);
file_put_contents('debug.log', "GET Params: " . print_r($_GET, true) . "\n", FILE_APPEND);
file_put_contents('debug.log', "POST Data: " . file_get_contents('php://input') . "\n", FILE_APPEND);

try {
    switch ($type) {
        case 'list_orders':
            if ($method === 'GET') listOrders();
            else methodNotAllowed();
            break;
        case 'mark_ready':
            if ($method === 'POST') markOrderAsReady();
            else methodNotAllowed();
            break;
        case 'accept_order':
            if ($method === 'POST') acceptOrder();
            else methodNotAllowed();
            break;
        case 'reject_order':
            if ($method === 'POST') rejectOrder();
            else methodNotAllowed();
            break;
        default:
            methodNotAllowed();
    }
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
    exit;
}

function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(['status' => 'error', 'message' => 'Method not allowed']);
    exit;
}

// ---------------------- LIST ORDERS ----------------------
function listOrders() {
    global $pdo;

    $vendor_id     = $_GET['vendor_id'] ?? null;
    $status_filter = $_GET['status'] ?? 'new';

    if (!$vendor_id) {
        echo json_encode(['status' => 'error', 'message' => 'Vendor ID is required']);
        exit;
    }

    $status_conditions = [
        'new'       => "LOWER(o.status) = 'pending'",
        'active'    => "LOWER(o.status) IN ('confirmed','preparing','ready')",
        'complete'  => "LOWER(o.status) = 'delivered'",
        'cancelled' => "LOWER(o.status) = 'cancelled'"
    ];

    if (!array_key_exists($status_filter, $status_conditions)) {
        echo json_encode(['status' => 'error', 'message' => 'Invalid status filter']);
        exit;
    }

    $sql = "SELECT o.order_id, o.order_number, o.status, o.total_amount, o.subtotal, o.payment_method, o.created_at,
                   a.address_line, a.city, a.state, a.pincode, a.name AS delivery_name, a.phone AS delivery_phone
            FROM orders o
            LEFT JOIN addresses a ON o.address_id = a.address_id
            WHERE o.vendor_id = ? AND {$status_conditions[$status_filter]}
            ORDER BY o.created_at DESC";

    $stmt = $pdo->prepare($sql);
    $stmt->execute([$vendor_id]);
    $orders = $stmt->fetchAll();

    foreach ($orders as &$order) {
        $items_sql = "SELECT
                        oi.item_id,
                        p.name AS product_name,
                        p.description AS product_description,
                        oi.unit_price AS price,
                        oi.total_price,
                        oi.quantity
                      FROM order_items oi
                      LEFT JOIN products p ON oi.product_id = p.product_id
                      WHERE oi.order_id = ?";

        $items_stmt = $pdo->prepare($items_sql);
        $items_stmt->execute([$order['order_id']]);
        $order_items = $items_stmt->fetchAll();

        $total_discount = floatval($order['subtotal']) - floatval($order['total_amount']);

        $order['order_items']    = $order_items;
        $order['total_discount'] = number_format($total_discount, 2);
    }

    echo json_encode(['status' => 'success', 'orders' => $orders]);
}


// ---------------------- MARK READY ----------------------
function markOrderAsReady() {
    global $pdo;

    $input = json_decode(file_get_contents('php://input'), true);
    $order_id = $input['order_id'] ?? null;
    $vendor_id = $input['vendor_id'] ?? null;

    if (!$order_id || !$vendor_id) {
        echo json_encode(['status' => 'error', 'message' => 'Order ID and Vendor ID are required']);
        exit;
    }

    $stmt = $pdo->prepare("SELECT status FROM orders WHERE order_id=? AND vendor_id=?");
    $stmt->execute([$order_id, $vendor_id]);
    $order = $stmt->fetch();

    if (!$order) {
        echo json_encode(['status' => 'error', 'message' => 'Order not found']);
        exit;
    }

    if (!in_array(strtolower($order['status']), ['confirmed', 'preparing'])) {
        echo json_encode(['status' => 'error', 'message' => 'Only confirmed or preparing orders can be marked as ready']);
        exit;
    }

    $pdo->prepare("UPDATE orders SET status='ready' WHERE order_id=?")->execute([$order_id]);
    $pdo->prepare("INSERT INTO order_tracking (order_id, status, message) VALUES (?, 'ready', 'Order marked as ready by vendor')")->execute([$order_id]);

    echo json_encode(['status' => 'success', 'message' => 'Order marked as ready successfully']);
}

// ---------------------- ACCEPT ORDER ----------------------
function acceptOrder() {
    global $pdo;

    $input = json_decode(file_get_contents('php://input'), true);
    $order_id = $input['order_id'] ?? null;
    $vendor_id = $input['vendor_id'] ?? null;

    if (!$order_id || !$vendor_id) {
        echo json_encode(['status' => 'error', 'message' => 'Order ID and Vendor ID are required']);
        exit;
    }

    $stmt = $pdo->prepare("SELECT status FROM orders WHERE order_id=? AND vendor_id=?");
    $stmt->execute([$order_id, $vendor_id]);
    $order = $stmt->fetch();

    if (!$order) {
        echo json_encode(['status' => 'error', 'message' => 'Order not found']);
        exit;
    }

    if (strtolower($order['status']) !== 'pending') {
        echo json_encode(['status' => 'error', 'message' => 'Only pending orders can be accepted']);
        exit;
    }

    $pdo->prepare("UPDATE orders SET status='confirmed' WHERE order_id=?")->execute([$order_id]);
    $pdo->prepare("INSERT INTO order_tracking (order_id, status, message) VALUES (?, 'confirmed', 'Order accepted by vendor')")->execute([$order_id]);

    echo json_encode(['status' => 'success', 'message' => 'Order accepted successfully']);
}

// ---------------------- REJECT ORDER ----------------------
function rejectOrder() {
    global $pdo;

    $input = json_decode(file_get_contents('php://input'), true);
    $order_id = $input['order_id'] ?? null;
    $vendor_id = $input['vendor_id'] ?? null;
    $reason = $input['reason'] ?? 'No reason provided';

    if (!$order_id || !$vendor_id) {
        echo json_encode(['status' => 'error', 'message' => 'Order ID and Vendor ID are required']);
        exit;
    }

    $stmt = $pdo->prepare("SELECT status FROM orders WHERE order_id=? AND vendor_id=?");
    $stmt->execute([$order_id, $vendor_id]);
    $order = $stmt->fetch();

    if (!$order) {
        echo json_encode(['status' => 'error', 'message' => 'Order not found']);
        exit;
    }

    if (strtolower($order['status']) !== 'pending') {
        echo json_encode(['status' => 'error', 'message' => 'Only pending orders can be rejected']);
        exit;
    }

    $pdo->prepare("UPDATE orders SET status='cancelled' WHERE order_id=?")->execute([$order_id]);
    $pdo->prepare("INSERT INTO order_tracking (order_id, status, message) VALUES (?, 'cancelled', ?)")
        ->execute([$order_id, 'Order rejected by vendor: ' . $reason]);

    echo json_encode(['status' => 'success', 'message' => 'Order rejected successfully']);
}
?>
