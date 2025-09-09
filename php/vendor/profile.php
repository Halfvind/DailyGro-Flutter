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
        SELECT u.user_id, u.name, u.email, u.phone, r.role_name as role, u.created_at, 
               v.business_name, v.business_address, v.business_type, v.verification_status, v.rating
        FROM users u 
        JOIN roles r ON u.role_id = r.role_id 
        JOIN vendors v ON u.user_id = v.user_id 
        WHERE u.user_id = ? AND u.status = 'active'
    ");
    $stmt->execute([$userId]);
    $vendor = $stmt->fetch();

    if (!$vendor) {
        sendResponse('error', 'Vendor not found');
    }

    sendResponse('success', 'Vendor profile retrieved successfully', [
        'user_profile' => [
            'id' => $vendor['user_id'],
            'name' => $vendor['business_name'],
            'email' => $vendor['email'],
            'phone' => $vendor['phone'],
            'role' => $vendor['role'],
            'created_at' => $vendor['created_at'],
            'user_id' => $vendor['user_id'],
            'address' => $vendor['business_address'],
            'business_type' => $vendor['business_type'],
            'verification_status' => $vendor['verification_status'],
            'rating' => $vendor['rating']
        ]
    ]);

} catch(PDOException $e) {
    sendResponse('error', 'Failed to get vendor profile: ' . $e->getMessage());
}
?>