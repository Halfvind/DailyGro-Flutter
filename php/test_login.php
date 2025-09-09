<?php
require_once 'config.php';

// Test database connection
try {
    $stmt = $pdo->query("SELECT COUNT(*) as count FROM users");
    $result = $stmt->fetch();
    echo "Database connected. Users count: " . $result['count'] . "\n";
    
    // Check if test user exists
    $stmt = $pdo->prepare("SELECT * FROM users WHERE email = 'user@dailygro.com'");
    $stmt->execute();
    $user = $stmt->fetch();
    
    if ($user) {
        echo "User found: " . json_encode($user) . "\n";
        
        // Test password
        if (password_verify('123456', $user['password'])) {
            echo "Password matches\n";
        } else {
            echo "Password does not match\n";
            // Create new password hash
            $newHash = password_hash('123456', PASSWORD_DEFAULT);
            echo "New hash: " . $newHash . "\n";
            
            // Update password
            $stmt = $pdo->prepare("UPDATE users SET password = ? WHERE email = 'user@dailygro.com'");
            $stmt->execute([$newHash]);
            echo "Password updated\n";
        }
    } else {
        echo "User not found. Creating test user...\n";
        
        // Create test user
        $hashedPassword = password_hash('123456', PASSWORD_DEFAULT);
        $stmt = $pdo->prepare("INSERT INTO users (name, email, password, phone, role_id) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute(['Test User', 'user@dailygro.com', $hashedPassword, '1234567890', 1]);
        
        $userId = $pdo->lastInsertId();
        
        // Create profile
        $stmt = $pdo->prepare("INSERT INTO user_profiles (user_id, address) VALUES (?, ?)");
        $stmt->execute([$userId, 'Test Address']);
        
        echo "Test user created with ID: " . $userId . "\n";
    }
    
} catch(PDOException $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>