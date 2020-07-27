<?php
error_reporting(0);
include_once ("dbconnect.php");
$id = $_POST['id'];
$platenumber = $_POST['platenumber'];
$origin = $_POST['origin'];
$destination = $_POST['destination'];
$departtime = $_POST['departtime'];
$arrivetime = $_POST['arrivetime'];
$type = $_POST['type'];
$price  = $_POST['price'];
$quantity = $_POST['quantity'];
$sold = '0';
$orilatitude='0';
$orilongitude='0';
$destlatitude='0';
$destlongitude='0';


$sqlinsert = "INSERT INTO TRAIN(ID,PLATENUMBER,ORIGIN,DESTINATION,DEPARTTIME,ARRIVETIME,TYPE,PRICE,QUANTITY,SOLD,ORILATITUDE,ORILONGITUDE,DESTLATITUDE,DESTLONGITUDE) VALUES ('$id','$platenumber','$origin','$destination','$departtime','$arrivetime','$type','$price','$quantity','$sold','$orilatitude','$orilongitude','$destlatitude','$destlongitude')";
$sqlsearch = "SELECT * FROM TRAIN WHERE ID='$id'";
$resultsearch = $conn->query($sqlsearch);

if ($resultsearch->num_rows > 0)
{
    echo 'found';
}else{
if ($conn->query($sqlinsert) === true)
{
    echo "success";
}
else
{
    echo "failed";
}    
}


?>