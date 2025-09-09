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

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        if (isset($_GET['product_id'])) {
            getProductDetail();
        } else {
            getProducts();
        }
        break;
    case 'POST':
        addProduct(); // Vendor only
        break;
    case 'PUT':
        updateProduct(); // Vendor only
        break;
    case 'DELETE':
        deleteProduct(); // Vendor only
        break;
    default:
        echo json_encode(["status" => "error", "message" => "Method not allowed"]);
}

// Get products (Users browse, Vendors manage their own)
function getProducts() {
    global $conn;
    
    $categoryId = $_GET['category_id'] ?? '';
    $vendorId = $_GET['vendor_id'] ?? '';
    $search = $_GET['search'] ?? '';
    $featured = $_GET['featured'] ?? '';
    $recommended = $_GET['recommended'] ?? '';
    $limit = (int)($_GET['limit'] ?? 20);
    $offset = (int)($_GET['offset'] ?? 0);
    
    try {
        $sql = "SELECT 
                    p.*, 
                    c.name as category_name, 
                    v.business_name as vendor_name,
                    u.name as vendor_owner_name,
                    v.rating as vendor_rating,
                    (SELECT AVG(rating) FROM product_reviews WHERE product_id = p.product_id) as avg_rating,
                    (SELECT COUNT(*) FROM product_reviews WHERE product_id = p.product_id) as review_count
                FROM products p 
                JOIN categories c ON p.category_id = c.category_id 
                JOIN vendors v ON p.vendor_id = v.vendor_id 
                JOIN users u ON v.user_id = u.user_id
                WHERE p.status = 'active' AND c.status = 'active'";
        
        $params = [];
        $types = '';
        
        if (!empty($categoryId)) {
            $sql .= " AND p.category_id = ?";
            $params[] = $categoryId;
            $types .= 'i';
        }
        
        if (!empty($vendorId)) {
            $sql .= " AND p.vendor_id = ?";
            $params[] = $vendorId;
            $types .= 'i';
        }
        
        if (!empty($search)) {
            $sql .= " AND (p.name LIKE ? OR p.description LIKE ?)";
            $params[] = "%$search%";
            $params[] = "%$search%";
            $types .= 'ss';
        }
        
        if ($featured === '1') {
            $sql .= " AND p.is_featured = 1";
        }
        
        if ($recommended === '1') {
            $sql .= " AND p.is_recommended = 1";
        }
        
        $sql .= " ORDER BY p.created_at DESC LIMIT ? OFFSET ?";
        $params[] = $limit;
        $params[] = $offset;
        $types .= 'ii';
        
        $stmt = $conn->prepare($sql);
        if (!empty($params)) {
            $stmt->bind_param($types, ...$params);
        }
        $stmt->execute();
        $result = $stmt->get_result();
        
        $products = [];
        while ($row = $result->fetch_assoc()) {
            $products[] = [
                'product_id' => $row['product_id'],
                'vendor_id' => $row['vendor_id'],
                'category_id' => $row['category_id'],
                'name' => $row['name'],
                'description' => $row['description'],
                'price' => (float)$row['price'],
                'original_price' => (float)($row['original_price'] ?? $row['price']),
                'stock_quantity' => (int)$row['stock_quantity'],
                'unit' => $row['unit'],
                'weight' => $row['weight'],
                'image' => $row['image'],
                'images' => $row['images'] ? json_decode($row['images'], true) : [],
                'is_featured' => (bool)$row['is_featured'],
                'is_recommended' => (bool)$row['is_recommended'],
                'rating' => round($row['rating'] ?? 0, 1),
                'avg_rating' => round($row['avg_rating'] ?? 0, 1),
                'review_count' => (int)($row['review_count'] ?? 0),
                'category_name' => $row['category_name'],
                'vendor_name' => $row['vendor_name'],
                'vendor_owner_name' => $row['vendor_owner_name'],
                'vendor_rating' => round($row['vendor_rating'] ?? 0, 1),
                'discount_percentage' => $row['original_price'] > 0 ? 
                    round((($row['original_price'] - $row['price']) / $row['original_price']) * 100) : 0,
                'created_at' => $row['created_at']
            ];
        }
        
        echo json_encode([
            "status" => "success",
            "message" => "Products retrieved successfully",
            "products" => $products,
            "total_count" => count($products)
        ]);
        
        $stmt->close();
        
    } catch(Exception $e) {
        echo json_encode(['status' => 'error', 'message' => 'Failed to get products: ' . $e->getMessage()]);
    }
}

