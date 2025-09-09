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

// ✅ Handle GET (fetch profile)
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (!isset($_GET['id']) || empty($_GET['id'])) {
        echo json_encode(["status" => "error", "message" => "User ID is required"]);
        exit;
    }

    $id = intval($_GET['id']);

    $sql = "SELECT 
                u.user_id,
                u.name,
                u.email,
                u.phone,
                r.role_name,
                u.created_at,
                p.profile_id,
                p.address,
                p.date_of_birth,
                p.gender,
                p.profile_image
            FROM users u
            LEFT JOIN user_profiles p ON u.user_id = p.user_id
            LEFT JOIN roles r ON u.role_id = r.role_id
            WHERE u.user_id = ?";
    $stmt = $conn->prepare($sql);
    if (!$stmt) {
        echo json_encode(["status" => "error", "message" => "Prepare failed: " . $conn->error]);
        exit;
    }

    $stmt->bind_param("i", $id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        echo json_encode(["status" => "error", "message" => "User profile not found"]);
        exit;
    }

    $user = $result->fetch_assoc();

    echo json_encode([
        "status" => "success",
        "user_profile" => [
            "id"           => $user['user_id'],
            "name"         => $user['name'],
            "email"        => $user['email'],
            "phone"        => $user['phone'],
            "role"         => $user['role_name'],
            "created_at"   => $user['created_at'],
            "address"      => $user['address'],
            "date_of_birth"=> $user['date_of_birth'],
            "gender"       => $user['gender'],
            "profile_image"=> $user['profile_image']
        ]
    ]);

    $stmt->close();
}

// ✅ Handle POST (update profile)
elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);

    $id          = $data['id'] ?? null;
    $name        = $data['name'] ?? null;
    $phone       = $data['phone'] ?? null;
    $address     = $data['address'] ?? null;
    $dateOfBirth = $data['date_of_birth'] ?? null;
    $gender      = $data['gender'] ?? null;
    $profileImg  = $data['profile_image'] ?? null;

    if (!$id) {
        echo json_encode(["status" => "error", "message" => "User ID is required"]);
        exit;
    }

    // Update users table
    if ($name || $phone) {
        $sql = "UPDATE users SET 
                    name = IFNULL(?, name), 
                    phone = IFNULL(?, phone) 
                WHERE user_id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssi", $name, $phone, $id);
        $stmt->execute();
        $stmt->close();
    }

    // Update user_profiles table
    if ($address || $dateOfBirth || $gender || $profileImg) {
        // Check if profile exists
        $checkSql = "SELECT profile_id FROM user_profiles WHERE user_id = ?";
        $stmt = $conn->prepare($checkSql);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $checkResult = $stmt->get_result();
        $stmt->close();

        if ($checkResult->num_rows > 0) {
            $sql = "UPDATE user_profiles 
                    SET address = IFNULL(?, address), 
                        date_of_birth = IFNULL(?, date_of_birth), 
                        gender = IFNULL(?, gender), 
                        profile_image = IFNULL(?, profile_image) 
                    WHERE user_id = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("ssssi", $address, $dateOfBirth, $gender, $profileImg, $id);
            $stmt->execute();
            $stmt->close();
        } else {
            $sql = "INSERT INTO user_profiles (user_id, address, date_of_birth, gender, profile_image) 
                    VALUES (?, ?, ?, ?, ?)";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("issss", $id, $address, $dateOfBirth, $gender, $profileImg);
            $stmt->execute();
            $stmt->close();
        }
    }

    echo json_encode(["status" => "success", "message" => "User profile updated successfully"]);
}

else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}

$conn->close();
?>