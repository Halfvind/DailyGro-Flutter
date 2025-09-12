<?php
// --- Debug mode ---
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// --- Database connection ---
$host = "localhost";
$db   = "dailygro";
$user = "root";
$pass = "";
$charset = "utf8mb4";

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
<?php
// Database configuration
$servername = "localhost";
$username   = "root";
$password   = "";
$dbname     = "DailyGro";  // use the exact case of your DB name

try {
    $pdo = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch(PDOException $e) {
    die(json_encode(['status' => 'error', 'message' => 'Database connection failed: ' . $e->getMessage()]));
}

// CORS headers
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit(0);
}

// Helper functions
function generateOrderNumber() {
    return 'DG' . date('Ymd') . rand(1000, 9999);
}

function sendResponse($status, $message, $data = null) {
    $response = ['status' => $status, 'message' => $message];
    if ($data !== null) {
        $response = array_merge($response, $data);
    }
    echo json_encode($response);
    exit;
}

function validateRequired($fields, $data) {
    foreach ($fields as $field) {
        if (empty($data[$field])) {
            sendResponse('error', ucfirst(str_replace('_', ' ', $field)) . ' is required');
        }
    }
}
?>

$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
];
try {
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (PDOException $e) {
    sendResponse('error', 'DB connection failed: ' . $e->getMessage());
}

// --- Helper functions ---
function sendResponse($status, $message, $data = null) {
    header('Content-Type: application/json');
    echo json_encode([
        'status' => $status,
        'message' => $message,
        'data' => $data
    ]);
    exit;
}

function validateRequired($fields, $input) {
    foreach ($fields as $field) {
        if (!isset($input[$field]) || trim($input[$field]) === '') {
            sendResponse('error', "Missing required field: $field");
        }
    }
}

// --- Check request method ---
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendResponse('error', 'Method not allowed');
}

// --- Parse input ---
$input = json_decode(file_get_contents('php://input'), true);
if (!$input) {
    sendResponse('error', 'Invalid JSON');
}
validateRequired(['email', 'password', 'role'], $input);

$email = $input['email'];
$password = $input['password'];
$role = strtolower($input['role']); // normalize

$roleMap = ['user' => 1, 'vendor' => 2, 'rider' => 3];
$roleId = $roleMap[$role] ?? 1;

try {
    // --- Find user ---
    $stmt = $pdo->prepare("
        SELECT u.user_id, u.name, u.email, u.phone, u.role_id, u.password, r.role_name
        FROM users u
        JOIN roles r ON u.role_id = r.role_id
        WHERE u.email = ? AND u.role_id = ? AND u.status = 'active'
    ");
    $stmt->execute([$email, $roleId]);
    $user = $stmt->fetch();

    if (!$user || !password_verify($password, $user['password'])) {
        sendResponse('error', 'Invalid credentials');
    }

    unset($user['password']);

    // --- Profile data ---
    $stmt = $pdo->prepare("SELECT * FROM user_profiles WHERE user_id = ?");
    $stmt->execute([$user['user_id']]);
    $profile = $stmt->fetch();

    // --- Role-specific data ---
    $roleData = null;
    if ($role === 'vendor') {
        $stmt = $pdo->prepare("SELECT * FROM vendors WHERE user_id = ?");
        $stmt->execute([$user['user_id']]);
        $roleData = $stmt->fetch();
    } elseif ($role === 'rider') {
        $stmt = $pdo->prepare("SELECT * FROM riders WHERE user_id = ?");
        $stmt->execute([$user['user_id']]);
        $roleData = $stmt->fetch();
    }

    // --- Success (match Dart UserModel) ---
    sendResponse('success', 'Login successful', [
        'user' => [
            'id' => $user['user_id'],
            'name' => $user['name'],
            'email' => $user['email'],
            'phone' => $user['phone'],
            'role' => $user['role_name'],
            'created_at' => date('Y-m-d H:i:s')
        ],
        'profile' => [
            'id' => $profile['profile_id'] ?? null,
            'user_id' => $user['user_id'],
            'address' => $profile['address'] ?? null,
            'date_of_birth' => $profile['dob'] ?? null,
            'gender' => $profile['gender'] ?? null,
        ],
        'role_data' => $roleData
    ]);

} catch(PDOException $e) {
    sendResponse('error', 'Login failed: ' . $e->getMessage());
}
