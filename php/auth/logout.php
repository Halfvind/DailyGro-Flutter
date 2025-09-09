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

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["status" => "error", "message" => "Method not allowed"]);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true);
$userId = $input['user_id'] ?? '';

try {
    if (!empty($userId)) {
        // Update rider availability if rider
        $stmt = $conn->prepare("SELECT role_id FROM users WHERE user_id = ?");
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $result = $stmt->get_result();
        $user = $result->fetch_assoc();
        $stmt->close();

        if ($user && $user['role_id'] == 3) {
            $stmt = $conn->prepare("UPDATE riders SET availability_status = 'offline' WHERE user_id = ?");
            $stmt->bind_param("i", $userId);
            $stmt->execute();
            $stmt->close();
        }
    }

    echo json_encode([
        'status' => 'success',
        'message' => 'Logout successful'
    ]);

} catch(Exception $e) {
    echo json_encode(['status' => 'error', 'message' => 'Logout failed: ' . $e->getMessage()]);
}

$conn->close();
?>