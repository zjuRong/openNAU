<?php

include("../config/conn.php");

function getUniName(){
	return md5(uniqid(microtime(true),true));
}

$ff=getUniName();
$file = $_FILES['mof'];

$type = trim(strrchr($_POST['test'], '.'),'.');

$title=$_POST['title'];
$email=$_POST['email'];


$sql = "insert into jobs (title,results,email)values('$title','$ff','$email')";
$result=mysqli_query($conn,$sql);
if($result){
}
else{
	echo 'failed';

	}
	
?>	