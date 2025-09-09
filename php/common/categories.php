<?php
require_once '../config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    sendResponse('error', 'Method not allowed');
}

try {
    $stmt = $pdo->prepare("
        SELECT c.*, 
               (SELECT COUNT(*) FROM products p WHERE p.category_id = c.category_id AND p.status = 'active') as product_count
        FROM categories c 
        WHERE c.status = 'active' 
        ORDER BY c.sort_order, c.name
    ");
    $stmt->execute();
    $categories = $stmt->fetchAll();
    
    sendResponse('success', 'Categories retrieved successfully', ['categories' => $categories]);
    
} catch(PDOException $e) {
    sendResponse('error', 'Failed to get categories: ' . $e->getMessage());
}
?>