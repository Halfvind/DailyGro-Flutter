
<?php
require_once '../config.php';

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        getAddresses();
        break;
    case 'POST':
        addAddress();
        break;
    case 'PUT':
        updateAddress();
        break;
    case 'DELETE':
        deleteAddress();
        break;
    default:
        sendResponse('error', 'Method not allowed');
}

function getAddresses() {
    global $pdo;
    
    $userId = $_GET['user_id'] ?? '';
    if (empty($userId)) {
        sendResponse('error', 'User ID required');
    }
    
    try {
        $stmt = $pdo->prepare("SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC, created_at DESC");
        $stmt->execute([$userId]);
        $addresses = $stmt->fetchAll();
        
        sendResponse('success', 'Addresses retrieved successfully', ['addresses' => $addresses]);
        
    } catch(PDOException $e) {
        sendResponse('error', 'Failed to get addresses: ' . $e->getMessage());
    }
}

function addAddress() {
    global $pdo;
    
    $input = json_decode(file_get_contents('php://input'), true);
    validateRequired(['user_id', 'title', 'name', 'phone', 'address_line', 'city', 'state', 'pincode'], $input);
    
    try {
        $pdo->beginTransaction();
        
        // If this is default address, unset other defaults
        if ($input['is_default'] ?? false) {
            $stmt = $pdo->prepare("UPDATE addresses SET is_default = FALSE WHERE user_id = ?");
            $stmt->execute([$input['user_id']]);
        }
        
        $stmt = $pdo->prepare("
            INSERT INTO addresses (user_id, title, name, phone, address_line, landmark, city, state, pincode, latitude, longitude, is_default, address_type) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ");
        $stmt->execute([
            $input['user_id'],
            $input['title'],
            $input['name'],
            $input['phone'],
            $input['address_line'],
            $input['landmark'] ?? '',
            $input['city'],
            $input['state'],
            $input['pincode'],
            $input['latitude'] ?? null,
            $input['longitude'] ?? null,
            $input['is_default'] ?? false,
            $input['address_type'] ?? 'home'
        ]);
        
        $pdo->commit();
        sendResponse('success', 'Address added successfully', ['address_id' => $pdo->lastInsertId()]);
        
    } catch(PDOException $e) {
        $pdo->rollBack();
        sendResponse('error', 'Failed to add address: ' . $e->getMessage());
    }
}

function updateAddress() {
    global $pdo;
    
    $input = json_decode(file_get_contents('php://input'), true);
    validateRequired(['address_id'], $input);
    
    try {
        $pdo->beginTransaction();
        
        // If this is default address, unset other defaults
        if ($input['is_default'] ?? false) {
            $stmt = $pdo->prepare("SELECT user_id FROM addresses WHERE address_id = ?");
            $stmt->execute([$input['address_id']]);
            $address = $stmt->fetch();
            
            if ($address) {
                $stmt = $pdo->prepare("UPDATE addresses SET is_default = FALSE WHERE user_id = ?");
                $stmt->execute([$address['user_id']]);
            }
        }
        
        $stmt = $pdo->prepare("
            UPDATE addresses SET 
            title = ?, name = ?, phone = ?, address_line = ?, landmark = ?, 
            city = ?, state = ?, pincode = ?, is_default = ?, address_type = ?
            WHERE address_id = ?
        ");
        $stmt->execute([
            $input['title'] ?? '',
            $input['name'] ?? '',
            $input['phone'] ?? '',
            $input['address_line'] ?? '',
            $input['landmark'] ?? '',
            $input['city'] ?? '',
            $input['state'] ?? '',
            $input['pincode'] ?? '',
            $input['is_default'] ?? false,
            $input['address_type'] ?? 'home',
            $input['address_id']
        ]);
        
        $pdo->commit();
        sendResponse('success', 'Address updated successfully');
        
    } catch(PDOException $e) {
        $pdo->rollBack();
        sendResponse('error', 'Failed to update address: ' . $e->getMessage());
    }
}

function deleteAddress() {
    global $pdo;
    
    $addressId = $_GET['address_id'] ?? '';
    if (empty($addressId)) {
        sendResponse('error', 'Address ID required');
    }
    
    try {
        $stmt = $pdo->prepare("DELETE FROM addresses WHERE address_id = ?");
        $stmt->execute([$addressId]);
        
        sendResponse('success', 'Address deleted successfully');
        
    } catch(PDOException $e) {
        sendResponse('error', 'Failed to delete address: ' . $e->getMessage());
    }
}
?>
