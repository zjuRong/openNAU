<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Metabolism Analysis and  Resources Central</title>
<!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
    <script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
<!-- 最新版本的 Bootstrap 核心 CSS 文件 -->
<link rel="stylesheet" href="bootstrap/css/bootstrap.css" >

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
                <li class="active"><a href="index.php">Home</a></li>
                <li><a href="analysis.php">Analysis</a></li>
                <li><a href="search.php">Search</a></li>
                <li><a href="download.php">Downloads</a></li>
                <li><a href="about.php">About</a></li>
                <li><a href="help.php">FAQ</a></li>
              </ul>
            </div>
          </div>
        </div><!-- /.navbar -->
      </div>
       <!-- Jumbotron -->
  <div class="bs-example alert alert-success" >
    <div class="jumbotron">
 <p class="lead" align="justify">Metabolism Analysis and  Resources Central(MARC) is a GC/LC-MASS original data analysis process software, and provides HMDB data integration, retrieval and data download.</p>
 <!-- <a class="btn btn-large btn-success" href="#">Get started</a> -->
    </div>

</div>

      <hr>
      <!-- Example row of columns -->
      <div class="row-fluid">
      <div class="span4">
          <h2>Search</h2>
          <p align="justify">Single or batch retrieval of metabolites, nucleo-cytoplasmic ratio fuzzy retrieval, and fuzzy matching of compounds corresponding to mass spectral peaks. </p>
          <p><a class="btn btn-primary" href="search.php">View details »</a></p>
        </div>
        <div class="span4">
          <h2>Analysis</h2>
          <p align="justify">Analysis of the original mass spectrum data, in-depth analysis of mass spectrum peak, downstream or upstream target and pathway enrichment analysis.</p>
          <p><a class="btn btn-primary" href="analysis.php">View details »</a></p>
       </div>
        <div class="span4">
          <h2>Download</h2>
          <p align="justify">The download of metabolite nucleo-mass ratio data, target data, pathway data. meanwhile, 33 cancers genes and pathway expression data also can be download.</p>
          <p><a class="btn btn-primary" href="download.php">View details »</a></p>
        </div>
      </div>
      <hr>
<div class="page-header">
        <h2>Extend link</h2>
         <hr>
<a class="btn btn-link" href="http://www.hmdb.ca/">Human Metabolome Database</a>
<a class="btn btn-link" href="http://smpdb.ca/">The Small Molecule Pathway Database</a>
<a class="btn btn-link" href="https://mona.fiehnlab.ucdavis.edu/">MassBank of North America</a>
<a class="btn btn-link" href="http://metdna.zhulab.cn/">MetDNA</a>
<a class="btn btn-link" href="http://metdna.zhulab.cn/">MetDNA</a>
<a class="btn btn-link" href="http://www.mmass.org/">mMass</a>
<a class="btn btn-link" href="http://www.urinemetabolome.ca/">Urine Metabolome</a>
<a class="btn btn-link" href="http://gmd.mpimp-golm.mpg.de/">Golm Metabolome Database</a>
<a class="btn btn-link" href="https://www.metanetx.org/">MetaNetX</a>
      </div>
      <div class="footer">


        <p>© Lai lab 2019</p>
      </div>

    </div>
</div>
</body>
</html>