<?php
require_once '../config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'error', 'message' => 'Method not allowed']);
    exit;
}

$product_id = $_POST['product_id'] ?? null;
$vendor_id = $_POST['vendor_id'] ?? null;
$stock_quantity = $_POST['stock_quantity'] ?? null;

if (!$product_id || !$vendor_id || $stock_quantity === null) {
    echo json_encode(['status' => 'error', 'message' => 'Required fields missing']);
    exit;
}

try {
    // Verify product belongs to vendor
    $stmt = $pdo->prepare("SELECT product_id FROM products WHERE product_id = ? AND vendor_id = ?");
    $stmt->execute([$product_id, $vendor_id]);
    
    if (!$stmt->fetch()) {
        echo json_encode(['status' => 'error', 'message' => 'Product not found']);
        exit;
    }
    
    // Update stock
    $status = $stock_quantity > 0 ? 'active' : 'out_of_stock';
    $stmt = $pdo->prepare("UPDATE products SET stock_quantity = ?, status = ? WHERE product_id = ?");
    $stmt->execute([$stock_quantity, $status, $product_id]);
    
    echo json_encode([
        'status' => 'success',
        'message' => 'Stock updated successfully',
        'new_stock' => $stock_quantity,
        'product_status' => $status
    ]);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
}
?>