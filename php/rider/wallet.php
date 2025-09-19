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

$rider_id = intval($_GET['rider_id'] ?? $_POST['rider_id'] ?? 0);
$type = $_GET['type'] ?? $_POST['type'] ?? 'balance';

if (empty($rider_id)) {
    echo json_encode(["status" => "error", "message" => "Rider ID is required"]);
    exit;
}

switch ($type) {
    case 'balance':
        getWalletBalance($conn, $rider_id);
        break;
    case 'transactions':
        getWalletTransactions($conn, $rider_id);
        break;
    case 'withdraw':
        processWithdrawal($conn, $rider_id);
        break;
    default:
        getWalletBalance($conn, $rider_id);
}

function getWalletBalance($conn, $rider_id) {
    // Get or create wallet
    $wallet_sql = "SELECT wallet_id, balance FROM rider_wallets WHERE rider_id = ?";
    $stmt = $conn->prepare($wallet_sql);
    $stmt->bind_param("i", $rider_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        // Create wallet if doesn't exist
        $create_sql = "INSERT INTO rider_wallets (rider_id, balance, created_at) VALUES (?, 0.00, NOW())";
        $stmt = $conn->prepare($create_sql);
        $stmt->bind_param("i", $rider_id);
        $stmt->execute();
        
        $wallet_id = $conn->insert_id;
        $balance = "0.00";
    } else {
        $wallet = $result->fetch_assoc();
        $wallet_id = $wallet['wallet_id'];
        $balance = $wallet['balance'];
    }

    echo json_encode([
        "status" => "success",
        "wallet" => [
            "wallet_id" => $wallet_id,
            "rider_id" => $rider_id,
            "balance" => number_format($balance, 2),
            "created_at" => date('Y-m-d H:i:s'),
            "updated_at" => date('Y-m-d H:i:s')
        ]
    ]);
}

function getWalletTransactions($conn, $rider_id) {
    $wallet_id = $_GET['wallet_id'] ?? 0;
    
    if (empty($wallet_id)) {
        // Get wallet_id first
        $wallet_sql = "SELECT wallet_id FROM rider_wallets WHERE rider_id = ?";
        $stmt = $conn->prepare($wallet_sql);
        $stmt->bind_param("i", $rider_id);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows === 0) {
            echo json_encode(["status" => "error", "message" => "Wallet not found"]);
            return;
        }
        
        $wallet = $result->fetch_assoc();
        $wallet_id = $wallet['wallet_id'];
    }

    $sql = "SELECT 
        rwt.transaction_id,
        rwt.wallet_id,
        rwt.order_id,
        rwt.type,
        rwt.amount,
        rwt.description,
        rwt.reference_id,
        rwt.status,
        rwt.created_at,
        o.order_number
    FROM rider_wallet_transactions rwt
    LEFT JOIN orders o ON rwt.order_id = o.order_id
    WHERE rwt.wallet_id = ?
    ORDER BY rwt.created_at DESC
    LIMIT 50";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $wallet_id);
    $stmt->execute();
    $result = $stmt->get_result();

    $transactions = [];
    while ($row = $result->fetch_assoc()) {
        $transactions[] = $row;
    }

    echo json_encode([
        "status" => "success",
        "transactions" => $transactions
    ]);
}

function processWithdrawal($conn, $rider_id) {
    $input = json_decode(file_get_contents('php://input'), true);
    $amount = floatval($input['amount'] ?? 0);
    $bank_account = $input['bank_account'] ?? '';
    $upi_id = $input['upi_id'] ?? '';

    if ($amount <= 0) {
        echo json_encode(["status" => "error", "message" => "Invalid withdrawal amount"]);
        return;
    }

    if (empty($bank_account) && empty($upi_id)) {
        echo json_encode(["status" => "error", "message" => "Bank account or UPI ID is required"]);
        return;
    }

    // Check wallet balance
    $wallet_sql = "SELECT wallet_id, balance FROM rider_wallets WHERE rider_id = ?";
    $stmt = $conn->prepare($wallet_sql);
    $stmt->bind_param("i", $rider_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        echo json_encode(["status" => "error", "message" => "Wallet not found"]);
        return;
    }

    $wallet = $result->fetch_assoc();
    $wallet_id = $wallet['wallet_id'];
    $current_balance = $wallet['balance'];

    if ($current_balance < $amount) {
        echo json_encode(["status" => "error", "message" => "Insufficient balance"]);
        return;
    }

    // Start transaction
    $conn->begin_transaction();

    try {
        // Deduct from wallet
        $update_sql = "UPDATE rider_wallets SET balance = balance - ? WHERE wallet_id = ?";
        $stmt = $conn->prepare($update_sql);
        $stmt->bind_param("di", $amount, $wallet_id);
        $stmt->execute();

        // Create withdrawal transaction
        $reference_id = 'WD' . time() . $rider_id;
        $payment_method = !empty($upi_id) ? 'UPI' : 'Bank Transfer';
        $payment_details = !empty($upi_id) ? $upi_id : $bank_account;

        $trans_sql = "INSERT INTO rider_wallet_transactions 
            (wallet_id, rider_id, type, amount, description, reference_id, status, created_at) 
            VALUES (?, ?, 'debit', ?, ?, ?, 'pending', NOW())";
        
        $description = "Withdrawal to $payment_method: $payment_details";
        $stmt = $conn->prepare($trans_sql);
        $stmt->bind_param("iidss", $wallet_id, $rider_id, $amount, $description, $reference_id);
        $stmt->execute();

        // Create withdrawal request
        $withdrawal_sql = "INSERT INTO rider_withdrawals 
            (rider_id, amount, payment_method, payment_details, reference_id, status, created_at) 
            VALUES (?, ?, ?, ?, ?, 'pending', NOW())";
        
        $stmt = $conn->prepare($withdrawal_sql);
        $stmt->bind_param("idsss", $rider_id, $amount, $payment_method, $payment_details, $reference_id);
        $stmt->execute();

        $conn->commit();

        echo json_encode([
            "status" => "success", 
            "message" => "Withdrawal request submitted successfully",
            "reference_id" => $reference_id,
            "amount" => $amount
        ]);

    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(["status" => "error", "message" => "Withdrawal failed: " . $e->getMessage()]);
    }
}

$conn->close();
?>