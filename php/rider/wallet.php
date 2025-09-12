<?php
require_once '../config.php';
header('Content-Type: application/json');

$rider_id = $_GET['rider_id'] ?? null;

if (!$rider_id) {
    echo json_encode(['status' => 'error', 'message' => 'Rider ID required']);
    exit;
}

try {
    // Get rider user_id
    $stmt = $pdo->prepare("SELECT user_id FROM riders WHERE rider_id = ?");
    $stmt->execute([$rider_id]);
    $rider = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$rider) {
        echo json_encode(['status' => 'error', 'message' => 'Rider not found']);
        exit;
    }
    
    // Get or create wallet
    $stmt = $pdo->prepare("SELECT * FROM wallet WHERE user_id = ?");
    $stmt->execute([$rider['user_id']]);
    $wallet = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$wallet) {
        $stmt = $pdo->prepare("INSERT INTO wallet (user_id, balance) VALUES (?, 0.00)");
        $stmt->execute([$rider['user_id']]);
        $wallet_id = $pdo->lastInsertId();
        $balance = 0.00;
    } else {
        $wallet_id = $wallet['wallet_id'];
        $balance = $wallet['balance'];
    }
    
    // Get recent transactions
    $stmt = $pdo->prepare("SELECT wt.*, o.order_number 
                          FROM wallet_transactions wt 
                          LEFT JOIN orders o ON wt.order_id = o.order_id
                          WHERE wt.wallet_id = ? 
                          ORDER BY wt.created_at DESC LIMIT 20");
    $stmt->execute([$wallet_id]);
    $transactions = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'status' => 'success',
        'wallet_id' => $wallet_id,
        'balance' => $balance,
        'transactions' => $transactions
    ]);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
}
?>