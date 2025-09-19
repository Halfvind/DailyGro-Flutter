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
    echo json_encode(["status" => "error", "message" => "Only POST method allowed"]);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true);

$product_id = intval($input['product_id'] ?? 0);
$vendor_id = intval($input['vendor_id'] ?? 0);
$stock_quantity = intval($input['stock_quantity'] ?? 0);

if (empty($product_id) || empty($vendor_id)) {
    echo json_encode(["status" => "error", "message" => "Product ID and Vendor ID are required"]);
    exit;
}

// Verify product belongs to vendor
$verify_sql = "SELECT product_id FROM products WHERE product_id = ? AND vendor_id = ?";
$stmt = $conn->prepare($verify_sql);
$stmt->bind_param("ii", $product_id, $vendor_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(["status" => "error", "message" => "Product not found or doesn't belong to this vendor"]);
    exit;
}

// Update stock
$update_sql = "UPDATE products SET 
    stock_quantity = ?,
    updated_at = NOW()
WHERE product_id = ? AND vendor_id = ?";

$stmt = $conn->prepare($update_sql);
$stmt->bind_param("iii", $stock_quantity, $product_id, $vendor_id);

if ($stmt->execute()) {
    echo json_encode([
        "status" => "success", 
        "message" => "Stock updated successfully",
        "product_id" => $product_id,
        "new_stock" => $stock_quantity
    ]);
} else {
    echo json_encode(["status" => "error", "message" => "Failed to update stock"]);
}

$conn->close();
?>