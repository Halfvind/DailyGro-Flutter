<?php
require_once '../config.php';
header('Content-Type: application/json');

$vendor_id = $_GET['vendor_id'] ?? null;
$type = $_GET['type'] ?? 'all'; // wallet, earnings, all
$period = $_GET['period'] ?? 'today'; // today, week, month, year

if (!$vendor_id) {
    echo json_encode(['status' => 'error', 'message' => 'Vendor ID required']);
    exit;
}

try {
    // ---------------------- GET VENDOR AND WALLET ----------------------
    $stmt = $pdo->prepare("SELECT user_id FROM vendors WHERE vendor_id = ?");
    $stmt->execute([$vendor_id]);
    $vendor = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$vendor) {
        echo json_encode(['status' => 'error', 'message' => 'Vendor not found']);
        exit;
    }

    // Get or create wallet
    $stmt = $pdo->prepare("SELECT * FROM wallet WHERE user_id = ?");
    $stmt->execute([$vendor['user_id']]);
    $wallet = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$wallet) {
        $stmt = $pdo->prepare("INSERT INTO wallet (user_id, balance) VALUES (?, 0.00)");
        $stmt->execute([$vendor['user_id']]);
        $wallet_id = $pdo->lastInsertId();
        $balance = 0.00;
    } else {
        $wallet_id = $wallet['wallet_id'];
        $balance = floatval($wallet['balance']);
    }

    $response = [
        'wallet_id' => $wallet_id,
        'wallet_balance' => number_format($balance, 2),
    ];

    // ---------------------- UPDATE WALLET WITH DELIVERED ORDERS ----------------------
    $stmt = $pdo->prepare("
        SELECT order_id, total_amount, payment_method, payment_status
        FROM orders
        WHERE vendor_id = ? AND status = 'delivered' AND wallet_updated = 0
    ");
    $stmt->execute([$vendor_id]);
    $orders_to_update = $stmt->fetchAll(PDO::FETCH_ASSOC);

    foreach ($orders_to_update as $order) {
        $credit_amount = 0;
        $payment_method = strtolower($order['payment_method']);
        $payment_status = strtolower($order['payment_status']);

        if (($payment_method === 'online' || $payment_method === 'wallet') && $payment_status === 'paid') {
            $credit_amount = floatval($order['total_amount']);
        }

        if ($credit_amount > 0) {
            $balance += $credit_amount;
            $pdo->prepare("UPDATE wallet SET balance = ? WHERE wallet_id = ?")->execute([$balance, $wallet_id]);

            $pdo->prepare("
                INSERT INTO wallet_transactions
                (wallet_id, order_id, type, amount, description, reference_id, status, payment_mode, payment_status, created_at)
                VALUES (?, ?, 'credit', ?, 'Earnings from order', ?, 'completed', ?, ?, NOW())
            ")->execute([
                $wallet_id,
                $order['order_id'],
                $credit_amount,
                $order['order_id'],
                $payment_method,
                $payment_status
            ]);
        }

        $pdo->prepare("UPDATE orders SET wallet_updated = 1 WHERE order_id = ?")->execute([$order['order_id']]);
    }

    // ---------------------- WALLET TRANSACTIONS ----------------------
    if ($type === 'wallet' || $type === 'all') {
        $stmt = $pdo->prepare("SELECT wt.*, o.order_number
                               FROM wallet_transactions wt
                               LEFT JOIN orders o ON wt.order_id = o.order_id
                               WHERE wt.wallet_id = ?
                               ORDER BY wt.created_at DESC LIMIT 20");
        $stmt->execute([$wallet_id]);
        $transactions = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $response['transactions'] = $transactions;
    }

    // ---------------------- EARNINGS SUMMARY ----------------------
    if ($type === 'earnings' || $type === 'all') {
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
            default:
                $date_condition = "DATE(o.created_at) = CURDATE()";
                break;
        }

        $stmt = $pdo->prepare("
            SELECT
                COUNT(*) as total_orders,
                SUM(CASE WHEN o.status = 'delivered' THEN o.total_amount ELSE 0 END) as total_earnings,
                SUM(CASE WHEN o.status = 'delivered' THEN 1 ELSE 0 END) as completed_orders,
                SUM(CASE WHEN o.status = 'cancelled' THEN 1 ELSE 0 END) as cancelled_orders
            FROM orders o
            WHERE o.vendor_id = ? AND $date_condition
        ");
        $stmt->execute([$vendor_id]);
        $summary = $stmt->fetch(PDO::FETCH_ASSOC);

        $stmt = $pdo->prepare("
            SELECT o.order_number, o.total_amount, o.status, o.payment_method, o.payment_status, o.created_at, u.name as customer_name
            FROM orders o
            JOIN users u ON o.user_id = u.user_id
            WHERE o.vendor_id = ? AND $date_condition
            ORDER BY o.created_at DESC
            LIMIT 10
        ");
        $stmt->execute([$vendor_id]);
        $recent_orders = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $response['period'] = $period;
        $response['summary'] = $summary;
        $response['recent_orders'] = $recent_orders;
    }

    echo json_encode(array_merge(['status' => 'success'], $response));

} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
