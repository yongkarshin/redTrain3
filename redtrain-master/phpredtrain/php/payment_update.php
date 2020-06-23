<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_GET['userid'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];
$orderid = $_GET['orderid'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
 
$signed= hash_hmac('sha256', $signing, 'S-w-_S1Kh3TCgguDz2i_NE6w');
if ($signed === $data['x_signature']) {

    if ($paidstatus == "Success"){
        
        $sqlcart = "SELECT TRAINID,TQUANTITY FROM TICKET WHERE EMAIL = '$userid'";
        $cartresult = $conn->query($sqlcart);
        if ($cartresult->num_rows > 0)
        {
        while ($row = $cartresult->fetch_assoc())
        {
            $trainid = $row["TRAINID"];
            $tq = $row["TQUANTITY"];
            $sqlinserttickethistory = "INSERT INTO TICKETHISTORY(EMAIL,ORDERID,BILLID,TRAINID,TQUANTITY) VALUES ('$userid','$orderid','$receiptid','$trainid','$tq')";
            $conn->query($sqlinserttickethistory);
            
            $selecttrain = "SELECT * FROM TRAIN WHERE ID = '$trainid'";
            $trainresult = $conn->query($selecttrain);
             if ($trainresult->num_rows > 0){
                  while ($rowt = $trainresult->fetch_assoc()){
                    $trquantity = $rowt["QUANTITY"];
                    $prevsold = $rowt["SOLD"];
                    $newquantity = $trquantity - $tq;
                    $newsold = $prevsold + $tq;
                    $sqlupdatequantity = "UPDATE TRAIN SET QUANTITY = '$newquantity', SOLD = '$newsold' WHERE ID = '$trainid'";
                    $conn->query($sqlupdatequantity);
                  }
             }
        }
        
       $sqldeletecart = "DELETE FROM TICKET WHERE EMAIL = '$userid'";
       $sqlinsert = "INSERT INTO PAYMENT(ORDERID,BILLID,USERID,TOTAL) VALUES ('$orderid','$receiptid','$userid','$amount')";
       
       $conn->query($sqldeletecart);
       $conn->query($sqlinsert);
    }
        echo '<br><br><body><div><h2><br><br><center>Receipt</center></h1><table border=1 width=80% align=center><tr><td>Order id</td><td>'.$orderid.'</td></tr><tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td><td>'.$userid. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr><tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr><tr><td>Date </td><td>'.date("d/m/Y").'</td></tr><tr><td>Time </td><td>'.date("h:i a").'</td></tr></table><br><p><center>Press back button to return to redTrain</center></p></div></body>';
        //echo $sqlinsertcarthistory;
    } 
        else 
    {
    echo 'Payment Failed! Please try again.';
    }
}

?>