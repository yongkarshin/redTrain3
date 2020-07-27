<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_POST['userid'];
$amount = $_POST['amount'];
$orderid = $_POST['orderid'];
$newcr = $_POST['newcr'];
$receiptid ="storecr";

 $sqlcart ="SELECT TICKET.TRAINID, TICKET.TQUANTITY, TRAIN.PRICE FROM TICKET INNER JOIN TRAIN ON TICKET.TRAINID = TRAIN.ID WHERE TICKET.EMAIL = '$userid'";
        $cartresult = $conn->query($sqlcart);
        if ($cartresult->num_rows > 0)
        {
        while ($row = $cartresult->fetch_assoc())
        {
            $trainid = $row["trainid"];
            $tq = $row["TQUANTITY"]; //cart qty
            $pr = $row["PRICE"];
            $sqlinsertcarthistory = "INSERT INTO TICKETHISTORY(EMAIL,ORDERID,BILLID,TRAINID,TQUANTITY,PRICE) VALUES ('$userid','$orderid','$receiptid','$trainid','$tq','$pr')";
            $conn->query($sqlinsertcarthistory);
            
            $selectproduct = "SELECT * FROM TRAIN WHERE ID = '$trainid'";
            $productresult = $conn->query($selectproduct);
             if ($productresult->num_rows > 0){
                  while ($rowp = $productresult->fetch_assoc()){
                    $prquantity = $rowp["QUANTITY"];
                    $prevsold = $rowp["SOLD"];
                    $newquantity = $prquantity - $tq; //quantity in store - quantity ordered by user
                    $newsold = $prevsold + $tq;
                    $sqlupdatequantity = "UPDATE TRAIN SET QUANTITY = '$newquantity', SOLD = '$newsold' WHERE ID = '$trainid'";
                    $conn->query($sqlupdatequantity);
                  }
             }
        }
        
       $sqldeletecart = "DELETE FROM TICKET WHERE EMAIL = '$userid'";
       $sqlinsert = "INSERT INTO PAYMENT(ORDERID,BILLID,USERID,TOTAL) VALUES ('$orderid','$receiptid','$userid','$amount')";
        $sqlupdatecredit = "UPDATE USER SET CREDIT = '$newcr' WHERE EMAIL = '$userid'";
        
       $conn->query($sqldeletecart);
       $conn->query($sqlinsert);
       $conn->query($sqlupdatecredit);
       echo "success";
        }else{
            echo "failed";
        }

?>