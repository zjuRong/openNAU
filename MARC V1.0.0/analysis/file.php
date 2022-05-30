<?php 
/****
 waited
****/
//print_r($_FILES);exit;
//session_start();

$file = $_FILES['mof'];

$type = trim(strrchr($_POST['test'], '.'),'.');
$uid=$_POST['uid'];
$res="../data/raw_web/".$uid;
mkdir($res,0777,true);
chmod ($res, 0777);
$res=$res."/upload.";
$res=$res.$type;

// print_r($_POST['test']);exit;

if($file['error']==0){
 if(!file_exists($res)){

  if(!move_uploaded_file($file['tmp_name'],$res)){
   echo 'failed';
  }else{
  echo "1";
  }
 }else{
  $content=file_get_contents($file['tmp_name']);
  if (!file_put_contents($res, $content,FILE_APPEND)) {
   echo 'failed';
  }else{
  echo "1";
  }
 }
}else{
 echo 'failed';
}

?>