<?php
error_reporting(0);
include_once ("dbconnect.php");
$type = $_POST['type'];
$origin = $_POST['origin'];
$destination= $_POST['destination'];


if(isset($type)){
    if($type =="Recent"){
        $sql = "SELECT * FROM TRAIN";
    }else{
        $sql = "SELECT * FROM TRAIN WHERE TYPE = '$type'";
    }
}else{
    $sql = "SELECT * FROM TRAIN";
}

if(isset($destination)&&($origin)){
     $sql = "SELECT * FROM TRAIN WHERE ORIGIN = '$origin' AND DESTINATION = '$destination'";
}


$result = $conn->query($sql);
if ($result->num_rows > 0)
{
     $response["trains"] = array();
    while ($row = $result->fetch_assoc())
    {
        $trainlist = array();
        $trainlist["id"] = $row["ID"];
        $trainlist["platenumber"] = $row["PLATENUMBER"];
        $trainlist["origin"] = $row["ORIGIN"];
        $trainlist["destination"] = $row["DESTINATION"];
        $trainlist["departtime"] = $row["DEPARTTIME"];
        $trainlist["arrivetime"] = $row["ARRIVETIME"];
        $trainlist["type"] = $row["TYPE"];
        $trainlist["price"] = $row["PRICE"];
        $trainlist["quantity"] = $row["QUANTITY"];
        $trainlist["date"] = $row["DATE"];
        $trainlist["sold"] = $row["SOLD"];
        array_push($response["trains"], $trainlist);
    }
    echo json_encode($response);
}
else{
    echo "nodata";
}
?>