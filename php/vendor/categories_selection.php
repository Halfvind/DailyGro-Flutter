<?php
require_once '../config.php';
header('Content-Type: application/json');

try {
    $stmt = $pdo->prepare("SELECT category_id, name FROM categories WHERE status = 'active' ORDER BY name ASC");
    $stmt->execute();
    $categories = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'status' => 'success',
        'message' => 'Categories retrieved successfully',
        'categories' => $categories
    ]);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
}
?>