<?php
require_once '../config.php';
header('Content-Type: application/json');

try {
    // Static units data as per your requirement
    $units = [
        ['id' => 1, 'name' => 'kg'],
        ['id' => 2, 'name' => 'gram'],
        ['id' => 3, 'name' => 'litre'],
        ['id' => 4, 'name' => 'piece'],
        ['id' => 5, 'name' => 'pack']
    ];
    
    echo json_encode([
        'status' => 'success',
        'message' => 'Units retrieved successfully',
        'units' => $units
    ]);
} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => 'Error: ' . $e->getMessage()]);
}
?>