<?php
error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);
$verify= $_POST['verify'];

$sqlinsert = "INSERT INTO USER(NAME,EMAIL,PASSWORD,PHONE,CREDIT,VERIFY) VALUES ('$name','$email','$password','$phone','0','$verify')";

if ($conn->query($sqlinsert) === true)
{
    sendEmail($email);
    echo "success";
}
else
{
    echo "failed";
}

function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for redTrain'; 
    $message = 'http://smileylion.com/redtrain/php/verify.php?email='.$useremail;
    $headers = 'From: noreply@redtrain.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers);
    
}

?>