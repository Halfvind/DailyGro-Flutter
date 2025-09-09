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

try {
    $sql = "SELECT 
                c.*, 
                COUNT(p.product_id) as product_count
            FROM categories c 
            LEFT JOIN products p ON c.category_id = p.category_id AND p.status = 'active'
            WHERE c.status = 'active' 
            GROUP BY c.category_id
            ORDER BY c.sort_order, c.name";
    
    $result = $conn->query($sql);
    $categories = [];
    
    while ($row = $result->fetch_assoc()) {
        $categories[] = [
            'category_id' => $row['category_id'],
            'name' => $row['name'],
            'image' => $row['image'],
            'icon' => $row['icon'],
            'color' => $row['color'],
            'product_count' => (int)$row['product_count'],
            'status' => $row['status'],
            'sort_order' => $row['sort_order']
        ];
    }
    
    echo json_encode([
        "status" => "success",
        "message" => "Categories retrieved successfully",
        "categories" => $categories
    ]);
    
} catch(Exception $e) {
    echo json_encode(['status' => 'error', 'message' => 'Failed to get categories: ' . $e->getMessage()]);
}

$conn->close();
?>