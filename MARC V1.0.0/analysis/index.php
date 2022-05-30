<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Bioinformatics Analysis Lab</title>
<!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
    <script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
<!-- Bootstrap core CSS -->

<link href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css" rel="stylesheet">


  <!-- Optional Bootstrap Theme -->

  <link href="data:text/css;charset=utf-8," data-href="https://v3.bootcss.com//dist/css/bootstrap-theme.min.css" rel="stylesheet" id="bs-theme-stylesheet">
<link rel="stylesheet" href="../bootstrap/css/bootstrap-responsive.css" >
 
 <script language="javascript" type="text/javascript">

function change(){
	 $("#jobs").toggle(
 
 )
 	 $("#create").toggle(
 
 )
	}
 
 </script>
</head>

<body>
<div class="container">

      <div class="masthead">
        <h3 class="muted">MARC</h3>
      <!--  <div class="navbar">
          <div class="navbar-inner">
            <div class="container">
              <ul class="nav">
                <li ><a href="index.php">Home</a></li>
                <li class="active"><a href="analysis.php">Analysis</a></li>
                <li><a href="search.php">Search</a></li>
                <li><a href="download.php">Downloads</a></li>
                <li><a href="about.php">About</a></li>
                <li><a href="help.php">FAQ</a></li>
              </ul>
            </div>
          </div>
        </div><!-- /.navbar -->
      </div>

<div id="model_index" class="container">
<form id="form" name="form" method="post" action="login.php" enctype="multipart/form-data">
<hr>
<div style="height:50px;"><input name="uidt" type="checkbox" value="TRUE" onChange="change()" /> I have a job ID.</div>
<div id="create" style="display:block">
<div class="input-group input-group-lg">
  <span class="input-group-addon" id="sizing-addon1">Title </span>
  <input type="text" class="form-control"  name="title"  placeholder="job name" aria-describedby="sizing-addon1">
</div>
<div style="height:50px;"></div>
<div class="input-group input-group-lg">
  <span class="input-group-addon" id="sizing-addon1">Email</span>
  <input type="text" class="form-control"  name="email"  placeholder="email" aria-describedby="sizing-addon1">
</div>
<div style="height:50px;"></div>
<div class="input-group input-group-lg" >
  <span class="input-group-addon" id="basic-addon1">Polarity</span>
  <select type="text" name="polar" class="form-control" aria-describedby="basic-addon1">
  <option value="0" selected="selected">--select--</option>
  <option value="1" >Positive</option>
  <option value="2" >Negative</option>
  </select>
  </div>
  </div>
  <div id="jobs" style="display:none">
  <div class="input-group input-group-lg">
  <span class="input-group-addon" id="sizing-addon1">Job ID</span>
  <input type="text" class="form-control"  name="uid"  placeholder="job ID" aria-describedby="sizing-addon1">
</div>
  </div>
<div style="height:90px;"></div>
<div  style="background:#FFF;">

        <input type="submit" class="btn btn-large btn-success" style="width:100%; height:80px; font-size:24px;" value="Get started" />
      </div>
</form>
</div>

</div>
</body>
</html>