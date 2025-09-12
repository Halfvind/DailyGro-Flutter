<?php
require_once '../config.php';
header('Content-Type: application/json');

$vendor_id = $_GET['vendor_id'] ?? null;
$period = $_GET['period'] ?? 'today'; // today, week, month, year

if (!$vendor_id) {
    echo json_encode(['status' => 'error', 'message' => 'Vendor ID required']);
    exit;
}

try {
    $date_condition = '';
    switch ($period) {
        case 'today':
            $date_condition = "DATE(o.created_at) = CURDATE()";
            break;
        case 'week':
            $date_condition = "WEEK(o.created_at) = WEEK(CURDATE()) AND YEAR(o.created_at) = YEAR(CURDATE())";
            break;
        case 'month':
            $date_condition = "MONTH(o.created_at) = MONTH(CURDATE()) AND YEAR(o.created_at) = YEAR(CURDATE())";
            break;
        case 'year':
            $date_condition = "YEAR(o.created_at) = YEAR(CURDATE())";
            break;
    }
    
    // Get earnings summary
    $stmt = $pdo->prepare("SELECT 
                          COUNT(*) as total_orders,
                          SUM(CASE WHEN o.status = 'delivered' THEN o.total_amount ELSE 0 END) as total_earnings,
                          SUM(CASE WHEN o.status = 'delivered' THEN 1 ELSE 0 END) as completed_orders,
                          SUM(CASE WHEN o.status = 'cancelled' THEN 1 ELSE 0 END) as cancelled_orders
                          FROM orders o 
                          WHERE o.vendor_id = ? AND $date_condition");
    $stmt->execute([$vendor_id]);
    $summary = $stmt->fetch(PDO::FETCH_ASSOC);
    
    // Get recent orders
    $stmt = $pdo->prepare("SELECT o.order_number, o.total_amount, o.status, o.created_at, u.name as customer_name
                          FROM orders o 
                          JOIN users u ON o.user_id = u.user_id
                          WHERE o.vendor_id = ? AND $date_condition
                          ORDER BY o.created_at DESC LIMIT 10");
    $stmt->execute([$vendor_id]);
    $recent_orders = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'status' => 'success',
        'period' => $period,
        'summary' => $summary,
        'recent_orders' => $recent_orders
    ]);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
}
?>