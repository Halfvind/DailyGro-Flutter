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

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    echo json_encode(["status" => "error", "message" => "Method not allowed"]);
    exit;
}

if (!isset($_GET['id']) || empty($_GET['id'])) {
    echo json_encode(["status" => "error", "message" => "User ID is required"]);
    exit;
}

$id = intval($_GET['id']);

$sql = "SELECT 
            u.user_id,
            u.name,
            u.email,
            u.phone,
            r.role_name,
            u.created_at,
            v.business_name,
            v.business_address,
            v.business_type,
            v.verification_status,
            v.rating
        FROM users u
        JOIN roles r ON u.role_id = r.role_id
        JOIN vendors v ON u.user_id = v.user_id
        WHERE u.user_id = ? AND u.status = 'active'";

$stmt = $conn->prepare($sql);
if (!$stmt) {
    echo json_encode(["status" => "error", "message" => "Prepare failed: " . $conn->error]);
    exit;
}

$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(["status" => "error", "message" => "Vendor not found"]);
    exit;
}

$vendor = $result->fetch_assoc();

echo json_encode([
    "status" => "success",
    "user_profile" => [
        "id" => $vendor['user_id'],
        "name" => $vendor['business_name'],
        "email" => $vendor['email'],
        "phone" => $vendor['phone'],
        "role" => $vendor['role_name'],
        "created_at" => $vendor['created_at'],
        "user_id" => $vendor['user_id'],
        "address" => $vendor['business_address'],
        "business_type" => $vendor['business_type'],
        "verification_status" => $vendor['verification_status'],
        "rating" => $vendor['rating']
    ]
]);

$stmt->close();
$conn->close();
?>