<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Metabolism Analysis and  Resources Central</title>
<!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
     <script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
<!-- Bootstrap core CSS -->

<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="bootstrap/css/bootstrap.css" rel="stylesheet">
<!-- 可选的 Bootstrap 主题文件（一般不用引入） -->
<link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
<link rel="stylesheet" href="bootstrap/css/bootstrap-responsive.css" >
<!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
<script src="bootstrap/js/bootstrap.min.js" ></script>
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
                <li><a href="index.php">Home</a></li>
                <li><a href="analysis.php">Analysis</a></li>
                <li class="active"><a href="search.php">Search</a></li>
                <li><a href="download.php">Downloads</a></li>
                <li ><a href="about.php">About</a></li>
                <li><a href="help.php">FAQ</a></li>
              </ul>
            </div>
          </div>
        </div><!-- /.navbar -->
      </div>
       <!-- Jumbotron -->
  <div class="bs-example alert alert-success" >
<iframe src="line.php" align="middle" width="100%" scrolling="auto" height="450" frameborder="0" ></iframe>

</div>
<hr>

<form id="form" name="form" method="post" action="analysis/get_mz.php" enctype="multipart/form-data">
<div id="create" style="display:block">
<div class="input-group input-group-lg">
  <span class="input-group-addon" id="sizing-addon1">m/z</span>
  <input type="text" class="form-control"  name="mz"  placeholder="mass-to-charge ratio of fragment" aria-describedby="sizing-addon1">
</div>
<div style="height:50px;"></div>
<div class="input-group input-group-lg" >
  <span class="input-group-addon" id="basic-addon1">Mass error</span>
  <select type="text" name="thres" class="form-control" aria-describedby="basic-addon1">
  <option value="0" selected="selected">--select--</option>
  <option value="5" >5 ppm</option>
  <option value="10" >10 ppm</option>
  <option value="30" >30 ppm</option>
  </select>
  </div>
<!--<div style="height:50px;"></div>
<div class="input-group input-group-lg" >
  <span class="input-group-addon" id="basic-addon1">Polarity</span>
  <select type="text" name="polar" class="form-control" aria-describedby="basic-addon1">
  <option value="0" selected="selected">--select--</option>
  <option value="1" >Positive</option>
  <option value="2" >Negative</option>
  </select>
  </div>
<div style="height:50px;"></div>
 <div class="form-group">
    <label for="exampleInputFile">File input</label>
    <input type="file" id="exampleInputFile">
    <p class="help-block">Example block-level help text here.</p>
  </div>-->
<div style="height:20px;"></div>
<div  align="center" style="background:#FFF;">

        <input type="submit" class="btn btn-large btn-success" style="width:270; height:60px; font-size:24px;" value="Search" />
      </div>
</form>

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