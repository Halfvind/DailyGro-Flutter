<?php
// --- Debug & Error Logging ---
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

ini_set("log_errors", 1);
ini_set("error_log", __DIR__ . "/php-error.log");

// --- Include DB config ---
require_once __DIR__ . '/config.php';

// --- Router ---
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    registerUser();
} elseif ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    updateProfile();
} else {
    sendResponse('error', 'Method not allowed');
}

/**
 * Register User / Vendor / Rider
 */
function registerUser() {
    global $pdo;

    $input = json_decode(file_get_contents('php://input'), true);
    if (!$input) {
        sendResponse('error', 'Invalid JSON received');
    }

    validateRequired(['name', 'email', 'password', 'phone', 'role'], $input);

    $name     = trim($input['name']);
    $email    = strtolower(trim($input['email']));
    $password = $input['password'];
    $phone    = trim($input['phone']);
    $role     = strtolower(trim($input['role']));
    $address  = isset($input['address']) ? trim($input['address']) : '';

    $roleMap = ['user' => 1, 'vendor' => 2, 'rider' => 3];
    $roleId  = $roleMap[$role] ?? 1;

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
        $stmt = $pdo->prepare("
            INSERT INTO users (name, email, password, phone, role_id, status) 
            VALUES (?, ?, ?, ?, ?, 'active')
        ");
        $stmt->execute([$name, $email, $hashedPassword, $phone, $roleId]);
        $userId = $pdo->lastInsertId();

        // Insert user profile
        $stmt = $pdo->prepare("INSERT INTO user_profiles (user_id, address) VALUES (?, ?)");
        $stmt->execute([$userId, $address]);

        // Insert role-specific data
        if ($role === 'vendor') {
            $businessName    = $input['business_name'] ?? $name;
            $businessAddress = $input['business_address'] ?? $address;
            $businessType    = $input['business_type'] ?? '';
            $licenseNumber   = $input['license_number'] ?? '';

            $stmt = $pdo->prepare("
                INSERT INTO vendors (user_id, business_name, business_address, business_type, license_number) 
                VALUES (?, ?, ?, ?, ?)
            ");
            $stmt->execute([$userId, $businessName, $businessAddress, $businessType, $licenseNumber]);
        }

        if ($role === 'rider') {
            validateRequired(['vehicle_type', 'license_number'], $input);
            $vehicleType   = $input['vehicle_type'];
            $licenseNumber = $input['license_number'];
            $vehicleNumber = $input['vehicle_number'] ?? '';

            $stmt = $pdo->prepare("
                INSERT INTO riders (user_id, vehicle_type, license_number, vehicle_number) 
                VALUES (?, ?, ?, ?)
            ");
            $stmt->execute([$userId, $vehicleType, $licenseNumber, $vehicleNumber]);
        }

        // Create wallet for user
        $stmt = $pdo->prepare("INSERT INTO wallet (user_id, balance) VALUES (?, 0.00)");
        $stmt->execute([$userId]);

        $pdo->commit();
        sendResponse('success', ucfirst($role) . ' registration successful', [
            'user_id' => $userId,
            'email'   => $email,
            'role'    => $role
        ]);

    } catch (PDOException $e) {
        $pdo->rollBack();
        error_log("Registration failed: " . $e->getMessage());
        sendResponse('error', 'Registration failed: ' . $e->getMessage());
    }
}

/**
 * Update Profile
 */
function updateProfile() {
    global $pdo;

    $input = json_decode(file_get_contents('php://input'), true);
    if (!$input) {
        sendResponse('error', 'Invalid JSON received');
    }

    validateRequired(['id'], $input);

    $userId  = $input['id'];
    $name    = $input['name'] ?? '';
    $phone   = $input['phone'] ?? '';
    $address = $input['address'] ?? '';
    $role    = strtolower($input['role'] ?? 'user');

    try {
        $pdo->beginTransaction();

        // Update user
        if ($name || $phone) {
            $stmt = $pdo->prepare("UPDATE users SET name = ?, phone = ? WHERE user_id = ?");
            $stmt->execute([$name, $phone, $userId]);
        }

        // Update profile
        $stmt = $pdo->prepare("UPDATE user_profiles SET address = ? WHERE user_id = ?");
        $stmt->execute([$address, $userId]);

        // Update role-specific data
        if ($role === 'vendor') {
            $businessName    = $input['business_name'] ?? '';
            $businessAddress = $input['business_address'] ?? '';
            $businessType    = $input['business_type'] ?? '';

            $stmt = $pdo->prepare("
                UPDATE vendors SET business_name = ?, business_address = ?, business_type = ? 
                WHERE user_id = ?
            ");
            $stmt->execute([$businessName, $businessAddress, $businessType, $userId]);
        }

        if ($role === 'rider') {
            $vehicleType   = $input['vehicle_type'] ?? '';
            $licenseNumber = $input['license_number'] ?? '';
            $vehicleNumber = $input['vehicle_number'] ?? '';

            $stmt = $pdo->prepare("
                UPDATE riders SET vehicle_type = ?, license_number = ?, vehicle_number = ? 
                WHERE user_id = ?
            ");
            $stmt->execute([$vehicleType, $licenseNumber, $vehicleNumber, $userId]);
        }

        $pdo->commit();
        sendResponse('success', 'Profile updated successfully');

    } catch (PDOException $e) {
        $pdo->rollBack();
        error_log("Update failed: " . $e->getMessage());
        sendResponse('error', 'Update failed: ' . $e->getMessage());
    }
}
?>