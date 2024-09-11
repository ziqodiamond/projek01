<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

include 'config.php';

// Mendapatkan data dari request
$name = $_POST['name'] ?? '';
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';

// Validasi input
if (empty($name) || empty($email) || empty($password)) {
    echo json_encode(array("status" => "failed", "error" => "All fields are required."));
    exit();
}

// Cek apakah email sudah terdaftar
$sql_check = "SELECT * FROM users WHERE email = ?";
$stmt_check = $conn->prepare($sql_check);

// Pastikan prepare berhasil
if ($stmt_check === false) {
    echo json_encode(array("status" => "failed", "error" => "Error preparing SQL: " . $conn->error));
    exit();
}

$stmt_check->bind_param("s", $email);
$stmt_check->execute();
$result_check = $stmt_check->get_result();

if ($result_check->num_rows > 0) {
    echo json_encode(array("status" => "failed", "error" => "Email already registered."));
    $stmt_check->close(); // Tutup statement setelah digunakan
    exit();
}
$stmt_check->close(); // Tutup statement setelah pengecekan selesai

// Hash password sebelum disimpan
$hashed_password = password_hash($password, PASSWORD_DEFAULT);

// Insert user ke database dengan prepared statement
$sql = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";
$stmt = $conn->prepare($sql);

// Pastikan prepare berhasil
if ($stmt === false) {
    echo json_encode(array("status" => "failed", "error" => "Error preparing SQL: " . $conn->error));
    exit();
}

$stmt->bind_param("sss", $name, $email, $hashed_password);

if ($stmt->execute()) {
    echo json_encode(array("status" => "success"));
} else {
    echo json_encode(array("status" => "failed", "error" => $conn->error));
}

$stmt->close(); // Tutup statement
$conn->close(); // Tutup koneksi
