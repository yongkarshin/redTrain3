<?php
error_reporting(0);
include_once("dbconnect.php");

$id = $_POST['id'];


if (isset($_POST['id'])){
    $sqldelete = "DELETE FROM TRAIN WHERE ID='$id'";
}
    
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>
