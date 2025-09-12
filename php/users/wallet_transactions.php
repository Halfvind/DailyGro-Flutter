<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
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

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    getWalletTransactions();
} else {
    echo json_encode(["status" => "error", "message" => "Method not allowed"]);
}

function getWalletTransactions() {
    global $conn;

    if (!isset($_GET['wallet_id'])) {
        echo json_encode(["status" => "error", "message" => "Wallet ID is required"]);
        exit;
    }

    $walletId = intval($_GET['wallet_id']);

    $sql = "SELECT * FROM wallet_transactions WHERE wallet_id = ? ORDER BY created_at DESC";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $walletId);
    $stmt->execute();
    $result = $stmt->get_result();

    $transactions = [];
    while ($row = $result->fetch_assoc()) {
        $transactions[] = $row;
    }

    echo json_encode([
        "status" => "success",
        "message" => "Wallet transactions retrieved successfully",
        "transactions" => $transactions
    ]);

    $stmt->close();
}

$conn->close();
?>

