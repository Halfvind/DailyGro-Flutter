
<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST");
header("Access-Control-Allow-Headers: Content-Type");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "DailyGro";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Database connection failed"]);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        if (isset($_GET['coupon_id'])) {
            getCouponDetails();
        } else {
            getCouponsList();
        }
        break;

    case 'POST':
        createCoupon();
        break;

    default:
        echo json_encode(["status" => "error", "message" => "Method not allowed"]);
}

function getCouponsList() {
    global $conn;

    $sql = "SELECT * FROM coupons ORDER BY created_at DESC";
    $result = $conn->query($sql);

    $coupons = [];
    while ($row = $result->fetch_assoc()) {
        $coupons[] = [
            "coupon_id" => intval($row['coupon_id']),
            "code" => $row['code'],
            "title" => $row['title'],
            "description" => $row['description'],
            "discount_type" => $row['discount_type'],
            "discount_value" => (float)$row['discount_value'],
            "min_order_amount" => (float)$row['min_order_amount'],
            "max_discount" => (float)$row['max_discount'],
            "usage_limit" => $row['usage_limit'] !== null ? intval($row['usage_limit']) : null,
            "used_count" => intval($row['used_count']),
            "valid_from" => $row['valid_from'],
            "valid_until" => $row['valid_until'],
            "status" => $row['status'],
            "created_at" => $row['created_at']
        ];
    }

    echo json_encode([
        "status" => "success",
        "message" => "Coupons retrieved successfully",
        "coupons" => $coupons
    ]);
}

function getCouponDetails() {
    global $conn;

    $couponId = intval($_GET['coupon_id']);
    $sql = "SELECT * FROM coupons WHERE coupon_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $couponId);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        echo json_encode(["status" => "error", "message" => "Coupon not found"]);
        exit;
    }

    $row = $result->fetch_assoc();

    echo json_encode([
        "status" => "success",
        "message" => "Coupon retrieved successfully",
        "coupon" => [
            "coupon_id" => intval($row['coupon_id']),
            "code" => $row['code'],
            "title" => $row['title'],
            "description" => $row['description'],
            "discount_type" => $row['discount_type'],
            "discount_value" => (float)$row['discount_value'],
            "min_order_amount" => (float)$row['min_order_amount'],
            "max_discount" => (float)$row['max_discount'],
            "usage_limit" => $row['usage_limit'] !== null ? intval($row['usage_limit']) : null,
            "used_count" => intval($row['used_count']),
            "valid_from" => $row['valid_from'],
            "valid_until" => $row['valid_until'],
            "status" => $row['status'],
            "created_at" => $row['created_at']
        ]
    ]);

    $stmt->close();
}

function createCoupon() {
    global $conn;

    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['code'], $data['title'], $data['discount_type'], $data['discount_value'], $data['valid_from'], $data['valid_until'])) {
        echo json_encode(["status" => "error", "message" => "Required fields missing"]);
        exit;
    }

    $code = $data['code'];
    $title = $data['title'];
    $description = $data['description'] ?? '';
    $discountType = $data['discount_type'];
    $discountValue = floatval($data['discount_value']);
    $minOrderAmount = isset($data['min_order_amount']) ? floatval($data['min_order_amount']) : 0;
    $maxDiscount = isset($data['max_discount']) ? floatval($data['max_discount']) : null;
    $usageLimit = isset($data['usage_limit']) ? intval($data['usage_limit']) : null;
    $validFrom = $data['valid_from'];
    $validUntil = $data['valid_until'];
    $status = $data['status'] ?? 'active';

    // Validate discount type and status
    $validDiscountTypes = ['percentage', 'fixed'];
    $validStatuses = ['active', 'inactive'];

    if (!in_array($discountType, $validDiscountTypes)) {
        echo json_encode(["status" => "error", "message" => "Invalid discount_type"]);
        exit;
    }

    if (!in_array($status, $validStatuses)) {
        echo json_encode(["status" => "error", "message" => "Invalid status"]);
        exit;
    }

    $sql = "INSERT INTO coupons (code, title, description, discount_type, discount_value, min_order_amount, max_discount, usage_limit, valid_from, valid_until, status) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param(
        "sss sdd i ss s",
        $code, $title, $description, $discountType, $discountValue,
        $minOrderAmount, $maxDiscount, $usageLimit, $validFrom, $validUntil, $status
    );
    $execute = $stmt->execute();

    if ($execute) {
        echo json_encode([
            "status" => "success",
            "message" => "Coupon created successfully",
            "coupon_id" => $conn->insert_id
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Failed to create coupon: " . $stmt->error
        ]);
    }

    $stmt->close();
}

$conn->close();
?>
