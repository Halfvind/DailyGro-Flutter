<?php
require_once '../config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'error', 'message' => 'Method not allowed']);
    exit;
}

$order_id = $_POST['order_id'] ?? null;
$action = $_POST['action'] ?? null; // accept, pickup, deliver
$rider_id = $_POST['rider_id'] ?? null;
$latitude = $_POST['latitude'] ?? null;
$longitude = $_POST['longitude'] ?? null;

if (!$order_id || !$action || !$rider_id) {
    echo json_encode(['status' => 'error', 'message' => 'Required fields missing']);
    exit;
}

try {
    $new_status = '';
    $message = '';
    
    switch ($action) {
        case 'accept':
            // Assign rider to order
            $stmt = $pdo->prepare("UPDATE orders SET rider_id = ?, status = 'picked_up' WHERE order_id = ? AND status = 'ready'");
            $stmt->execute([$rider_id, $order_id]);
            
            if ($stmt->rowCount() === 0) {
                echo json_encode(['status' => 'error', 'message' => 'Order not available']);
                exit;
            }
            
            $new_status = 'picked_up';
            $message = 'Order accepted by rider';
            break;
            
        case 'pickup':
            $stmt = $pdo->prepare("UPDATE orders SET status = 'picked_up' WHERE order_id = ? AND rider_id = ?");
            $stmt->execute([$order_id, $rider_id]);
            $new_status = 'picked_up';
            $message = 'Order picked up';
            break;
            
        case 'deliver':
            $stmt = $pdo->prepare("UPDATE orders SET status = 'delivered', delivered_at = NOW() WHERE order_id = ? AND rider_id = ?");
            $stmt->execute([$order_id, $rider_id]);
            $new_status = 'delivered';
            $message = 'Order delivered successfully';
            
            // Update rider total deliveries
            $stmt = $pdo->prepare("UPDATE riders SET total_deliveries = total_deliveries + 1 WHERE rider_id = ?");
            $stmt->execute([$rider_id]);
            break;
            
        default:
            echo json_encode(['status' => 'error', 'message' => 'Invalid action']);
            exit;
    }
    
    // Add tracking entry
    $stmt = $pdo->prepare("INSERT INTO order_tracking (order_id, status, message, latitude, longitude) VALUES (?, ?, ?, ?, ?)");
    $stmt->execute([$order_id, $new_status, $message, $latitude, $longitude]);
    
    echo json_encode([
        'status' => 'success',
        'message' => $message,
        'new_status' => $new_status
    ]);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
}
?>