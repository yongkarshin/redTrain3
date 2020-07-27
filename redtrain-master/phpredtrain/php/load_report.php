<?php
error_reporting(0);
include_once ("dbconnect.php");

$sql = "SELECT * FROM REPORT";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["report"] = array();
    while ($row = $result->fetch_assoc())
    {
        $ticketlist = array();
        $ticketlist["email"] = $row["EMAIL"];
        $ticketlist["phone"] = $row["PHONE"];
        $ticketlist["problem"] = $row["PROBLEM"];
        $ticketlist["status"] = $row["STATUS"];
        array_push($response["report"], $ticketlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>