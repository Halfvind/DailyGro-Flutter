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
        SELECT u.user_id, u.name, u.email, u.phone, r.role_name as role, u.created_at, p.address,
               rd.vehicle_type, rd.license_number, rd.vehicle_number, rd.availability_status, rd.verification_status, rd.rating
        FROM users u 
        JOIN roles r ON u.role_id = r.role_id 
        JOIN riders rd ON u.user_id = rd.user_id 
        LEFT JOIN user_profiles p ON u.user_id = p.user_id
        WHERE u.user_id = ? AND u.status = 'active'
    ");
    $stmt->execute([$userId]);
    $rider = $stmt->fetch();

    if (!$rider) {
        sendResponse('error', 'Rider not found');
    }

    sendResponse('success', 'Rider profile retrieved successfully', [
        'user_profile' => [
            'id' => $rider['user_id'],
            'name' => $rider['name'],
            'email' => $rider['email'],
            'phone' => $rider['phone'],
            'role' => $rider['role'],
            'created_at' => $rider['created_at'],
            'user_id' => $rider['user_id'],
            'address' => $rider['address'] ?? '',
            'vehicle_type' => $rider['vehicle_type'],
            'license_number' => $rider['license_number'],
            'vehicle_number' => $rider['vehicle_number'],
            'availability_status' => $rider['availability_status'],
            'verification_status' => $rider['verification_status'],
            'rating' => $rider['rating']
        ]
    ]);

} catch(PDOException $e) {
    sendResponse('error', 'Failed to get rider profile: ' . $e->getMessage());
}
?>