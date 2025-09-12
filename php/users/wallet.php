
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
    getWallet();
} else {
    echo json_encode(["status" => "error", "message" => "Method not allowed"]);
}

function getWallet() {
    global $conn;

    if (!isset($_GET['user_id'])) {
        echo json_encode(["status" => "error", "message" => "User ID is required"]);
        exit;
    }

    $userId = intval($_GET['user_id']);

    $sql = "SELECT * FROM wallet WHERE user_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        echo json_encode(["status" => "error", "message" => "Wallet not found"]);
        exit;
    }

    $wallet = $result->fetch_assoc();

    echo json_encode([
        "status" => "success",
        "message" => "Wallet retrieved successfully",
        "wallet" => $wallet
    ]);

    $stmt->close();
}

$conn->close();
?>
