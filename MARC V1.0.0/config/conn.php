<?php
include("config.php");

$conn=new mysqli($host,$user,$pass,$database);
//mysql_query("set names 'utf8'");//这就是指定数据库字符集，一般放在连接数据库后面就系了 
mysqli_query($conn,"set names utf8");
if(!$conn)
 {
  die('数据库连接失败：'.mysql_error());
 }else{
	 
	//echo "success！"; 
	 }
//mysql_select_db($database);
?>