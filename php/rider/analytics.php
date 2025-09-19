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

$rider_id = intval($_GET['rider_id'] ?? 0);
$period = $_GET['period'] ?? 'today';

if (empty($rider_id)) {
    echo json_encode(["status" => "error", "message" => "Rider ID is required"]);
    exit;
}

// Get date condition based on period
$date_condition = getDateCondition($period);

// Get rider basic info
$rider_sql = "SELECT 
    r.rider_id,
    r.rating,
    r.availability_status,
    u.name as rider_name
FROM riders r
JOIN users u ON r.user_id = u.user_id
WHERE r.rider_id = ?";

$stmt = $conn->prepare($rider_sql);
$stmt->bind_param("i", $rider_id);
$stmt->execute();
$rider_result = $stmt->get_result();

if ($rider_result->num_rows === 0) {
    echo json_encode(["status" => "error", "message" => "Rider not found"]);
    exit;
}

$rider_info = $rider_result->fetch_assoc();

// Get delivery statistics
$stats_sql = "SELECT 
    COUNT(*) as total_deliveries,
    COUNT(CASE WHEN status = 'delivered' THEN 1 END) as completed_deliveries,
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) as cancelled_deliveries,
    AVG(CASE WHEN status = 'delivered' AND delivery_time IS NOT NULL AND pickup_time IS NOT NULL 
        THEN TIMESTAMPDIFF(MINUTE, pickup_time, delivery_time) END) as avg_delivery_time,
    SUM(CASE WHEN status = 'delivered' THEN delivery_fee ELSE 0 END) as total_earnings,
    AVG(delivery_fee) as avg_delivery_fee
FROM orders 
WHERE rider_id = ? $date_condition";

$stmt = $conn->prepare($stats_sql);
$stmt->bind_param("i", $rider_id);
$stmt->execute();
$stats_result = $stmt->get_result();
$stats = $stats_result->fetch_assoc();

// Get hourly performance
$hourly_sql = "SELECT 
    HOUR(created_at) as hour,
    COUNT(*) as deliveries,
    SUM(CASE WHEN status = 'delivered' THEN delivery_fee ELSE 0 END) as earnings
FROM orders 
WHERE rider_id = ? $date_condition
GROUP BY HOUR(created_at)
ORDER BY hour";

$stmt = $conn->prepare($hourly_sql);
$stmt->bind_param("i", $rider_id);
$stmt->execute();
$hourly_result = $stmt->get_result();

$hourly_performance = [];
while ($row = $hourly_result->fetch_assoc()) {
    $hourly_performance[] = $row;
}

// Get top areas
$areas_sql = "SELECT 
    SUBSTRING_INDEX(delivery_address, ',', -2) as area,
    COUNT(*) as deliveries,
    SUM(delivery_fee) as earnings
FROM orders 
WHERE rider_id = ? $date_condition AND status = 'delivered'
GROUP BY area
ORDER BY deliveries DESC
LIMIT 5";

$stmt = $conn->prepare($areas_sql);
$stmt->bind_param("i", $rider_id);
$stmt->execute();
$areas_result = $stmt->get_result();

$top_areas = [];
while ($row = $areas_result->fetch_assoc()) {
    $top_areas[] = $row;
}

// Get recent performance trend (last 7 days)
$trend_sql = "SELECT 
    DATE(created_at) as date,
    COUNT(*) as deliveries,
    COUNT(CASE WHEN status = 'delivered' THEN 1 END) as completed,
    SUM(CASE WHEN status = 'delivered' THEN delivery_fee ELSE 0 END) as earnings
FROM orders 
WHERE rider_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY DATE(created_at)
ORDER BY date";

$stmt = $conn->prepare($trend_sql);
$stmt->bind_param("i", $rider_id);
$stmt->execute();
$trend_result = $stmt->get_result();

$performance_trend = [];
while ($row = $trend_result->fetch_assoc()) {
    $performance_trend[] = $row;
}

// Calculate completion rate
$completion_rate = $stats['total_deliveries'] > 0 
    ? round(($stats['completed_deliveries'] / $stats['total_deliveries']) * 100, 2) 
    : 0;

echo json_encode([
    "status" => "success",
    "period" => $period,
    "rider_info" => $rider_info,
    "summary" => [
        "total_deliveries" => (int)$stats['total_deliveries'],
        "completed_deliveries" => (int)$stats['completed_deliveries'],
        "cancelled_deliveries" => (int)$stats['cancelled_deliveries'],
        "completion_rate" => $completion_rate,
        "avg_delivery_time" => round($stats['avg_delivery_time'] ?? 0, 1),
        "total_earnings" => number_format($stats['total_earnings'] ?? 0, 2),
        "avg_delivery_fee" => number_format($stats['avg_delivery_fee'] ?? 0, 2)
    ],
    "hourly_performance" => $hourly_performance,
    "top_areas" => $top_areas,
    "performance_trend" => $performance_trend
]);

function getDateCondition($period) {
    switch ($period) {
        case 'today':
            return "AND DATE(created_at) = CURDATE()";
        case 'week':
            return "AND created_at >= DATE_SUB(NOW(), INTERVAL 1 WEEK)";
        case 'month':
            return "AND created_at >= DATE_SUB(NOW(), INTERVAL 1 MONTH)";
        case 'year':
            return "AND created_at >= DATE_SUB(NOW(), INTERVAL 1 YEAR)";
        default:
            return "AND DATE(created_at) = CURDATE()";
    }
}

$conn->close();
?>