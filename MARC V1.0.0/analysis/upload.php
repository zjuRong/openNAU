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
<link rel="stylesheet" href="../bootstrap/css/bootstrap.min.css" >

<!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
<script src="../bootstrap/js/bootstrap.min.js" ></script>

</head>

<body>
<div align="center"  class="panel panel-default" style="width:600px;" >
  <form enctype="multipart/form-data" action="file.php" method="post">
   <!-- 
   <input type="file" name="pic" />
   <div id="img"></div>
   <input type="button" value="uploadimg" onclick="upimg();" /><br />
   -->
  <div class="input-group" style="margin-top:10px;">
  <span class="input-group-addon" id="basic-addon1">Title:</span>
  <input type="text" class="form-control" id="title" name="title"  aria-describedby="basic-addon1">
</div>
  <div class="input-group" style="margin-top:10px;">
  <span class="input-group-addon" id="basic-addon1">Email:</span>
  <input type="text" class="form-control" id="email" name="email"  aria-describedby="basic-addon1">
</div>

     <div class="input-group" style="margin-top:10px;">
  <span id="basic-addon1">Upload file:</span>
   <input type="file" class="input-medium" name="mof" multiple/>
</div>
   <div id="upimg" class="progress" style="display:none">
    <div id="load" class=" progress-bar progress-bar-success"  ></div>
     </div>
<br>
	<input type="button" value="uploadfile" class=" btn btn-large btn-success" onclick="upfile();" />
  
  </form> 



</div>
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
 var title=document.getElementById('title').value;
 var results=document.getElementById("results");
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
       alert('文件发送失败，请重新发送');
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
 
</script>