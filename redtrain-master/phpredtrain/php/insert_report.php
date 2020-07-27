<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$phone = $_POST['phone'];
$problem = $_POST['problem'];
$status="incomplete";

$sqlinsert = "INSERT INTO REPORT(EMAIL,PHONE,PROBLEM,STATUS) VALUES ('$email'  ,'$phone','$problem','$status')";

if($conn->query($sqlinsert) == true){
    echo "success";
}else{
    echo "failed";
}

 
?>