// Get single product detail (Users)
function getProductDetail() {
    global $conn;
    
    $productId = $_GET['product_id'];
    
    try {
        $sql = "SELECT 
                    p.*, 
                    c.name as category_name, 
                    v.business_name as vendor_name,
                    u.name as vendor_owner_name,
                    u.phone as vendor_phone,
                    v.rating as vendor_rating,
                    (SELECT AVG(rating) FROM product_reviews WHERE product_id = p.product_id) as avg_rating,
                    (SELECT COUNT(*) FROM product_reviews WHERE product_id = p.product_id) as review_count
                FROM products p 
                JOIN categories c ON p.category_id = c.category_id 
                JOIN vendors v ON p.vendor_id = v.vendor_id 
                JOIN users u ON v.user_id = u.user_id
                WHERE p.product_id = ? AND p.status = 'active'";
        
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $productId);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows === 0) {
            echo json_encode(["status" => "error", "message" => "Product not found"]);
            exit;
        }
        
        $product = $result->fetch_assoc();
        
        // Get reviews
        $reviewSql = "SELECT pr.*, u.name as user_name 
                      FROM product_reviews pr 
                      JOIN users u ON pr.user_id = u.user_id 
                      WHERE pr.product_id = ? 
                      ORDER BY pr.created_at DESC 
                      LIMIT 10";
        $reviewStmt = $conn->prepare($reviewSql);
        $reviewStmt->bind_param("i", $productId);
        $reviewStmt->execute();
        $reviewResult = $reviewStmt->get_result();
        
        $reviews = [];
        while ($review = $reviewResult->fetch_assoc()) {
            $reviews[] = $review;
        }
        
        // Get related products
        $relatedSql = "SELECT * FROM products 
                       WHERE category_id = ? AND product_id != ? AND status = 'active' 
                       LIMIT 6";
        $relatedStmt = $conn->prepare($relatedSql);
        $relatedStmt->bind_param("ii", $product['category_id'], $productId);
        $relatedStmt->execute();
        $relatedResult = $relatedStmt->get_result();
        
        $relatedProducts = [];
        while ($related = $relatedResult->fetch_assoc()) {
            $relatedProducts[] = $related;
        }
        
        echo json_encode([
            "status" => "success",
            "message" => "Product detail retrieved successfully",
            "product" => [
                'product_id' => $product['product_id'],
                'vendor_id' => $product['vendor_id'],
                'category_id' => $product['category_id'],
                'name' => $product['name'],
                'description' => $product['description'],
                'price' => (float)$product['price'],
                'original_price' => (float)($product['original_price'] ?? $product['price']),
                'stock_quantity' => (int)$product['stock_quantity'],
                'unit' => $product['unit'],
                'weight' => $product['weight'],
                'image' => $product['image'],
                'images' => $product['images'] ? json_decode($product['images'], true) : [],
                'avg_rating' => round($product['avg_rating'] ?? 0, 1),
                'review_count' => (int)($product['review_count'] ?? 0),
                'category_name' => $product['category_name'],
                'vendor_name' => $product['vendor_name'],
                'vendor_owner_name' => $product['vendor_owner_name'],
                'vendor_phone' => $product['vendor_phone'],
                'vendor_rating' => round($product['vendor_rating'] ?? 0, 1),
                'discount_percentage' => $product['original_price'] > 0 ? 
                    round((($product['original_price'] - $product['price']) / $product['original_price']) * 100) : 0,
            ],
            "reviews" => $reviews,
            "related_products" => $relatedProducts
        ]);
        
        $stmt->close();
        $reviewStmt->close();
        $relatedStmt->close();
        
    } catch(Exception $e) {
        echo json_encode(['status' => 'error', 'message' => 'Failed to get product detail: ' . $e->getMessage()]);
    }
}

