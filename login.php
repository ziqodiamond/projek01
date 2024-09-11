<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include 'config.php';

// Mendapatkan data dari request
$data = json_decode(file_get_contents('php://input'), true);
$email = $data['email'] ?? '';
$password = $data['password'] ?? '';

// Validasi input
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(["error" => "Format email tidak valid."]);
    exit();
}

if (empty($password)) {
    echo json_encode(["error" => "Password wajib diisi"]);
    exit();
}

// Mencari user berdasarkan email
$sql = "SELECT * FROM users WHERE email = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param('s', $email);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();

// Verifikasi password
if ($user && password_verify($password, $user['password'])) {
    // Menghindari pengiriman password kembali ke client
    unset($user['password']);
    echo json_encode([
        "success" => true,
        "message" => "Login berhasil",
        "user" => $user
    ]);
} else {
    echo json_encode(["success" => false, "message" => "Email atau password salah"]);
}

$stmt->close();
$conn->close();
exit(); // Pastikan tidak ada output tambahan
