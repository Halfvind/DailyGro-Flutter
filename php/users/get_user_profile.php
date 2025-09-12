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
    echo json_encode(["status" => "error", "message" => "Database connection failed: " . $conn->connect_error]);
    exit;
}

try {
    // ===== GET USER PROFILE =====
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
            throw new Exception("Prepare failed: " . $conn->error);
        }

        $stmt->bind_param("i", $id);
        $stmt->execute();
        $stmt->store_result();

        if ($stmt->num_rows === 0) {
            echo json_encode(["status" => "error", "message" => "User profile not found"]);
            exit;
        }

        $stmt->bind_result(
            $user_id,
            $name,
            $email,
            $phone,
            $role_name,
            $created_at,
            $profile_id,
            $address,
            $date_of_birth,
            $gender,
            $profile_image
        );
        $stmt->fetch();
        $stmt->close();

        echo json_encode([
            "status" => "success",
            "user_profile" => [
                "id"           => $user_id,
                "name"         => $name,
                "email"        => $email,
                "phone"        => $phone,
                "role"         => $role_name,
                "created_at"   => $created_at,
                "address"      => $address,
                "date_of_birth"=> $date_of_birth,
                "gender"       => $gender,
                "profile_image"=> $profile_image
            ]
        ]);
    }

    // ===== UPDATE USER PROFILE =====
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

        // Update or insert into user_profiles
        if ($address || $dateOfBirth || $gender || $profileImg) {
            // Check if profile exists
            $checkSql = "SELECT profile_id FROM user_profiles WHERE user_id = ?";
            $stmt = $conn->prepare($checkSql);
            $stmt->bind_param("i", $id);
            $stmt->execute();
            $stmt->store_result();

            if ($stmt->num_rows > 0) {
                // Update existing profile
                $stmt->bind_result($profile_id);
                $stmt->fetch();
                $stmt->close();

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
                // Insert new profile
                $stmt->close();
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

    // ===== INVALID METHOD =====
    else {
        echo json_encode(["status" => "error", "message" => "Invalid request method"]);
    }

} catch (Exception $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}

$conn->close();
?>
