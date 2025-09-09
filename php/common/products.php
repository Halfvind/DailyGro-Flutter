<?php
require_once '../config.php';

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
        addProduct();
        break;
    case 'PUT':
        updateProduct();
        break;
    case 'DELETE':
        deleteProduct();
        break;
    default:
        sendResponse('error', 'Method not allowed');
}

function getProducts() {
    global $pdo;
    
    $categoryId = $_GET['category_id'] ?? '';
    $vendorId = $_GET['vendor_id'] ?? '';
    $search = $_GET['search'] ?? '';
    $featured = $_GET['featured'] ?? '';
    $recommended = $_GET['recommended'] ?? '';
    $limit = (int)($_GET['limit'] ?? 20);
    $offset = (int)($_GET['offset'] ?? 0);
    
    try {
        $sql = "SELECT p.*, c.name as category_name, v.business_name as vendor_name, 
                       (SELECT AVG(rating) FROM product_reviews WHERE product_id = p.product_id) as avg_rating,
                       (SELECT COUNT(*) FROM product_reviews WHERE product_id = p.product_id) as review_count
                FROM products p 
                JOIN categories c ON p.category_id = c.category_id 
                JOIN vendors v ON p.vendor_id = v.vendor_id 
                WHERE p.status = 'active'";
        
        $params = [];
        
        if (!empty($categoryId)) {
            $sql .= " AND p.category_id = ?";
            $params[] = $categoryId;
        }
        
        if (!empty($vendorId)) {
            $sql .= " AND p.vendor_id = ?";
            $params[] = $vendorId;
        }
        
        if (!empty($search)) {
            $sql .= " AND (p.name LIKE ? OR p.description LIKE ?)";
            $params[] = "%$search%";
            $params[] = "%$search%";
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
        
        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);
        $products = $stmt->fetchAll();
        
        // Format products
        foreach ($products as &$product) {
            $product['images'] = $product['images'] ? json_decode($product['images'], true) : [];
            $product['avg_rating'] = round($product['avg_rating'] ?? 0, 1);
            $product['review_count'] = (int)($product['review_count'] ?? 0);
            $product['discount_percentage'] = $product['original_price'] > 0 ? 
                round((($product['original_price'] - $product['price']) / $product['original_price']) * 100) : 0;
        }
        
        sendResponse('success', 'Products retrieved successfully', ['products' => $products]);
        
    } catch(PDOException $e) {
        sendResponse('error', 'Failed to get products: ' . $e->getMessage());
    }
}

function getProductDetail() {
    global $pdo;
    
    $productId = $_GET['product_id'];
    
    try {
        $stmt = $pdo->prepare("
            SELECT p.*, c.name as category_name, v.business_name as vendor_name, v.rating as vendor_rating,
                   (SELECT AVG(rating) FROM product_reviews WHERE product_id = p.product_id) as avg_rating,
                   (SELECT COUNT(*) FROM product_reviews WHERE product_id = p.product_id) as review_count
            FROM products p 
            JOIN categories c ON p.category_id = c.category_id 
            JOIN vendors v ON p.vendor_id = v.vendor_id 
            WHERE p.product_id = ? AND p.status = 'active'
        ");
        $stmt->execute([$productId]);
        $product = $stmt->fetch();
        
        if (!$product) {
            sendResponse('error', 'Product not found');
        }
        
        // Get reviews
        $stmt = $pdo->prepare("
            SELECT pr.*, u.name as user_name 
            FROM product_reviews pr 
            JOIN users u ON pr.user_id = u.user_id 
            WHERE pr.product_id = ? 
            ORDER BY pr.created_at DESC 
            LIMIT 10
        ");
        $stmt->execute([$productId]);
        $reviews = $stmt->fetchAll();
        
        // Get related products
        $stmt = $pdo->prepare("
            SELECT * FROM products 
            WHERE category_id = ? AND product_id != ? AND status = 'active' 
            LIMIT 6
        ");
        $stmt->execute([$product['category_id'], $productId]);
        $relatedProducts = $stmt->fetchAll();
        
        $product['images'] = $product['images'] ? json_decode($product['images'], true) : [];
        $product['avg_rating'] = round($product['avg_rating'] ?? 0, 1);
        $product['review_count'] = (int)($product['review_count'] ?? 0);
        $product['discount_percentage'] = $product['original_price'] > 0 ? 
            round((($product['original_price'] - $product['price']) / $product['original_price']) * 100) : 0;
        
        sendResponse('success', 'Product detail retrieved successfully', [
            'product' => $product,
            'reviews' => $reviews,
            'related_products' => $relatedProducts
        ]);
        
    } catch(PDOException $e) {
        sendResponse('error', 'Failed to get product detail: ' . $e->getMessage());
    }
}

function addProduct() {
    global $pdo;
    
    $input = json_decode(file_get_contents('php://input'), true);
    validateRequired(['vendor_id', 'category_id', 'name', 'price'], $input);
    
    try {
        $stmt = $pdo->prepare("
            INSERT INTO products (vendor_id, category_id, name, description, price, original_price, stock_quantity, unit, weight, image, images, is_featured, is_recommended) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ");
        $stmt->execute([
            $input['vendor_id'],
            $input['category_id'],
            $input['name'],
            $input['description'] ?? '',
            $input['price'],
            $input['original_price'] ?? $input['price'],
            $input['stock_quantity'] ?? 0,
            $input['unit'] ?? 'piece',
            $input['weight'] ?? '',
            $input['image'] ?? '',
            json_encode($input['images'] ?? []),
            $input['is_featured'] ?? false,
            $input['is_recommended'] ?? false
        ]);
        
        sendResponse('success', 'Product added successfully', ['product_id' => $pdo->lastInsertId()]);
        
    } catch(PDOException $e) {
        sendResponse('error', 'Failed to add product: ' . $e->getMessage());
    }
}

function updateProduct() {
    global $pdo;
    
    $input = json_decode(file_get_contents('php://input'), true);
    validateRequired(['product_id'], $input);
    
    try {
        $stmt = $pdo->prepare("
            UPDATE products SET 
            name = ?, description = ?, price = ?, original_price = ?, stock_quantity = ?, 
            unit = ?, weight = ?, image = ?, images = ?, is_featured = ?, is_recommended = ?
            WHERE product_id = ?
        ");
        $stmt->execute([
            $input['name'] ?? '',
            $input['description'] ?? '',
            $input['price'] ?? 0,
            $input['original_price'] ?? 0,
            $input['stock_quantity'] ?? 0,
            $input['unit'] ?? 'piece',
            $input['weight'] ?? '',
            $input['image'] ?? '',
            json_encode($input['images'] ?? []),
            $input['is_featured'] ?? false,
            $input['is_recommended'] ?? false,
            $input['product_id']
        ]);
        
        sendResponse('success', 'Product updated successfully');
        
    } catch(PDOException $e) {
        sendResponse('error', 'Failed to update product: ' . $e->getMessage());
    }
}

function deleteProduct() {
    global $pdo;
    
    $productId = $_GET['product_id'] ?? '';
    if (empty($productId)) {
        sendResponse('error', 'Product ID required');
    }
    
    try {
        $stmt = $pdo->prepare("UPDATE products SET status = 'inactive' WHERE product_id = ?");
        $stmt->execute([$productId]);
        
        sendResponse('success', 'Product deleted successfully');
        
    } catch(PDOException $e) {
        sendResponse('error', 'Failed to delete product: ' . $e->getMessage());
    }
}
?>