// Add product (Vendor only)
function addProduct() {
    global $conn;
    
    $data = json_decode(file_get_contents("php://input"), true);
    
    $required = ['vendor_id', 'category_id', 'name', 'price'];
    foreach ($required as $field) {
        if (!isset($data[$field]) || empty($data[$field])) {
            echo json_encode(["status" => "error", "message" => ucfirst(str_replace('_', ' ', $field)) . " is required"]);
            exit;
        }
    }
    
    try {
        $sql = "INSERT INTO products (vendor_id, category_id, name, description, price, original_price, stock_quantity, unit, weight, image, images, is_featured, is_recommended) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        $stmt = $conn->prepare($sql);
        $stmt->bind_param(
            "iissddsssssii",
            $data['vendor_id'],
            $data['category_id'],
            $data['name'],
            $data['description'] ?? '',
            $data['price'],
            $data['original_price'] ?? $data['price'],
            $data['stock_quantity'] ?? 0,
            $data['unit'] ?? 'piece',
            $data['weight'] ?? '',
            $data['image'] ?? '',
            json_encode($data['images'] ?? []),
            $data['is_featured'] ?? false,
            $data['is_recommended'] ?? false
        );
        
        if ($stmt->execute()) {
            echo json_encode([
                "status" => "success",
                "message" => "Product added successfully",
                "product_id" => $conn->insert_id
            ]);
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to add product"]);
        }
        
        $stmt->close();
        
    } catch(Exception $e) {
        echo json_encode(['status' => 'error', 'message' => 'Failed to add product: ' . $e->getMessage()]);
    }
}

// Update product (Vendor only)
function updateProduct() {
    global $conn;
    
    $data = json_decode(file_get_contents("php://input"), true);
    
    if (!isset($data['product_id']) || empty($data['product_id'])) {
        echo json_encode(["status" => "error", "message" => "Product ID is required"]);
        exit;
    }
    
    try {
        $sql = "UPDATE products SET 
                name = ?, description = ?, price = ?, original_price = ?, 
                stock_quantity = ?, unit = ?, weight = ?, image = ?, 
                images = ?, is_featured = ?, is_recommended = ?
                WHERE product_id = ?";
        
        $stmt = $conn->prepare($sql);
        $stmt->bind_param(
            "ssddssssssii",
            $data['name'] ?? '',
            $data['description'] ?? '',
            $data['price'] ?? 0,
            $data['original_price'] ?? 0,
            $data['stock_quantity'] ?? 0,
            $data['unit'] ?? 'piece',
            $data['weight'] ?? '',
            $data['image'] ?? '',
            json_encode($data['images'] ?? []),
            $data['is_featured'] ?? false,
            $data['is_recommended'] ?? false,
            $data['product_id']
        );
        
        if ($stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Product updated successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to update product"]);
        }
        
        $stmt->close();
        
    } catch(Exception $e) {
        echo json_encode(['status' => 'error', 'message' => 'Failed to update product: ' . $e->getMessage()]);
    }
}

// Delete product (Vendor only)
function deleteProduct() {
    global $conn;
    
    if (!isset($_GET['product_id']) || empty($_GET['product_id'])) {
        echo json_encode(["status" => "error", "message" => "Product ID is required"]);
        exit;
    }
    
    $productId = intval($_GET['product_id']);
    
    try {
        $stmt = $conn->prepare("UPDATE products SET status = 'inactive' WHERE product_id = ?");
        $stmt->bind_param("i", $productId);
        
        if ($stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Product deleted successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to delete product"]);
        }
        
        $stmt->close();
        
    } catch(Exception $e) {
        echo json_encode(['status' => 'error', 'message' => 'Failed to delete product: ' . $e->getMessage()]);
    }
}

$conn->close();
?>