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
            p.address,
            rd.vehicle_type,
            rd.license_number,
            rd.vehicle_number,
            rd.availability_status,
            rd.verification_status,
            rd.rating
        FROM users u
        JOIN roles r ON u.role_id = r.role_id
        JOIN riders rd ON u.user_id = rd.user_id
        LEFT JOIN user_profiles p ON u.user_id = p.user_id
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
    echo json_encode(["status" => "error", "message" => "Rider not found"]);
    exit;
}

$rider = $result->fetch_assoc();

echo json_encode([
    "status" => "success",
    "user_profile" => [
        "id" => $rider['user_id'],
        "name" => $rider['name'],
        "email" => $rider['email'],
        "phone" => $rider['phone'],
        "role" => $rider['role_name'],
        "created_at" => $rider['created_at'],
        "user_id" => $rider['user_id'],
        "address" => $rider['address'] ?? '',
        "vehicle_type" => $rider['vehicle_type'],
        "license_number" => $rider['license_number'],
        "vehicle_number" => $rider['vehicle_number'],
        "availability_status" => $rider['availability_status'],
        "verification_status" => $rider['verification_status'],
        "rating" => $rider['rating']
    ]
]);

$stmt->close();
$conn->close();
?>