<?php
error_reporting(0);
include_once ("dbconnect.php");
$orderid = $_POST['orderid'];

$sql = "SELECT TRAIN.ID, TRAIN.PLATENUMBER, TRAIN.ORIGIN, TRAIN.DESTINATION, TRAIN.DEPARTTIME, TRAIN.ARRIVETIME, TRAIN.TYPE, TRAIN.QUANTITY, TICKETHISTORY.PRICE, TICKETHISTORY.TQUANTITY FROM TRAIN INNER JOIN TICKETHISTORY ON TICKETHISTORY.TRAINID = TRAIN.ID WHERE TICKETHISTORY.ORDERID = '$orderid'";


$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["tickethistory"] = array();
    while ($row = $result->fetch_assoc())
    {
        $ticketlist=array();
        $ticketlist['id']=$row["ID"];
        $ticketlist['platenumber']=$row["PLATENUMBER"];
        $ticketlist['origin']=$row["ORIGIN"];
        $ticketlist['destination']=$row["DESTINATION"];
        $ticketlist['departtime']=$row["DEPARTTIME"];
        $ticketlist['arrivetime']=$row["ARRIVETIME"];
        $ticketlist['type']=$row["TYPE"];
        $ticketlist['quantity']=$row["QUANTITY"];
        $ticketlist['price']=$row["PRICE"];
        $ticketlist['tquantity']=$row["TQUANTITY"];
        
        array_push($response["tickethistory"], $ticketlist);
    }
    echo json_encode($response);
}
else{
    echo "nodata";
}

?>