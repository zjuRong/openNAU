<?php 
//session_start();
include("../config/conn.php");
if($_POST["uidt"]){
$sql="select * from jobs where results='".$_POST["uid"]."'";
$b=mysqli_query($conn,$sql);
$num=mysqli_num_rows($b);

if ($num>0)
{
        //登录成功 
	//$_SESSION["uid"] = $results;
	header("location:main.php?uid=".$_POST["uid"]);
}
else 
{
echo "<script language='javascript'>"; 
echo "alert('Your job ID is not created in database!');";
echo "window.location ='index.php';";
echo "</script>";
    }
	
}else{

$title = htmlspecialchars($_POST["title"]);  
$email = htmlspecialchars($_POST["email"]);  
$polar = htmlspecialchars($_POST["polar"]);  
function getUniName(){
	return md5(uniqid(microtime(true),true));
}

$results=getUniName();

$sql="insert into jobs (title,results,email,polar)values('$title','$results','$email',$polar)";
$a=mysqli_query($conn,$sql);
if ($a)
{
        //登录成功 
	//$_SESSION["uid"] = $results;
	header("location:main.php?uid=".$results);
}
else 
{
echo "<script language='javascript'>"; 
echo "alert('falsed');";
echo "window.location ='index.php';";
echo "</script>";
    }	
	}
?>