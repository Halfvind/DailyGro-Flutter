<?php
require_once '../config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendResponse('error', 'Method not allowed');
}

$input = json_decode(file_get_contents('php://input'), true);
validateRequired(['email', 'password', 'role'], $input);

$email = $input['email'];
$password = $input['password'];
$role = $input['role'];

$roleMap = ['user' => 1, 'vendor' => 2, 'rider' => 3];
$roleId = $roleMap[$role] ?? 1;

try {
    $stmt = $pdo->prepare("
        SELECT u.user_id, u.name, u.email, u.phone, u.role_id, u.password, r.role_name 
        FROM users u 
        JOIN roles r ON u.role_id = r.role_id 
        WHERE u.email = ? AND u.role_id = ? AND u.status = 'active'
    ");
    $stmt->execute([$email, $roleId]);
    $user = $stmt->fetch();

    if (!$user || !password_verify($password, $user['password'])) {
        sendResponse('error', 'Invalid credentials');
    }

    unset($user['password']);

    // Get profile data
    $stmt = $pdo->prepare("SELECT * FROM user_profiles WHERE user_id = ?");
    $stmt->execute([$user['user_id']]);
    $profile = $stmt->fetch();

    // Get role-specific data
    $roleData = null;
    if ($role === 'vendor') {
        $stmt = $pdo->prepare("SELECT * FROM vendors WHERE user_id = ?");
        $stmt->execute([$user['user_id']]);
        $roleData = $stmt->fetch();
    } elseif ($role === 'rider') {
        $stmt = $pdo->prepare("SELECT * FROM riders WHERE user_id = ?");
        $stmt->execute([$user['user_id']]);
        $roleData = $stmt->fetch();
    }

    sendResponse('success', 'Login successful', [
        'data' => [
            'user' => [
                'id' => $user['user_id'],
                'name' => $user['name'],
                'email' => $user['email'],
                'phone' => $user['phone'],
                'role' => $user['role_name'],
                'created_at' => date('Y-m-d H:i:s')
            ],
            'profile' => [
                'id' => $profile['profile_id'] ?? null,
                'user_id' => $user['user_id'],
                'address' => $profile['address'] ?? '',
                'date_of_birth' => $profile['date_of_birth'] ?? null,
                'gender' => $profile['gender'] ?? null
            ],
            'role_data' => $roleData
        ]
    ]);

} catch(PDOException $e) {
    sendResponse('error', 'Login failed: ' . $e->getMessage());
}
?>