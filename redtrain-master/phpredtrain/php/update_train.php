<?php
error_reporting(0);
include_once("dbconnect.php");

$id = $_POST['id'];
$platenumber = $_POST['platenumber'];
$origin = $_POST['origin'];
$destination = $_POST['destination'];
$departtime = $_POST['departtime'];
$arrivetime = $_POST['arrivetime'];
$type = $_POST['type'];
$price = $_POST['price'];
$quantity = $_POST['quantity'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../trainimage/'.$type.'jpg';

$sqlupdate = "UPDATE TRAIN SET PLATENUMBER = '$platenumber' , ORIGIN = '$origin' , DESTINATION = '$destination' , DEPARTTIME = '$departtime' , ARRIVETIME = '$arrivetime' , TYPE = '$type' , PRICE= '$price' , QUANTITY = '$quantity' WHERE ID = '$id'";

//file_put_contents($path, $decoded_string);
//echo $encoded_string;

if ($conn->query($sqlupdate) === true)
{
    if(isset($encode_string)){
        file_put_contents($path,$decode_string);
    }
    echo 'success';
}
else
{
    echo "failed";
}
    
$conn->close();
?>