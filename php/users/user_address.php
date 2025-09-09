<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header("Content-Type: application/json");

// DB Connection
$servername = "localhost";
$username   = "root";
$password   = "";
$dbname     = "DailyGro";
$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Database connection failed"]);
    exit;
}

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
        echo json_encode(["status" => "error", "message" => "Method not allowed"]);
}

function getAddresses() {
    global $conn;
    
    if (!isset($_GET['user_id']) || empty($_GET['user_id'])) {
        echo json_encode(["status" => "error", "message" => "User ID is required"]);
        exit;
    }

    $userId = intval($_GET['user_id']);

    $sql = "SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC, created_at DESC";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $result = $stmt->get_result();

    $addresses = [];
    while ($row = $result->fetch_assoc()) {
        $addresses[] = $row;
    }

    echo json_encode([
        "status" => "success",
        "message" => "Addresses retrieved successfully",
        "addresses" => $addresses
    ]);

    $stmt->close();
}

function addAddress() {
    global $conn;
    
    $data = json_decode(file_get_contents("php://input"), true);

    $required = ['user_id', 'title', 'name', 'phone', 'address_line', 'city', 'state', 'pincode'];
    foreach ($required as $field) {
        if (!isset($data[$field]) || empty($data[$field])) {
            echo json_encode(["status" => "error", "message" => ucfirst(str_replace('_', ' ', $field)) . " is required"]);
            exit;
        }
    }

    $conn->begin_transaction();

    try {
        // If this is default address, unset other defaults
        if ($data['is_default'] ?? false) {
            $stmt = $conn->prepare("UPDATE addresses SET is_default = 0 WHERE user_id = ?");
            $stmt->bind_param("i", $data['user_id']);
            $stmt->execute();
            $stmt->close();
        }

        $isDefault = ($data['is_default'] ?? false) ? 1 : 0;
        
        $sql = "INSERT INTO addresses (user_id, title, name, phone, address_line, landmark, city, state, pincode, latitude, longitude, is_default, address_type) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param(
            "issssssssdds",
            $data['user_id'],
            $data['title'],
            $data['name'],
            $data['phone'],
            $data['address_line'],
            $data['landmark'] ?? null,
            $data['city'],
            $data['state'],
            $data['pincode'],
            $data['latitude'] ?? null,
            $data['longitude'] ?? null,
            $isDefault,
            $data['address_type'] ?? 'home'
        );
        $stmt->execute();

        $conn->commit();
        echo json_encode(["status" => "success", "message" => "Address added successfully", "address_id" => $conn->insert_id]);
        $stmt->close();

    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(["status" => "error", "message" => "Failed to add address: " . $e->getMessage()]);
    }
}

function updateAddress() {
    global $conn;
    
    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['address_id']) || empty($data['address_id'])) {
        echo json_encode(["status" => "error", "message" => "Address ID is required"]);
        exit;
    }

    $conn->begin_transaction();

    try {
        // If this is default address, unset other defaults
        if ($data['is_default'] ?? false) {
            $stmt = $conn->prepare("SELECT user_id FROM addresses WHERE address_id = ?");
            $stmt->bind_param("i", $data['address_id']);
            $stmt->execute();
            $result = $stmt->get_result();
            $address = $result->fetch_assoc();
            $stmt->close();

            if ($address) {
                $stmt = $conn->prepare("UPDATE addresses SET is_default = 0 WHERE user_id = ?");
                $stmt->bind_param("i", $address['user_id']);
                $stmt->execute();
                $stmt->close();
            }
        }

        $isDefault = ($data['is_default'] ?? false) ? 1 : 0;
        
        $sql = "UPDATE addresses SET title = ?, name = ?, phone = ?, address_line = ?, landmark = ?, city = ?, state = ?, pincode = ?, is_default = ?, address_type = ? WHERE address_id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param(
            "ssssssssssi",
            $data['title'] ?? '',
            $data['name'] ?? '',
            $data['phone'] ?? '',
            $data['address_line'] ?? '',
            $data['landmark'] ?? null,
            $data['city'] ?? '',
            $data['state'] ?? '',
            $data['pincode'] ?? '',
            $isDefault,
            $data['address_type'] ?? 'home',
            $data['address_id']
        );
        $stmt->execute();

        $conn->commit();
        echo json_encode(["status" => "success", "message" => "Address updated successfully"]);
        $stmt->close();

    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(["status" => "error", "message" => "Failed to update address: " . $e->getMessage()]);
    }
}

function deleteAddress() {
    global $conn;
    
    if (!isset($_GET['address_id']) || empty($_GET['address_id'])) {
        echo json_encode(["status" => "error", "message" => "Address ID is required"]);
        exit;
    }

    $addressId = intval($_GET['address_id']);

    $stmt = $conn->prepare("DELETE FROM addresses WHERE address_id = ?");
    $stmt->bind_param("i", $addressId);
    
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Address deleted successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to delete address"]);
    }

    $stmt->close();
}

$conn->close();
?>