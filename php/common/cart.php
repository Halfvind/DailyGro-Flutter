<?php
require_once '../config.php';

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        getCart();
        break;
    case 'POST':
        addToCart();
        break;
    case 'PUT':
        updateCart();
        break;
    case 'DELETE':
        removeFromCart();
        break;
    default:
        sendResponse('error', 'Method not allowed');
}

function getCart() {
    global $pdo;
    
    $userId = $_GET['user_id'] ?? '';
    if (empty($userId)) {
        sendResponse('error', 'User ID required');
    }
    
    try {
        $stmt = $pdo->prepare("
            SELECT c.*, p.name, p.price, p.original_price, p.image, p.stock_quantity, p.unit, p.weight,
                   v.business_name as vendor_name, v.vendor_id,
                   (p.price * c.quantity) as item_total
            FROM cart c 
            JOIN products p ON c.product_id = p.product_id 
            JOIN vendors v ON p.vendor_id = v.vendor_id
            WHERE c.user_id = ? AND p.status = 'active'
            ORDER BY c.created_at DESC
        ");
        $stmt->execute([$userId]);
        $cartItems = $stmt->fetchAll();
        
        $totalAmount = 0;
        $totalItems = 0;
        $vendors = [];
        
        foreach ($cartItems as $item) {
            $totalAmount += $item['item_total'];
            $totalItems += $item['quantity'];
            
            if (!isset($vendors[$item['vendor_id']])) {
                $vendors[$item['vendor_id']] = [
                    'vendor_id' => $item['vendor_id'],
                    'vendor_name' => $item['vendor_name'],
                    'items' => [],
                    'vendor_total' => 0
                ];
            }
            
            $vendors[$item['vendor_id']]['items'][] = $item;
            $vendors[$item['vendor_id']]['vendor_total'] += $item['item_total'];
        }
        
        sendResponse('success', 'Cart retrieved successfully', [
            'cart_items' => $cartItems,
            'vendors' => array_values($vendors),
            'total_amount' => $totalAmount,
            'total_items' => $totalItems
        ]);
        
    } catch(PDOException $e) {
        sendResponse('error', 'Failed to get cart: ' . $e->getMessage());
    }
}

function addToCart() {
    global $pdo;
    
    $input = json_decode(file_get_contents('php://input'), true);
    validateRequired(['user_id', 'product_id'], $input);
    
    $userId = $input['user_id'];
    $productId = $input['product_id'];
    $quantity = $input['quantity'] ?? 1;
    
    try {
        // Check product availability
        $stmt = $pdo->prepare("SELECT stock_quantity FROM products WHERE product_id = ? AND status = 'active'");
        $stmt->execute([$productId]);
        $product = $stmt->fetch();
        
        if (!$product) {
            sendResponse('error', 'Product not found or inactive');
        }
        
        // Check if item already exists in cart
        $stmt = $pdo->prepare("SELECT cart_id, quantity FROM cart WHERE user_id = ? AND product_id = ?");
        $stmt->execute([$userId, $productId]);
        $existingItem = $stmt->fetch();
        
        if ($existingItem) {
            $newQuantity = $existingItem['quantity'] + $quantity;
            
            if ($newQuantity > $product['stock_quantity']) {
                sendResponse('error', 'Insufficient stock available');
            }
            
            $stmt = $pdo->prepare("UPDATE cart SET quantity = ? WHERE cart_id = ?");
            $stmt->execute([$newQuantity, $existingItem['cart_id']]);
            $message = 'Cart updated successfully';
        } else {
            if ($quantity > $product['stock_quantity']) {
                sendResponse('error', 'Insufficient stock available');
            }
            
            $stmt = $pdo->prepare("INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)");
            $stmt->execute([$userId, $productId, $quantity]);
            $message = 'Item added to cart successfully';
        }
        
        sendResponse('success', $message);
        
    } catch(PDOException $e) {
        sendResponse('error', 'Failed to add to cart: ' . $e->getMessage());
    }
}

function updateCart() {
    global $pdo;
    
    $input = json_decode(file_get_contents('php://input'), true);
    validateRequired(['cart_id', 'quantity'], $input);
    
    $cartId = $input['cart_id'];
    $quantity = $input['quantity'];
    
    if ($quantity <= 0) {
        sendResponse('error', 'Quantity must be greater than 0');
    }
    
    try {
        // Check stock availability
        $stmt = $pdo->prepare("
            SELECT p.stock_quantity 
            FROM cart c 
            JOIN products p ON c.product_id = p.product_id 
            WHERE c.cart_id = ?
        ");
        $stmt->execute([$cartId]);
        $product = $stmt->fetch();
        
        if (!$product) {
            sendResponse('error', 'Cart item not found');
        }
        
        if ($quantity > $product['stock_quantity']) {
            sendResponse('error', 'Insufficient stock available');
        }
        
        $stmt = $pdo->prepare("UPDATE cart SET quantity = ? WHERE cart_id = ?");
        $stmt->execute([$quantity, $cartId]);
        
        sendResponse('success', 'Cart updated successfully');
        
    } catch(PDOException $e) {
        sendResponse('error', 'Failed to update cart: ' . $e->getMessage());
    }
}

function removeFromCart() {
    global $pdo;
    
    $cartId = $_GET['cart_id'] ?? '';
    $userId = $_GET['user_id'] ?? '';
    
    try {
        if (!empty($cartId)) {
            $stmt = $pdo->prepare("DELETE FROM cart WHERE cart_id = ?");
            $stmt->execute([$cartId]);
            $message = 'Item removed from cart';
        } elseif (!empty($userId)) {
            $stmt = $pdo->prepare("DELETE FROM cart WHERE user_id = ?");
            $stmt->execute([$userId]);
            $message = 'Cart cleared successfully';
        } else {
            sendResponse('error', 'Cart ID or User ID required');
        }
        
        sendResponse('success', $message);
        
    } catch(PDOException $e) {
        sendResponse('error', 'Failed to remove from cart: ' . $e->getMessage());
    }
}
?>