<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "DailyGro";
$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Database connection failed"]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["status" => "error", "message" => "Method not allowed"]);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true);
$user_id = $input['user_id'] ?? null;
$order_id = $input['order_id'] ?? null;
$amount = $input['amount'] ?? null;

if (!$user_id || !$order_id || !$amount) {
    echo json_encode(["status" => "error", "message" => "Missing required fields"]);
    exit;
}

$conn->begin_transaction();

try {
    // Get wallet
    $wallet_sql = "SELECT wallet_id, balance FROM wallet WHERE user_id = ?";
    $wallet_stmt = $conn->prepare($wallet_sql);
    $wallet_stmt->bind_param("i", $user_id);
    $wallet_stmt->execute();
    $wallet_result = $wallet_stmt->get_result();
    
    if ($wallet_result->num_rows === 0) {
        throw new Exception("Wallet not found");
    }
    
    $wallet = $wallet_result->fetch_assoc();
    
    if ($wallet['balance'] < $amount) {
        throw new Exception("Insufficient balance");
    }
    
    // Deduct amount
    $new_balance = $wallet['balance'] - $amount;
    $update_sql = "UPDATE wallet SET balance = ? WHERE wallet_id = ?";
    $update_stmt = $conn->prepare($update_sql);
    $update_stmt->bind_param("di", $new_balance, $wallet['wallet_id']);
    $update_stmt->execute();
    
    // Add transaction
    $trans_sql = "INSERT INTO wallet_transactions (wallet_id, order_id, type, amount, description) VALUES (?, ?, 'debit', ?, 'Order payment')";
    $trans_stmt = $conn->prepare($trans_sql);
    $trans_stmt->bind_param("iid", $wallet['wallet_id'], $order_id, $amount);
    $trans_stmt->execute();
    
    $conn->commit();
    
    echo json_encode([
        "status" => "success",
        "message" => "Payment successful",
        "new_balance" => $new_balance
    ]);
    
} catch (Exception $e) {
    $conn->rollback();
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}

$conn->close();
?>