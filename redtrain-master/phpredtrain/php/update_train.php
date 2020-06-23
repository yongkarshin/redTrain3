<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$trainid = $_POST['trainid'];
$quantity = $_POST['quantity'];

$sqlupdate = "UPDATE TICKET SET CQUANTITY = '$quantity' WHERE EMAIL = '$email' AND TRAINID = '$trainid'";

if ($conn->query($sqlupdate) === true)
{
    echo "success";
}
else
{
    echo "failed";
}
    
$conn->close();
?>