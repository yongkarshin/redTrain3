<?php
error_reporting(0);
include_once("dbconnect.php");
$problem = $_POST['problem'];

if (isset($problem)){
    
    $sqlupdatestatus = "UPDATE REPORT SET STATUS = 'Complete' WHERE PROBLEM = '$problem'";
    if ($conn->query($sqlupdatestatus)){
        echo 'success';    
    }else{
        echo 'success';
    }
    
}



$conn->close();
?>