<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
   $sql = "SELECT TRAIN.ID, TRAIN.PLATENUMBER, TRAIN.ORIGIN, TRAIN.DESTINATION, TRAIN.DEPARTTIME, TRAIN.ARRIVETIME, TRAIN.TYPE, TRAIN.PRICE, TRAIN.QUANTITY, TICKET.TQUANTITY FROM TRAIN INNER JOIN TICKET ON TICKET.TRAINID=TRAIN.ID WHERE TICKET.EMAIL = '$email'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["ticket"] = array();
    while ($row = $result->fetch_assoc())
    {
        $ticketlist = array();
        $ticketlist["id"] = $row["ID"];
        $ticketlist["platenumber"] = $row["PLATENUMBER"];
        $ticketlist["origin"] = $row["ORIGIN"];
        $ticketlist["destination"] = $row["DESTINATION"];
        $ticketlist["departtime"] = $row["DEPARTTIME"];
        $ticketlist["arrivetime"] = $row["ARRIVETIME"];
        $ticketlist["type"] = $row["TYPE"];
        $ticketlist["price"] = $row["PRICE"];
        $ticketlist["quantity"] = $row["QUANTITY"];
        $ticketlist["tquantity"] = $row["TQUANTITY"];
        $ticketlist["yourprice"] = round(doubleval($row["PRICE"])*(doubleval($row["TQUANTITY"])),2)."";
        
        array_push($response["ticket"], $ticketlist);
    }
    echo json_encode($response);
}
else
{
    echo "Ticket Empty";
}
?>