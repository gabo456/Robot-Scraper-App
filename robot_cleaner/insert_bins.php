<?php
header('Content-Type: application/json');

$host = "localhost";
$username = "root";
$password = "";
$dbname = "robot_cleaner_db";

// Connect to database
$conn = new mysqli($host, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    http_response_code(500);
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Only accept POST requests
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get raw POST data
    $postData = json_decode(file_get_contents('php://input'), true);
    
    $bins = $postData['bins_filled'] ?? '';
    $date = $postData['date_collected'] ?? '';

    if (!empty($bins) && !empty($date)) {
        $stmt = $conn->prepare("INSERT INTO bin_data (bins_filled, date_collected) VALUES (?, ?)");
        $stmt->bind_param("is", $bins, $date);

        if ($stmt->execute()) {
            echo json_encode(["message" => "Data inserted successfully"]);
        } else {
            http_response_code(500);
            echo json_encode(["error" => "Insert failed: " . $stmt->error]);
        }

        $stmt->close();
    } else {
        http_response_code(400);
        echo json_encode(["error" => "Missing data fields"]);
    }
} else {
    http_response_code(405);
    echo json_encode(["error" => "Only POST method is allowed"]);
}

$conn->close();
?>