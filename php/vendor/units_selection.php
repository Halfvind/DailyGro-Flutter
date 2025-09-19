
<?php
header('Content-Type: application/json');

$units = [
    ["id" => 1, "name" => "kg"],
    ["id" => 2, "name" => "gram"],
    ["id" => 3, "name" => "litre"],
    ["id" => 4, "name" => "piece"],
    ["id" => 5, "name" => "pack"]
];

echo json_encode([
    'status' => 'success',
    'message' => 'Units retrieved successfully',
    'units' => $units
]);
?>
