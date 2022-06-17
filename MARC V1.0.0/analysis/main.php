<?php
include("../config/conn.php");
/*session_start();
if(!$_SESSION['uid']){
	exit("Please create a job firstly!");
	}*/
$uid=$_GET['uid'];	
if(!$uid){
	exit("Please create a job firstly!");
	}
?>

<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Metabolism Analysis and  Resources Central</title>
<!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
 <script src="../bootstrap/js/jquery.min.js"></script>
<!-- 可选的 Bootstrap 主题文件（一般不用引入） -->
<link rel="stylesheet" href="../bootstrap/css/bootstrap-theme.min.css">
<link rel="stylesheet" href="../bootstrap/css/bootstrap-responsive.css" >
<link rel="stylesheet" href="../bootstrap/css/bootstrap.css" >

<!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
<script src="../bootstrap/js/bootstrap.min.js" ></script>
  <style type="text/css">
      body {
        padding-top: 20px;
        padding-bottom: 60px;
      }

      /* Custom container */
      .container {
        margin: 0 auto;
        max-width: 1000px;
      }
      .container > hr {
        margin: 60px 0;
      }

      /* Main marketing message and sign up button */
      .jumbotron {
        margin: 80px 0;
        text-align: center;
      }
      .jumbotron h1 {
        font-size: 100px;
        line-height: 1;
      }
      .jumbotron .lead {
        font-size: 24px;
        line-height: 1.25;
      }
      .jumbotron .btn {
        font-size: 21px;
        padding: 14px 24px;
      }

      /* Supporting marketing content */
      .marketing {
        margin: 60px 0;
      }
      .marketing p + h4 {
        margin-top: 28px;
      }


      /* Customize the navbar links to be fill the entire space of the .navbar */
      .navbar .navbar-inner {
        padding: 0;
      }
      .navbar .nav {
        margin: 0;
        display: table;
        width: 100%;
      }
      .navbar .nav li {
        display: table-cell;
        width: 1%;
        float: none;
      }
      .navbar .nav li a {
        font-weight: bold;
        text-align: center;
        border-left: 1px solid rgba(255,255,255,.75);
        border-right: 1px solid rgba(0,0,0,.1);
      }
      .navbar .nav li:first-child a {
        border-left: 0;
        border-radius: 3px 0 0 3px;
      }
      .navbar .nav li:last-child a {
        border-right: 0;
        border-radius: 0 3px 3px 0;
      }
    </style>
</head>

<body>
<div class="container">

      <div class="masthead">
        <h3 class="muted">MARC</h3>
        <div class="navbar">
          <div class="navbar-inner">
            <div class="container">
              <ul class="nav">
                <li ><a href="../index.php">Home</a></li>
                <li class="active"><a href="">Analysis</a></li>
                <li><a href="../search.php">Search</a></li>
                <li><a href="../download.php">Downloads</a></li>
                <li><a href="../about.php">About</a></li>
                <li><a href="../help.php">FAQ</a></li>
              </ul>
            </div>
          </div>
        </div><!-- /.navbar -->
      </div>
<div   class=" panel panel-default" style="border:#999 solid 1px; text-indent:10px;" >
<div align="left" >
<?php 
$sql="select * from jobs where results='".$uid."'";
$b=mysqli_query($conn,$sql);
$dd=mysqli_fetch_row($b);

?>
<p><strong>Job name:</strong> <?php echo $dd[1];?> </p>
<p><strong>Job ID (You should copy annd save this ID to your local PC for visiting this project again.):</strong>
<span style="color:#F00;"> <?php echo $dd[2];?></span> </p>
<p><strong>E-mail:</strong> <?php echo $dd[3];?> </p>
<p><strong>Created time:</strong> <?php echo $dd[5];?> </p>
</div>
<?php 
$file = "../data/raw_web/".$uid."/upload.zip";

if(file_exists($file))
{
?>
<P style="color:#0F3;">The data for this job has been uploaded!</P>
<?php
}
else
{?>
  <form enctype="multipart/form-data" action="file.php" method="post">


     <div class="input-group" style="margin-top:10px;">
     <p>Upload file:</p>
   <input type="file" class="input-medium" name="mof" multiple/>
</div>
   <div id="upimg" class="progress" style="display:none">
    <div id="load" class=" progress-bar progress-bar-success"  ></div>
     </div>
<br>
	<input type="button" value="uploadfile" class=" btn btn-large btn-success" onclick="upfile();" />
  
  </form> 
<?php
}?>

<?php
$dir = "../data/raw_web/".$uid;

if(is_dir($dir))
{?>
<p style="color:#0F0;">This job has been created!</p>
<?php
}
?>
</div>



