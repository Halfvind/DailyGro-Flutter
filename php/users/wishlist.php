<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, DELETE");
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

switch ($method) {
    case 'GET':
        getWishlistItems();
        break;
    case 'POST':
        addToWishlist();
        break;
    case 'DELETE':
        removeFromWishlist();
        break;
    default:
        echo json_encode(["status" => "error", "message" => "Method not allowed"]);
}

function getWishlistItems() {
    global $conn;
    
    if (!isset($_GET['user_id'])) {
        echo json_encode(["status" => "error", "message" => "User ID is required"]);
        exit;
    }

    $userId = intval($_GET['user_id']);

    $sql = "SELECT w.*, p.name, p.price, p.original_price, p.image, p.unit, p.weight, p.rating, p.is_featured, p.is_recommended,
                   c.name as category_name, v.business_name as vendor_name
            FROM wishlist w 
            JOIN products p ON w.product_id = p.product_id 
            JOIN categories c ON p.category_id = c.category_id
            JOIN vendors v ON p.vendor_id = v.vendor_id
            WHERE w.user_id = ? 
            ORDER BY w.created_at DESC";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $result = $stmt->get_result();

    $wishlistItems = [];
    
    while ($row = $result->fetch_assoc()) {
        $wishlistItems[] = [
            'wishlist_id' => $row['wishlist_id'],
            'product_id' => $row['product_id'],
            'name' => $row['name'],
            'price' => (float)$row['price'],
            'original_price' => (float)$row['original_price'],
            'image' => $row['image'],
            'unit' => $row['unit'],
            'weight' => $row['weight'],
            'rating' => (float)$row['rating'],
            'is_featured' => (bool)$row['is_featured'],
            'is_recommended' => (bool)$row['is_recommended'],
            'category_name' => $row['category_name'],
            'vendor_name' => $row['vendor_name'],
            'discount_percentage' => $row['original_price'] > 0 ?
                round((($row['original_price'] - $row['price']) / $row['original_price']) * 100) : 0,
            'added_at' => $row['created_at']
        ];
    }

    echo json_encode([
        "status" => "success",
        "message" => "Wishlist items retrieved successfully",
        "wishlist_items" => $wishlistItems,
        "item_count" => count($wishlistItems)
    ]);

    $stmt->close();
}

function addToWishlist() {
    global $conn;

    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['user_id']) || !isset($data['product_id'])) {
        echo json_encode(["status" => "error", "message" => "User ID and Product ID are required"]);
        exit;
    }

    $userId = intval($data['user_id']);
    $productId = intval($data['product_id']);

    // Check if item already exists in wishlist
    $checkSql = "SELECT wishlist_id FROM wishlist WHERE user_id = ? AND product_id = ?";
    $checkStmt = $conn->prepare($checkSql);
    $checkStmt->bind_param("ii", $userId, $productId);
    $checkStmt->execute();
    $result = $checkStmt->get_result();

    if ($result->num_rows > 0) {
        echo json_encode(["status" => "error", "message" => "Item already exists in wishlist"]);
        $checkStmt->close();
        return;
    }

    // Add to wishlist
    $insertSql = "INSERT INTO wishlist (user_id, product_id) VALUES (?, ?)";
    $insertStmt = $conn->prepare($insertSql);
    $insertStmt->bind_param("ii", $userId, $productId);

    if ($insertStmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Item added to wishlist successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to add item to wishlist"]);
    }

    $checkStmt->close();
    $insertStmt->close();
}

function removeFromWishlist() {
    global $conn;

    if (!isset($_GET['wishlist_id']) && !isset($_GET['user_id']) && !isset($_GET['product_id'])) {
        echo json_encode(["status" => "error", "message" => "Wishlist ID or (User ID and Product ID) are required"]);
        exit;
    }

    if (isset($_GET['wishlist_id'])) {
        // Remove by wishlist ID
        $wishlistId = intval($_GET['wishlist_id']);
        $sql = "DELETE FROM wishlist WHERE wishlist_id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $wishlistId);
    } else {
        // Remove by user ID and product ID
        $userId = intval($_GET['user_id']);
        $productId = intval($_GET['product_id']);
        $sql = "DELETE FROM wishlist WHERE user_id = ? AND product_id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ii", $userId, $productId);
    }

    if ($stmt->execute()) {
        if ($stmt->affected_rows > 0) {
            echo json_encode(["status" => "success", "message" => "Item removed from wishlist successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Item not found in wishlist"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to remove item from wishlist"]);
    }

    $stmt->close();
}

$conn->close();
?>
