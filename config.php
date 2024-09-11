<?php
$servername = "localhost";
$username = "root";  // Ubah sesuai dengan username MySQL kamu
$password = "";      // Ubah sesuai dengan password MySQL kamu
$dbname = "db_projek01";

// Membuat koneksi
$conn = new mysqli($servername, $username, $password, $dbname);

// Cek koneksi
if ($conn->connect_error) {
    die("Koneksi gagal: " . $conn->connect_error);
}
