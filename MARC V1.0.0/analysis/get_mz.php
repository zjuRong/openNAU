<?php
include("../config/conn.php");
$mz=$_POST['mz'];
$thres=$_POST['thres'];
$min=$mz-$thres/1000000;
$max=$mz+$thres/1000000;
$sql="select * from ref_meta_data where mass<=".$max." and mass>=".$min;
$res=mysqli_query($conn,$sql);
$i=1;

?>


<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Metabolism Analysis and  Resources Central</title>
<!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
     <script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
<!-- Bootstrap core CSS -->

<link href="../bootstrap/css/bootstrap.css" rel="stylesheet">
<!-- 可选的 Bootstrap 主题文件（一般不用引入） -->
<link rel="stylesheet" href="../bootstrap/css/bootstrap-theme.min.css">
<link rel="stylesheet" href="../bootstrap/css/bootstrap-responsive.css" >
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
	  .tt{display:none; width:100%}
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
                <li><a href="../index.php">Home</a></li>
                <li><a href="../analysis.php">Analysis</a></li>
                <li class="active"><a href="search.php">Search</a></li>
                <li><a href="../download.php">Downloads</a></li>
                <li ><a href="../about.php">About</a></li>
                <li><a href="../help.php">FAQ</a></li>
              </ul>
            </div>
          </div>
        </div><!-- /.navbar -->
      </div>
       <!-- Jumbotron -->
<div style="width:100%">
<P><strong>Mass:</strong> <?php echo $mz;?>, <strong>Mass error:</strong> <?php echo $thres;?>ppm</P>
<table border="0" cellpadding="0" cellspacing="10" width="100%"  class="table table-hover table-striped tablesorter">
<tr align="center">
<th>#ID</th>
<th>MID</th>
<th>CID</th>
<th>Source</th>
<th>Mass</th>
<th>HMDB/KEGG</th>
<th>Link</th>
</tr>
<?php
$file=md5(uniqid(microtime(true),true));
$file="results/".$file.".txt";
$fp = fopen ( $file, 'a' );
$header="ID,MID,CID,Source,Mass,Link,HMDB/KEGG\r\n";
fwrite($fp,$header);
while($row=mysqli_fetch_row($res))
      {
      $ss=$row;
	  array_pop($ss);
	  array_shift($ss);
	  $dat=implode(",",$ss);
	  $dat=$i.",".$dat."\r\n";
	  fwrite($fp,$dat);
	  ?>
   <tr id="ref_<?php echo $i;?>" >
   <td><?php echo $i;?></td>
  		  <td><?php echo $row[1];?></td>
          <td><?php echo $row[2];?></td>
          <td><?php echo $row[3];?></td>
          <td><?php echo $row[4];?></td>
          <td><?php echo $row[6];?></td>
		  <td><a href="<?php echo $row[5];?>" target="_blank">Detail</a></td>
    </tr> 
  <?php
$i=$i+1;
	}
	fclose($fp);
	?>

</table>
</div>
 <div id="show">
<hr>
Total number: <?php echo $i-1;?>. 

<a class="btn btn-link" href="<?php echo $file;?>">Dowmload</a>
</div>


<hr>
<div class="page-header">
        <h2>Data resouce links</h2>
         <hr>
<a class="btn btn-link" href="http://allccs.zhulab.cn/">AIICCS</a>
<a class="btn btn-link" href="https://www.ebi.ac.uk/chebi/">ChEBI</a>
<a class="btn btn-link" href="https://hmdb.ca/">HMDB</a>
<a class="btn btn-link" href="https://www.kegg.jp/kegg/compound/">KEGG</a>
<a class="btn btn-link" href="https://pubchem.ncbi.nlm.nih.gov/">MassBank</a>
<a class="btn btn-link" href="https://www.npatlas.org/">NPAtlas</a>
<a class="btn btn-link" href="https://pathbank.org/">PathBank</a>

      </div>
      <div class="footer">


        <p>© Lai lab 2019</p>
      </div>

    </div>
</div>
</body>
</html>