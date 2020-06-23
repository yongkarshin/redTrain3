<?php
$servername = "localhost";
$username   = "smileyli_redTrain";
$password   = "Smileylion@@@1111";
$dbname     = "smileyli_redTrain";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>