<div   class="panel panel-default" style="border:#999 solid 1px; text-indent:10px; margin-top:20px;">
<p>Data analysis</p>
<input type="button" value="Normalization 1" onClick="showMG('norm')" class=" btn btn-large btn-info"  />
<input type="button" value="Normalization 2" onClick="showMG('norm1')" class=" btn btn-large btn-info"  /> 
<input type="button" value="Zscore" onClick="showMG('p1')" class=" btn btn-large btn-info"  />
<input type="button" value="SVA" onClick="showMG('p2')" class=" btn btn-large btn-info"  />
<input type="button" value="LOESS" onClick="showMG('p3')" class=" btn btn-large btn-info"  />
<input type="button" value="Spoly3" onClick="showMG('p4')" class=" btn btn-large btn-info"  />
<input type="button" value="Spoly4" onClick="showMG('p5')" class=" btn btn-large btn-info"  />
<div id="loading" align="center" style="display:none"><img src="../imges/loading.gif" width="400" height="300" /></div>
</div>

<div  class="panel panel-default" style="border:#999 solid 1px; text-indent:10px; margin-top:20px;">
<p>Analysis report:</p>
<div class="panel panel-default">
<?php
$file = "../data/raw_web/".$uid."/normalize.html";
if(file_exists($file))
{?>
<a target="new" id="norm" class=" btn btn-large btn-warning" href="../data/raw_web/<?php echo $uid;?>/normalize.html"  style="display:inline-block; width:200px;">Normalization 1</a>
<?php
}
else
{?>
   <a target="new" id="norm" class=" btn btn-large btn-warning" href="../data/raw_web/<?php echo $uid;?>/normalize.html"  style="display:none; width:200px;">Normalization 1</a>
 <?php }?>
<?php
$file = "../data/raw_web/".$uid."/normalize_1.html";
if(file_exists($file))
{?>
<a target="new" id="norm1" class=" btn btn-large btn-warning" href="../data/raw_web/<?php echo $uid;?>/normalize_1.html"  style="display:inline-block; width:200px;">Normalization 2</a>

<?php
}
else
{?>
   <a target="new" id="norm1" class=" btn btn-large btn-success" href="../data/raw_web/<?php echo $uid;?>/normalize_1.html"  style="display:none; width:200px;">Normalization 2</a>
 <?php }?> 
 </div>
 <hr>
<?php
$file = "../data/raw_web/".$uid."/process_1.html";
if(file_exists($file))
{?>
<a target="new" id="p1" class=" btn btn-large btn-success" href="../data/raw_web/<?php echo $uid;?>/process_1.html" style="display:inline-block; width:200px;" >Analysis results based on Z score</a>
<hr>
<?php
}
else
{?>
<a target="new" id="p1" class=" btn btn-large btn-success" href="../data/raw_web/<?php echo $uid;?>/process_1.html" style="display:none; width:200px;" >Analysis results based on Z score</a>
 <?php }?>

 <?php
$file = "../data/raw_web/".$uid."/process_2.html";
if(file_exists($file))
{?>
<a target="new" id="p2" class=" btn btn-large btn-success" href="../data/raw_web/<?php echo $uid;?>/process_2.html" style="display:inline-block; width:200px;" >Analysis results based on SVA</a>
<hr>
<?php
}
else
{?>
<a target="new" id="p2" class=" btn btn-large btn-success" href="../data/raw_web/<?php echo $uid;?>/process_2.html" style="display:none; width:200px;" >Analysis results based on SVA</a>

 <?php }?> 
<?php
$file = "../data/raw_web/".$uid."/process_3.html";
if(file_exists($file))
{?>
<a target="new" id="p3" class=" btn btn-large btn-success" href="../data/raw_web/<?php echo $uid;?>/process_3.html" style="display:inline-block; width:200px;" >Analysis results based on LOESS</a>
<hr>
<?php
}
else
{?>
<a target="new" id="p3" class=" btn btn-large btn-success" href="../data/raw_web/<?php echo $uid;?>/process_3.html" style="display:none; width:200px;" >Analysis results based on LOESS</a>
 <?php }?>

<?php
$file = "../data/raw_web/".$uid."/process_4.html";
if(file_exists($file))
{?>
<a target="new" id="p4" class=" btn btn-large btn-success" href="../data/raw_web/<?php echo $uid;?>/process_3.html" style="display:inline-block; width:200px;" >Analysis results based on Spoly3</a>
<hr>
<?php
}
else
{?>
<a target="new" id="p4" class=" btn btn-large btn-success" href="../data/raw_web/<?php echo $uid;?>/process_3.html" style="display:none; width:200px;" >Analysis results based on Spoly3</a>
 <?php }?>
 <?php
