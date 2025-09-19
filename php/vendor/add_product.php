<?php
require_once '../config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'error', 'message' => 'Method not allowed']);
    exit;
}

// Get fields from $_POST
$vendor_id      = $_POST['vendor_id'] ?? null;
$category_id    = $_POST['category_id'] ?? null;
$name           = $_POST['name'] ?? null;
$description    = $_POST['description'] ?? null;
$price          = $_POST['price'] ?? null;
$original_price = $_POST['original_price'] ?? null;
$stock_quantity = $_POST['stock_quantity'] ?? 0;
$unit          = $_POST['unit'] ?? 'piece';
$weight        = $_POST['weight'] ?? null;
$is_featured    = $_POST['is_featured'] ?? 0;
$is_recommended = $_POST['is_recommended'] ?? 0;

// Validate required fields
if (!$vendor_id || !$category_id || !$name || !$price) {
    echo json_encode(['status' => 'error', 'message' => 'Required fields missing']);
    exit;
}

// Handle image upload (optional)
$image = null;
if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
    $uploadDir = '../uploads/';
    $fileName = time() . '_' . basename($_FILES['image']['name']);
    $uploadPath = $uploadDir . $fileName;

    if (move_uploaded_file($_FILES['image']['tmp_name'], $uploadPath)) {
        $image = $fileName;
    }
}

try {
    $stmt = $pdo->prepare("INSERT INTO products (vendor_id, category_id, name, description, price, original_price, stock_quantity, unit, weight, image, is_featured, is_recommended) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

    $stmt->execute([$vendor_id, $category_id, $name, $description, $price, $original_price, $stock_quantity, $unit, $weight, $image, $is_featured, $is_recommended]);

    echo json_encode([
        'status' => 'success',
        'message' => 'Product added successfully',
        'product_id' => $pdo->lastInsertId()
    ]);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
