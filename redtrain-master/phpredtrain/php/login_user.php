<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);

$sqlquantity = "SELECT * FROM TICKET WHERE EMAIL = '$emal'";

$resultq = $conn->query($sqlquantity);
$quantity = 0;
if($resultq->num_rows > 0){
    while ($rowq = $resultq -> fetch_asscoc()){
        $quantity = $rowq["TQUANTITY"] + $quantity;
    }
}

$sql = "SELECT * FROM USER WHERE EMAIL = '$email' AND PASSWORD = '$password'";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo $data = "success,".$row["NAME"].",".$row["EMAIL"].",".$row["PHONE"].",".$row["CREDIT"].",".$row["DATEREG"].",".$quantity;
    }
}else{
    echo "failed";
}