<?php
include 'db_config.php';

$email = $_POST['email'];
$password = $_POST['password'];

$stmt = $conn->prepare("SELECT password FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows == 1) {
    $stmt->bind_result($hashed);
    $stmt->fetch();

    if (password_verify($password, $hashed)) {
        echo "success";
    } else {
        echo "Incorrect password";
    }
} else {
    echo "User not found";
}
?>
