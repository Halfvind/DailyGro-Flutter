
<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
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
        getCartItems();
        break;
    case 'POST':
        addToCart();
        break;
    case 'PUT':
        updateCartItem();
        break;
    case 'DELETE':
        removeFromCart();
        break;
    default:
        echo json_encode(["status" => "error", "message" => "Method not allowed"]);
}

function getCartItems() {
    global $conn;
    
    if (!isset($_GET['user_id'])) {
        echo json_encode(["status" => "error", "message" => "User ID is required"]);
        exit;
    }

    $userId = intval($_GET['user_id']);

    $sql = "SELECT c.*, p.name, p.price, p.image, p.unit, p.weight 
            FROM cart c 
            JOIN products p ON c.product_id = p.product_id 
            WHERE c.user_id = ?";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $result = $stmt->get_result();

    $cartItems = [];
    $totalAmount = 0;
    
    while ($row = $result->fetch_assoc()) {
        $itemTotal = $row['price'] * $row['quantity'];
        $totalAmount += $itemTotal;
        
        $cartItems[] = [
            'cart_id' => $row['cart_id'],
            'product_id' => $row['product_id'],
            'name' => $row['name'],
            'price' => (float)$row['price'],
            'quantity' => (int)$row['quantity'],
            'image' => $row['image'],
            'unit' => $row['unit'],
            'weight' => $row['weight'],
            'item_total' => $itemTotal
        ];
    }

    echo json_encode([
        "status" => "success",
        "message" => "Cart items retrieved successfully",
        "cart_items" => $cartItems,
        "total_amount" => $totalAmount,
        "item_count" => count($cartItems)
    ]);

    $stmt->close();
}

function addToCart() {
    global $conn;
    
    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['user_id']) || !isset($data['product_id']) || !isset($data['quantity'])) {
        echo json_encode(["status" => "error", "message" => "User ID, Product ID, and Quantity are required"]);
        exit;
    }

    $userId = intval($data['user_id']);
    $productId = intval($data['product_id']);
    $quantity = intval($data['quantity']);

    // Check if item already exists in cart
    $checkSql = "SELECT cart_id, quantity FROM cart WHERE user_id = ? AND product_id = ?";
    $checkStmt = $conn->prepare($checkSql);
    $checkStmt->bind_param("ii", $userId, $productId);
    $checkStmt->execute();
    $result = $checkStmt->get_result();

    if ($result->num_rows > 0) {
        // Update existing item
        $row = $result->fetch_assoc();
        $newQuantity = $row['quantity'] + $quantity;
        
        $updateSql = "UPDATE cart SET quantity = ? WHERE cart_id = ?";
        $updateStmt = $conn->prepare($updateSql);
        $updateStmt->bind_param("ii", $newQuantity, $row['cart_id']);
        
        if ($updateStmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Cart updated successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to update cart"]);
        }
        $updateStmt->close();
    } else {
        // Add new item
        $insertSql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
        $insertStmt = $conn->prepare($insertSql);
        $insertStmt->bind_param("iii", $userId, $productId, $quantity);
        
        if ($insertStmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Item added to cart successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to add item to cart"]);
        }
        $insertStmt->close();
    }

    $checkStmt->close();
}

function updateCartItem() {
    global $conn;
    
    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['cart_id']) || !isset($data['quantity'])) {
        echo json_encode(["status" => "error", "message" => "Cart ID and Quantity are required"]);
        exit;
    }

    $cartId = intval($data['cart_id']);
    $quantity = intval($data['quantity']);

    if ($quantity <= 0) {
        echo json_encode(["status" => "error", "message" => "Quantity must be greater than 0"]);
        exit;
    }

    $sql = "UPDATE cart SET quantity = ? WHERE cart_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ii", $quantity, $cartId);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Cart item updated successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to update cart item"]);
    }

    $stmt->close();
}

function removeFromCart() {
    global $conn;
    
    if (!isset($_GET['cart_id'])) {
        echo json_encode(["status" => "error", "message" => "Cart ID is required"]);
        exit;
    }

    $cartId = intval($_GET['cart_id']);

    $sql = "DELETE FROM cart WHERE cart_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $cartId);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Item removed from cart successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to remove item from cart"]);
    }

    $stmt->close();
}

$conn->close();
?>
