<?php
require_once '../config.php';
header('Content-Type: application/json');

$vendor_id = $_GET['vendor_id'] ?? null;
$type = $_GET['type'] ?? 'all';

if (!$vendor_id) {
    echo json_encode(['status' => 'error', 'message' => 'Vendor ID required']);
    exit;
}

try {
    // Build query based on type
    $whereClause = "WHERE p.vendor_id = ?";
    $params = [$vendor_id];
    
    switch ($type) {
        case 'low':
            $whereClause .= " AND p.stock_quantity > 0 AND p.stock_quantity <= 10";
            break;
        case 'out_of_stock':
            $whereClause .= " AND p.stock_quantity = 0";
            break;
        case 'all':
        default:
            // No additional filter
            break;
    }
    
    // Get products
    $stmt = $pdo->prepare("SELECT p.*, c.name as category_name 
                          FROM products p 
                          JOIN categories c ON p.category_id = c.category_id 
                          $whereClause
                          ORDER BY p.stock_quantity ASC, p.name ASC");
    $stmt->execute($params);
    $products = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Get summary counts
    $stmt = $pdo->prepare("SELECT 
                          COUNT(*) as total_products,
                          SUM(CASE WHEN stock_quantity > 0 AND stock_quantity <= 10 THEN 1 ELSE 0 END) as low_stock_count,
                          SUM(CASE WHEN stock_quantity = 0 THEN 1 ELSE 0 END) as out_of_stock_count
                          FROM products WHERE vendor_id = ?");
    $stmt->execute([$vendor_id]);
    $summary = $stmt->fetch(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'status' => 'success',
        'message' => 'Stock data retrieved successfully',
        'products' => $products,
        'summary' => $summary,
        'filter_type' => $type
    ]);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
}
?>