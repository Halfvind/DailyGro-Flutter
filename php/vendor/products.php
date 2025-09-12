<?php
require_once '../config.php';
header('Content-Type: application/json');

$vendor_id = $_GET['vendor_id'] ?? null;

if (!$vendor_id) {
    echo json_encode(['status' => 'error', 'message' => 'Vendor ID required']);
    exit;
}

try {
    $stmt = $pdo->prepare("SELECT p.*, c.name as category_name 
                          FROM products p 
                          JOIN categories c ON p.category_id = c.category_id 
                          WHERE p.vendor_id = ? 
                          ORDER BY p.created_at DESC");
    $stmt->execute([$vendor_id]);
    $products = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Calculate discount percentage
    foreach ($products as &$product) {
        if ($product['original_price'] > $product['price']) {
            $product['discount_percentage'] = round((($product['original_price'] - $product['price']) / $product['original_price']) * 100);
        } else {
            $product['discount_percentage'] = 0;
        }
    }
    
    echo json_encode([
        'status' => 'success',
        'products' => $products,
        'count' => count($products)
    ]);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
}
?>