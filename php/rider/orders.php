<?php
require_once '../config.php';
header('Content-Type: application/json');

$rider_id = $_GET['rider_id'] ?? null;
$status = $_GET['status'] ?? null;

if (!$rider_id) {
    echo json_encode(['status' => 'error', 'message' => 'Rider ID required']);
    exit;
}

try {
    $query = "SELECT o.*, u.name as customer_name, u.phone as customer_phone,
              a.address_line, a.city, a.pincode, a.latitude, a.longitude,
              v.business_name as vendor_name,
              GROUP_CONCAT(CONCAT(oi.quantity, 'x ', p.name) SEPARATOR ', ') as items
              FROM orders o 
              JOIN users u ON o.user_id = u.user_id 
              JOIN addresses a ON o.address_id = a.address_id
              JOIN vendors v ON o.vendor_id = v.vendor_id
              LEFT JOIN order_items oi ON o.order_id = oi.order_id
              LEFT JOIN products p ON oi.product_id = p.product_id
              WHERE (o.rider_id = ? OR (o.rider_id IS NULL AND o.status = 'ready'))";
    
    $params = [$rider_id];
    
    if ($status) {
        $query .= " AND o.status = ?";
        $params[] = $status;
    }
    
    $query .= " GROUP BY o.order_id ORDER BY o.created_at DESC";
    
    $stmt = $pdo->prepare($query);
    $stmt->execute($params);
    $orders = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'status' => 'success',
        'orders' => $orders,
        'count' => count($orders)
    ]);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
}
?>