$file = "../data/raw_web/".$uid."/process_5.html";
if(file_exists($file))
{?>
<a target="new" id="p5" class=" btn btn-large btn-success" href="../data/raw_web/<?php echo $uid;?>/process_3.html" style="display:inline-block; width:200px;" >Analysis results based on Spoly4</a>
<hr>
<?php
}
else
{?>
<a target="new" id="p5" class=" btn btn-large btn-success" href="../data/raw_web/<?php echo $uid;?>/process_3.html" style="display:none; width:200px;" >Analysis results based on Spoly4</a>
 <?php }?>
</div>




</body>
</html>
<script language="javascript" type="text/javascript">
var dom=document.getElementsByTagName('form')[0];
 dom.onsubmit=function(){
  //return false;
 }
 var xhr=new XMLHttpRequest();
 var fd;
 var des=document.getElementById('load');
 var num=document.getElementById('upimg');
 var uid='<?php echo $uid;?>';
 var file;
 const LENGTH=10*1024*1024;
 var start;
 var end;
 var blob;
 var pecent;
 var filename;
 //var pending;
 //var clock;
 function upfile(){
  start=0;
  end=LENGTH+start;
  //pending=false;

  file=document.getElementsByName('mof')[0].files[0];
  //filename = file.name;
  if(!file){
   alert('请选择文件');
   return;
  }
  //clock=setInterval('up()',1000);
  up();

 }

 function up(){
  /*
  if(pending){
   return;
  }
  */
  if(start<file.size){
   xhr.open('POST','file.php',true);
   //xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
   xhr.onreadystatechange=function(){
    if(this.readyState==4){
     if(this.status>=200&&this.status<300){
      if(this.responseText.indexOf('failed') >= 0){
       //alert(this.responseText);
       alert('Failed to send file, please resend it');
       des.style.width='0%';
	   num.style.display="none";
       //num.innerHTML='';
       //clearInterval(clock);
      }else{
       //alert(this.responseText)
       // pending=false;
       start=end;
       end=start+LENGTH;
       setTimeout('up()',1000);
	   num.style.display="block";
	   
      }

     }
    }
   }
   xhr.upload.onprogress=function(ev){
    if(ev.lengthComputable){
     pecent=100*(ev.loaded+start)/file.size;
     if(pecent>100){
      pecent=100;
     }
     //num.innerHTML=parseInt(pecent)+'%';
	 
     des.style.width=pecent+'%';
     des.innerHTML = parseInt(pecent)+'%'
    }
   }
　　　　　　　
　　　　　　　//分割文件核心部分slice
   blob=file.slice(start,end);
   fd=new FormData();
   fd.append('mof',blob);
   fd.append('test',file.name);
   fd.append('uid',uid);
   //console.log(fd);
   //pending=true;
   xhr.send(fd);
  }else{
   //clearInterval(clock);
  }
 }

 function change(){
  des.style.width='0%';
 }
 
 
 function ajaxFunction(url,p)
   {
    var xmlHttp;
    try
    {
  // Firefox, Opera 8.0+, Safari
  xmlHttp = new XMLHttpRequest();    // 实例化对象
    }
    catch( e )
    {
     // Internet Explorer
     try
     {
      xmlHttp = new ActiveXObject( "Msxml2.XMLHTTP" );
     }
     catch ( e )
     {
      try
      {
       xmlHttp = new ActiveXObject( "Microsoft.XMLHTTP" );
      }
      catch( e )
      {
       alert("Your browser does not support Ajax!");
       return false;
      }
     }
    }
    xmlHttp.onreadystatechange = function()
    {
		if(xmlHttp.readyState == 4){
     if(xmlHttp.status >= 200 && xmlHttp.status < 300)
     {
		 
	   var gene=xmlHttp.responseText;
	   
	   gg=gene.toString();
	   gg=''+gg;
	   if(gg==1){
		document.getElementById('loading').style.display='none';
		 document.getElementById(''+p).style.display="block";
	  // document.getElementById('norm').style.display="block";
	   }
		if(gg==0){
			alert("The analysis process has terminated,please check your uploaded data");
			document.getElementById('loading').style.display='none';
			
			
			}
	   /*switch(gene){
		   case 'Yes':
			document.getElementById('loading').style.display='none';
			//document.getElementById(p).style.display="block";
			break;
			case 'No':
			document.getElementById('loading').style.display='none';
			alert("The analysis process has terminated,please check your uploaded data");
			break;
			
	   }*/
	  
	 // e4b880e7b292e6b299e7a791e68a80e78988e69d83e68980e69c89
	 }
        }
    }
    xmlHttp.open( "GET", url, true );
    xmlHttp.send( null );
	

   }
 
   
    function showMG(p){
	 //window.location.reload();
	 p=p.toString();
	 document.getElementById('loading').style.display='block';
	 var gen='<?php echo $uid;?>';
	 var str="uid="+gen+"&p="+p;
	 ajaxFunction("client.php?"+str,p);
	 
	}
 
 
</script>