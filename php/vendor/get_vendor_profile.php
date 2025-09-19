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

// ------------------ GET VENDOR PROFILE ------------------
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (!isset($_GET['id']) || empty($_GET['id'])) {
        echo json_encode(["status" => "error", "message" => "User ID is required"]);
        exit;
    }

    $id = intval($_GET['id']);

    $sql = "SELECT
        u.user_id,
        u.name AS user_name,
        u.email AS user_email,
        u.phone AS user_phone,
        r.role_name,
        u.created_at,
        v.vendor_id,
        v.business_name,
        v.business_address,
        v.business_type,
        v.license_number,
        v.verification_status,
        v.rating,
        v.store_status,
        v.opening_time,
        v.closing_time,
        v.upi_id,
        v.bank_account_number
    FROM users u
    JOIN roles r ON u.role_id = r.role_id
    JOIN vendors v ON u.user_id = v.user_id
    WHERE u.user_id = ? AND u.status = 'active'";

    $stmt = $conn->prepare($sql);
    if (!$stmt) {
        echo json_encode(["status" => "error", "message" => "Prepare failed: " . $conn->error]);
        exit;
    }

    $stmt->bind_param("i", $id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        echo json_encode(["status" => "error", "message" => "Vendor not found"]);
        exit;
    }

    $vendor = $result->fetch_assoc();

    echo json_encode([
        "status" => "success",
        "user_profile" => [
            "vendor_id"           => $vendor['vendor_id'],
            "store_name"          => $vendor['business_name'],
            "vendor_name"         => $vendor['user_name'],
            "business_license"    => $vendor['license_number'],
            "contact_number"      => $vendor['user_phone'],
            "vendor_mail"         => $vendor['user_email'],
            "business_address"    => $vendor['business_address'],
            "business_type"       => $vendor['business_type'],
            "verification_status" => $vendor['verification_status'],
            "rating"              => (float)$vendor['rating'],
            "created_at"          => $vendor['created_at'],
            "store_status"        => $vendor['store_status'],
            "opening_time"        => $vendor['opening_time'],
            "closing_time"        => $vendor['closing_time'],
            "upi_id"              => $vendor['upi_id'],
            "bank_account_number" => $vendor['bank_account_number']
        ]
    ]);

    $stmt->close();
    $conn->close();
    exit;
}

// ------------------ UPDATE VENDOR PROFILE ------------------
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);

    $vendor_id        = intval($input['vendor_id'] ?? 0);
    $vendor_name      = $input['vendor_name'] ?? null;
    $vendor_mail      = $input['vendor_mail'] ?? null;
    $contact_number   = $input['contact_number'] ?? null;
    $business_name    = $input['store_name'] ?? null;
    $business_address = $input['business_address'] ?? null;
    $license_number   = $input['business_license'] ?? null;
    $business_type    = $input['business_type'] ?? null;
    $verification_status = $input['verification_status'] ?? null;
    $rating = is_numeric($input['rating']) ? $input['rating'] : 0.0;

    // Convert 1/0 to 'open'/'closed'
    $store_status_input = $input['store_status'] ?? 1;
    $store_status = ($store_status_input == 1) ? 'open' : 'closed';

    $opening_time = $input['opening_time'] ?? null;
    $closing_time = $input['closing_time'] ?? null;
    $upi_id = $input['upi_id'] ?? null;
    $bank_account_number = $input['bank_account_number'] ?? null;

    if (empty($vendor_id) || empty($business_name) || empty($vendor_name) || empty($vendor_mail) || empty($contact_number)) {
        echo json_encode(["status" => "error", "message" => "Vendor ID, Store Name, Vendor Name, Email, and Contact Number are required"]);
        exit;
    }

    // ------------------ Update vendors table ------------------
    $sql_vendor = "UPDATE vendors SET
        business_name       = ?,
        license_number      = ?,
        business_address    = ?,
        business_type       = ?,
        verification_status = ?,
        rating              = ?,
        store_status        = ?,
        opening_time        = ?,
        closing_time        = ?,
        upi_id              = ?,
        bank_account_number = ?
    WHERE vendor_id = ?";

    $stmt_vendor = $conn->prepare($sql_vendor);
    if (!$stmt_vendor) {
        echo json_encode(["status" => "error", "message" => "Prepare vendors failed: " . $conn->error]);
        exit;
    }

    $stmt_vendor->bind_param(
        "sssssssssssi",
        $business_name,
        $license_number,
        $business_address,
        $business_type,
        $verification_status,
        $rating,
        $store_status,
        $opening_time,
        $closing_time,
        $upi_id,
        $bank_account_number,
        $vendor_id
    );

    $stmt_vendor->execute();

    // ------------------ Update users table ------------------
    $sql_user = "UPDATE users SET
        name  = ?,
        email = ?,
        phone = ?
    WHERE user_id = (SELECT user_id FROM vendors WHERE vendor_id = ?)";

    $stmt_user = $conn->prepare($sql_user);
    if (!$stmt_user) {
        echo json_encode(["status" => "error", "message" => "Prepare users failed: " . $conn->error]);
        exit;
    }

    $stmt_user->bind_param(
        "sssi",
        $vendor_name,
        $vendor_mail,
        $contact_number,
        $vendor_id
    );

    if ($stmt_user->execute()) {
        echo json_encode(["status" => "success", "message" => "Vendor profile updated successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Update failed: " . $stmt_user->error]);
    }

    $stmt_vendor->close();
    $stmt_user->close();
    $conn->close();
    exit;
}

// ------------------ INVALID METHOD ------------------
echo json_encode(["status" => "error", "message" => "Invalid request method"]);
$conn->close();
?>
