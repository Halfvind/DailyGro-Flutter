<?php
require_once '../config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    sendResponse('error', 'Method not allowed');
}

$userId = $_GET['id'] ?? '';
if (empty($userId)) {
    sendResponse('error', 'User ID is required');
}

try {
    $stmt = $pdo->prepare("
        SELECT u.user_id, u.name, u.email, u.phone, r.role_name as role, u.created_at, p.address, p.date_of_birth, p.gender, p.profile_image
        FROM users u 
        JOIN roles r ON u.role_id = r.role_id 
        LEFT JOIN user_profiles p ON u.user_id = p.user_id 
        WHERE u.user_id = ? AND u.status = 'active'
    ");
    $stmt->execute([$userId]);
    $user = $stmt->fetch();

    if (!$user) {
        sendResponse('error', 'User not found');
    }

    sendResponse('success', 'Profile retrieved successfully', [
        'user_profile' => [
            'id' => $user['user_id'],
            'name' => $user['name'],
            'email' => $user['email'],
            'phone' => $user['phone'],
            'role' => $user['role'],
            'created_at' => $user['created_at'],
            'user_id' => $user['user_id'],
            'address' => $user['address'] ?? '',
            'date_of_birth' => $user['date_of_birth'],
            'gender' => $user['gender'],
            'profile_image' => $user['profile_image']
        ]
    ]);

} catch(PDOException $e) {
    sendResponse('error', 'Failed to get profile: ' . $e->getMessage());
}
?>