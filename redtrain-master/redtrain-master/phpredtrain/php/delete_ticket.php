<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$trainid = $_POST['trainid'];

if(isset($trainid)){
    $sqldelete = "DELETE FROM TICKET WHERE EMAIL = '$email' AND TRAINID='$trainid'";
}else{
    $sqldelete = "DELETE FROM TICKET WHERE EMAIL = '$email'";
}
     
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>