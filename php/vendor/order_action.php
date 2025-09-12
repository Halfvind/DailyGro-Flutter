<?php
require_once '../config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'error', 'message' => 'Method not allowed']);
    exit;
}

$order_id = $_POST['order_id'] ?? null;
$action = $_POST['action'] ?? null; // accept, reject, ready
$vendor_id = $_POST['vendor_id'] ?? null;

if (!$order_id || !$action || !$vendor_id) {
    echo json_encode(['status' => 'error', 'message' => 'Required fields missing']);
    exit;
}

try {
    // Verify order belongs to vendor
    $stmt = $pdo->prepare("SELECT order_id FROM orders WHERE order_id = ? AND vendor_id = ?");
    $stmt->execute([$order_id, $vendor_id]);
    
    if (!$stmt->fetch()) {
        echo json_encode(['status' => 'error', 'message' => 'Order not found']);
        exit;
    }
    
    $new_status = '';
    $message = '';
    
    switch ($action) {
        case 'accept':
            $new_status = 'confirmed';
            $message = 'Order accepted successfully';
            break;
        case 'reject':
            $new_status = 'cancelled';
            $message = 'Order rejected';
            break;
        case 'ready':
            $new_status = 'ready';
            $message = 'Order marked as ready';
            break;
        default:
            echo json_encode(['status' => 'error', 'message' => 'Invalid action']);
            exit;
    }
    
    // Update order status
    $stmt = $pdo->prepare("UPDATE orders SET status = ? WHERE order_id = ?");
    $stmt->execute([$new_status, $order_id]);
    
    // Add tracking entry
    $stmt = $pdo->prepare("INSERT INTO order_tracking (order_id, status, message) VALUES (?, ?, ?)");
    $stmt->execute([$order_id, $new_status, $message]);
    
    echo json_encode([
        'status' => 'success',
        'message' => $message,
        'new_status' => $new_status
    ]);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
}
?>