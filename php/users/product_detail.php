<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "DailyGro";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Database connection failed"]);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    getProductDetail();
} else {
    echo json_encode(["status" => "error", "message" => "Method not allowed"]);
}

function getProductDetail() {
    global $conn;

    if (!isset($_GET['product_id'])) {
        echo json_encode(["status" => "error", "message" => "Product ID is required"]);
        exit;
    }

    $productId = intval($_GET['product_id']);

    // Get product detail
    $sql = "SELECT product_id, name, price, unit, image, description, category_id 
            FROM products 
            WHERE product_id = ? AND status = 'active'";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $productId);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        echo json_encode(["status" => "error", "message" => "Product not found"]);
        exit;
    }

    $product = $result->fetch_assoc();
    $categoryId = $product['category_id'];

    // Get similar products (same category, exclude current product)
    $similarSql = "SELECT product_id, name, price, unit, image 
                   FROM products 
                   WHERE category_id = ? AND status = 'active' AND product_id != ? 
                   LIMIT 5";
    $similarStmt = $conn->prepare($similarSql);
    $similarStmt->bind_param("ii", $categoryId, $productId);
    $similarStmt->execute();
    $similarResult = $similarStmt->get_result();

    $similarProducts = [];
    while ($row = $similarResult->fetch_assoc()) {
        $similarProducts[] = [
            "product_id" => (int)$row['product_id'],
            "name" => $row['name'],
            "price" => (float)$row['price'],
            "unit" => $row['unit'],
            "image" => $row['image']
        ];
    }

    echo json_encode([
        "status" => "success",
        "message" => "Product details retrieved successfully",
        "product" => $product,
        "similar_products" => $similarProducts
    ]);

    $stmt->close();
    $similarStmt->close();
}

$conn->close();
?>

