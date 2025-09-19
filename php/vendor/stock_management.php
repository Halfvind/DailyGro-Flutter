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

$vendor_id = intval($_GET['vendor_id'] ?? 0);
$type = $_GET['type'] ?? 'all';

if (empty($vendor_id)) {
    echo json_encode(["status" => "error", "message" => "Vendor ID is required"]);
    exit;
}

// Build query based on type
$sql = "SELECT 
    p.product_id,
    p.product_name as name,
    p.description,
    p.price,
    p.stock_quantity,
    p.status,
    p.image_url as image,
    c.category_name,
    p.created_at
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE p.vendor_id = ?";

switch ($type) {
    case 'low':
        $sql .= " AND p.stock_quantity > 0 AND p.stock_quantity <= 10";
        break;
    case 'out_of_stock':
        $sql .= " AND p.stock_quantity = 0";
        break;
    case 'list_products':
    case 'all':
    default:
        // No additional filter for all products
        break;
}

$sql .= " ORDER BY p.created_at DESC";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $vendor_id);
$stmt->execute();
$result = $stmt->get_result();

$products = [];
$total_products = 0;
$low_stock_count = 0;
$out_of_stock_count = 0;

while ($row = $result->fetch_assoc()) {
    $products[] = $row;
    $total_products++;
    
    if ($row['stock_quantity'] == 0) {
        $out_of_stock_count++;
    } elseif ($row['stock_quantity'] <= 10) {
        $low_stock_count++;
    }
}

echo json_encode([
    "status" => "success",
    "message" => "Products fetched successfully",
    "data" => $products,
    "products" => $products, // For backward compatibility
    "summary" => [
        "total_products" => $total_products,
        "low_stock_count" => $low_stock_count,
        "out_of_stock_count" => $out_of_stock_count
    ]
]);

$conn->close();
?>