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
$type = $_GET['type'] ?? 'all';

if (empty($rider_id)) {
    echo json_encode(["status" => "error", "message" => "Rider ID is required"]);
    exit;
}

// Get date range based on period
$date_condition = getDateCondition($period);

// Get rider wallet info
$wallet_sql = "SELECT 
    rw.wallet_id,
    rw.balance
FROM rider_wallets rw 
WHERE rw.rider_id = ?";

$stmt = $conn->prepare($wallet_sql);
$stmt->bind_param("i", $rider_id);
$stmt->execute();
$wallet_result = $stmt->get_result();

$wallet_balance = "0.00";
$wallet_id = null;

if ($wallet_result->num_rows > 0) {
    $wallet = $wallet_result->fetch_assoc();
    $wallet_balance = number_format($wallet['balance'], 2);
    $wallet_id = $wallet['wallet_id'];
}

// Get transactions
$transactions_sql = "SELECT 
    rwt.transaction_id,
    rwt.wallet_id,
    rwt.order_id,
    rwt.type,
    rwt.amount,
    rwt.description,
    rwt.reference_id,
    rwt.status,
    rwt.created_at,
    o.order_number,
    o.payment_method,
    CASE 
        WHEN o.status = 'delivered' THEN 'paid'
        ELSE 'pending'
    END as payment_status
FROM rider_wallet_transactions rwt
LEFT JOIN orders o ON rwt.order_id = o.order_id
WHERE rwt.rider_id = ? $date_condition
ORDER BY rwt.created_at DESC";

$stmt = $conn->prepare($transactions_sql);
$stmt->bind_param("i", $rider_id);
$stmt->execute();
$transactions_result = $stmt->get_result();

$transactions = [];
$total_earnings = 0;

while ($row = $transactions_result->fetch_assoc()) {
    if ($row['type'] === 'credit') {
        $total_earnings += $row['amount'];
    }
    $transactions[] = $row;
}

// Get summary statistics
$summary_sql = "SELECT 
    COUNT(DISTINCT o.order_id) as total_orders,
    COUNT(DISTINCT CASE WHEN o.status = 'delivered' THEN o.order_id END) as completed_orders,
    COUNT(DISTINCT CASE WHEN o.status = 'cancelled' THEN o.order_id END) as cancelled_orders,
    COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN o.delivery_fee ELSE 0 END), 0) as total_earnings
FROM orders o
WHERE o.rider_id = ? $date_condition";

$stmt = $conn->prepare($summary_sql);
$stmt->bind_param("i", $rider_id);
$stmt->execute();
$summary_result = $stmt->get_result();
$summary = $summary_result->fetch_assoc();

// Get recent orders
$orders_sql = "SELECT 
    o.order_number,
    o.total_amount,
    o.delivery_fee,
    o.status,
    o.payment_method,
    CASE 
        WHEN o.status = 'delivered' THEN 'paid'
        ELSE 'pending'
    END as payment_status,
    o.created_at,
    u.name as customer_name
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE o.rider_id = ? $date_condition
ORDER BY o.created_at DESC
LIMIT 10";

$stmt = $conn->prepare($orders_sql);
$stmt->bind_param("i", $rider_id);
$stmt->execute();
$orders_result = $stmt->get_result();

$recent_orders = [];
while ($row = $orders_result->fetch_assoc()) {
    $recent_orders[] = $row;
}

// Prepare response based on type
if ($type === 'wallet') {
    echo json_encode([
        "status" => "success",
        "wallet_id" => $wallet_id,
        "wallet_balance" => $wallet_balance,
        "transactions" => $transactions,
        "period" => $period,
        "summary" => [
            "total_orders" => (int)$summary['total_orders'],
            "total_earnings" => number_format($summary['total_earnings'], 2),
            "completed_orders" => (int)$summary['completed_orders'],
            "cancelled_orders" => (int)$summary['cancelled_orders']
        ],
        "recent_orders" => $recent_orders
    ]);
} else {
    echo json_encode([
        "status" => "success",
        "wallet_id" => $wallet_id,
        "balance" => $wallet_balance,
        "transactions" => $transactions,
        "period" => $period,
        "summary" => [
            "total_orders" => (int)$summary['total_orders'],
            "total_earnings" => number_format($summary['total_earnings'], 2),
            "completed_orders" => (int)$summary['completed_orders'],
            "cancelled_orders" => (int)$summary['cancelled_orders']
        ],
        "recent_orders" => $recent_orders
    ]);
}

function getDateCondition($period) {
    switch ($period) {
        case 'today':
            return "AND DATE(rwt.created_at) = CURDATE()";
        case 'week':
            return "AND rwt.created_at >= DATE_SUB(NOW(), INTERVAL 1 WEEK)";
        case 'month':
            return "AND rwt.created_at >= DATE_SUB(NOW(), INTERVAL 1 MONTH)";
        case 'year':
            return "AND rwt.created_at >= DATE_SUB(NOW(), INTERVAL 1 YEAR)";
        default:
            return "AND DATE(rwt.created_at) = CURDATE()";
    }
}

$conn->close();
?>