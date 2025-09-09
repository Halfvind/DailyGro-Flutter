<?php
require_once '../config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    registerUser();
} elseif ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    updateProfile();
} else {
    sendResponse('error', 'Method not allowed');
}

function registerUser() {
    global $pdo;
    
    $input = json_decode(file_get_contents('php://input'), true);
    validateRequired(['name', 'email', 'password', 'phone', 'role'], $input);
    
    $name = $input['name'];
    $email = $input['email'];
    $password = $input['password'];
    $phone = $input['phone'];
    $role = $input['role'];
    $address = $input['address'] ?? '';
    
    $roleMap = ['user' => 1, 'vendor' => 2, 'rider' => 3];
    $roleId = $roleMap[$role] ?? 1;
    
    try {
        // Check if email exists
        $stmt = $pdo->prepare("SELECT user_id FROM users WHERE email = ?");
        $stmt->execute([$email]);
        if ($stmt->fetch()) {
            sendResponse('error', 'Email already registered');
        }
        
        $pdo->beginTransaction();
        
        // Insert user
        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
        $stmt = $pdo->prepare("INSERT INTO users (name, email, password, phone, role_id) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute([$name, $email, $hashedPassword, $phone, $roleId]);
        $userId = $pdo->lastInsertId();
        
        // Insert user profile
        $stmt = $pdo->prepare("INSERT INTO user_profiles (user_id, address) VALUES (?, ?)");
        $stmt->execute([$userId, $address]);
        
        // Insert role-specific data
        if ($role === 'vendor') {
            $businessName = $input['business_name'] ?? $name;
            $businessAddress = $input['business_address'] ?? $address;
            $businessType = $input['business_type'] ?? '';
            $licenseNumber = $input['license_number'] ?? '';
            
            $stmt = $pdo->prepare("INSERT INTO vendors (user_id, business_name, business_address, business_type, license_number) VALUES (?, ?, ?, ?, ?)");
            $stmt->execute([$userId, $businessName, $businessAddress, $businessType, $licenseNumber]);
        }
        
        if ($role === 'rider') {
            validateRequired(['vehicle_type', 'license_number'], $input);
            $vehicleType = $input['vehicle_type'];
            $licenseNumber = $input['license_number'];
            $vehicleNumber = $input['vehicle_number'] ?? '';
            
            $stmt = $pdo->prepare("INSERT INTO riders (user_id, vehicle_type, license_number, vehicle_number) VALUES (?, ?, ?, ?)");
            $stmt->execute([$userId, $vehicleType, $licenseNumber, $vehicleNumber]);
        }
        
        // Create wallet for user
        $stmt = $pdo->prepare("INSERT INTO wallet (user_id, balance) VALUES (?, 0.00)");
        $stmt->execute([$userId]);
        
        $pdo->commit();
        sendResponse('success', ucfirst($role) . ' registration successful', ['user_id' => $userId]);
        
    } catch(PDOException $e) {
        $pdo->rollBack();
        sendResponse('error', 'Registration failed: ' . $e->getMessage());
    }
}

function updateProfile() {
    global $pdo;
    
    $input = json_decode(file_get_contents('php://input'), true);
    validateRequired(['id'], $input);
    
    $userId = $input['id'];
    $name = $input['name'] ?? '';
    $phone = $input['phone'] ?? '';
    $address = $input['address'] ?? '';
    $role = $input['role'] ?? 'user';
    
    try {
        $pdo->beginTransaction();
        
        // Update user
        if ($name && $phone) {
            $stmt = $pdo->prepare("UPDATE users SET name = ?, phone = ? WHERE user_id = ?");
            $stmt->execute([$name, $phone, $userId]);
        }
        
        // Update profile
        $stmt = $pdo->prepare("UPDATE user_profiles SET address = ? WHERE user_id = ?");
        $stmt->execute([$address, $userId]);
        
        // Update role-specific data
        if ($role === 'vendor') {
            $businessName = $input['business_name'] ?? '';
            $businessAddress = $input['business_address'] ?? '';
            $businessType = $input['business_type'] ?? '';
            
            $stmt = $pdo->prepare("UPDATE vendors SET business_name = ?, business_address = ?, business_type = ? WHERE user_id = ?");
            $stmt->execute([$businessName, $businessAddress, $businessType, $userId]);
        }
        
        if ($role === 'rider') {
            $vehicleType = $input['vehicle_type'] ?? '';
            $licenseNumber = $input['license_number'] ?? '';
            $vehicleNumber = $input['vehicle_number'] ?? '';
            
            $stmt = $pdo->prepare("UPDATE riders SET vehicle_type = ?, license_number = ?, vehicle_number = ? WHERE user_id = ?");
            $stmt->execute([$vehicleType, $licenseNumber, $vehicleNumber, $userId]);
        }
        
        $pdo->commit();
        sendResponse('success', 'Profile updated successfully');
        
    } catch(PDOException $e) {
        $pdo->rollBack();
        sendResponse('error', 'Update failed: ' . $e->getMessage());
    }
}
?>