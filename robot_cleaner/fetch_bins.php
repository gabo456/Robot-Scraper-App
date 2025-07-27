<?php
include 'db_config.php';

header('Content-Type: application/json');

$result = $conn->query("SELECT bins_filled, date_collected FROM bin_data ORDER BY id DESC");

$data = array();
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
$conn->close();
?>