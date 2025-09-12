<?php
require_once '../config.php';
header('Content-Type: application/json');

$rider_id = $_GET['rider_id'] ?? null;
$period = $_GET['period'] ?? 'today';

if (!$rider_id) {
    echo json_encode(['status' => 'error', 'message' => 'Rider ID required']);
    exit;
}

try {
    $date_condition = '';
    switch ($period) {
        case 'today':
            $date_condition = "DATE(o.delivered_at) = CURDATE()";
            break;
        case 'week':
            $date_condition = "WEEK(o.delivered_at) = WEEK(CURDATE()) AND YEAR(o.delivered_at) = YEAR(CURDATE())";
            break;
        case 'month':
            $date_condition = "MONTH(o.delivered_at) = MONTH(CURDATE()) AND YEAR(o.delivered_at) = YEAR(CURDATE())";
            break;
        case 'year':
            $date_condition = "YEAR(o.delivered_at) = YEAR(CURDATE())";
            break;
    }
    
    // Calculate earnings (assuming 10% of delivery fee + fixed amount per delivery)
    $stmt = $pdo->prepare("SELECT 
                          COUNT(*) as total_deliveries,
                          SUM(o.delivery_fee * 0.8) as delivery_earnings,
                          COUNT(*) * 20 as bonus_earnings,
                          SUM(o.delivery_fee * 0.8 + 20) as total_earnings
                          FROM orders o 
                          WHERE o.rider_id = ? AND o.status = 'delivered' AND $date_condition");
    $stmt->execute([$rider_id]);
    $summary = $stmt->fetch(PDO::FETCH_ASSOC);
    
    // Get recent deliveries
    $stmt = $pdo->prepare("SELECT o.order_number, o.delivery_fee, o.delivered_at, u.name as customer_name,
                          a.city, (o.delivery_fee * 0.8 + 20) as earning
                          FROM orders o 
                          JOIN users u ON o.user_id = u.user_id
                          JOIN addresses a ON o.address_id = a.address_id
                          WHERE o.rider_id = ? AND o.status = 'delivered' AND $date_condition
                          ORDER BY o.delivered_at DESC LIMIT 10");
    $stmt->execute([$rider_id]);
    $recent_deliveries = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'status' => 'success',
        'period' => $period,
        'summary' => $summary,
        'recent_deliveries' => $recent_deliveries
    ]);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
}
?>