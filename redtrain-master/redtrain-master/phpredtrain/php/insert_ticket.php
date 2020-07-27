<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$trainid = $_POST['trainid'];
$userquantity = $_POST['quantity'];


$sqlsearch = "SELECT * FROM TICKET WHERE EMAIL = '$email' AND TRAINID = '$trainid'";

$result = $conn->query($sqlsearch);
if ($result->num_rows > 0) {
    
    while ($row = $result ->fetch_assoc()){
        $trquantity = $row["TQUANTITY"];
    }
    $trquantity = $trquantity + $userquantity;
    $sqlinsert = "UPDATE TICKET SET TQUANTITY = '$trquantity' WHERE TRAINID = '$trainid' AND EMAIL = '$email'";
}else{
    $sqlinsert = "INSERT INTO TICKET(EMAIL,TRAINID,TQUANTITY) VALUES ('$email','$trainid',$userquantity)";
}

if($conn->query($sqlinsert)==true){
    $sqlquantity = "SELECT * FROM TICKET WHERE EMAIL = '$email'";
    
    $resultq = $conn->query($sqlquantity);
    if($resultq->num_rows >0){
        $quantity = 0;
        while($row = $resultq ->fetch_assoc()){
            $quantity = $row["TQUANTITY"] + $quantity;
        }
    }
    
    $quantity = $quantity;
    echo "success,".$quantity;
}
else{
    echo "failed";
}

?>




?>