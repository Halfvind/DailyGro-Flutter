<?php
require_once '../config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'error', 'message' => 'Method not allowed']);
    exit;
}

$rider_id = $_POST['rider_id'] ?? null;
$status = $_POST['status'] ?? null; // available, busy, offline

if (!$rider_id || !$status) {
    echo json_encode(['status' => 'error', 'message' => 'Required fields missing']);
    exit;
}

if (!in_array($status, ['available', 'busy', 'offline'])) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid status']);
    exit;
}

try {
    $stmt = $pdo->prepare("UPDATE riders SET availability_status = ? WHERE rider_id = ?");
    $stmt->execute([$status, $rider_id]);
    
    if ($stmt->rowCount() === 0) {
        echo json_encode(['status' => 'error', 'message' => 'Rider not found']);
        exit;
    }
    
    echo json_encode([
        'status' => 'success',
        'message' => 'Availability status updated',
        'availability_status' => $status
    ]);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
}
?>