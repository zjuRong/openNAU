<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Metabolism Analysis and  Resources Central</title>
<!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
 <script src="bootstrap/js/jquery.min.js"></script>
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
 <script type="text/javascript" language="javascript">
 function link(a){
	 switch(a){
	case "upload":
	 document.getElementById('upload').className="active";
	 document.getElementById('normalize').className="";
	 document.getElementById('model').className="";
	 document.getElementById('peak').className="";
	 document.getElementById('statistics').className="";
	 document.getElementById('more').className="none";
	 document.getElementById('upload_index').style.display="block";
	 document.getElementById('normalize_index').style.display="none";
	 document.getElementById('model_index').style.display="none";
	 document.getElementById('peak_index').style.display="none";
	 document.getElementById('statistics_index').style.display="none";
	 document.getElementById('more_index').style.display="none";
	 break;
	 case "normalize":
	 document.getElementById('normalize').className="active";
	 document.getElementById('model').className="";
	 document.getElementById('upload').className="";
	 document.getElementById('peak').className="";
	 document.getElementById('statistics').className="";
	 document.getElementById('more').className="none";
	 document.getElementById('model_index').style.display="none";
	 document.getElementById('normalize_index').style.display="block";
	 document.getElementById('upload_index').style.display="none";
	 document.getElementById('peak_index').style.display="none";
	 document.getElementById('statistics_index').style.display="none";
	 document.getElementById('more_index').style.display="none";
	 break;
	 case "model":
	 document.getElementById('model').className="active";
	 document.getElementById('normalize').className="";
	 document.getElementById('upload').className="";
	 document.getElementById('peak').className="";
	 document.getElementById('statistics').className="";
	 document.getElementById('more').className="none";
	 document.getElementById('model_index').style.display="block";
	 document.getElementById('normalize_index').style.display="none";
	 document.getElementById('upload_index').style.display="none";
	 document.getElementById('peak_index').style.display="none";
	 document.getElementById('statistics_index').style.display="none";
	 document.getElementById('more_index').style.display="none";
	 break;
	 case "peak":
	 document.getElementById('model').className="";
	 document.getElementById('normalize').className="";
	 document.getElementById('peak').className="active";
	 document.getElementById('upload').className="";
	 document.getElementById('statistics').className="";
	 document.getElementById('more').className="none";
	 document.getElementById('model_index').style.display="none";
	 document.getElementById('normalize_index').style.display="none";
	 document.getElementById('upload_index').style.display="none";
	 document.getElementById('peak_index').style.display="block";
	 document.getElementById('statistics_index').style.display="none";
	 document.getElementById('more_index').style.display="none";
	 break;
	 case "statistics":
	 document.getElementById('model').className="";
	 document.getElementById('normalize').className="";
	 document.getElementById('upload').className="";
	 document.getElementById('peak').className="";
	 document.getElementById('statistics').className="active";
	 document.getElementById('more').className="none";
	 document.getElementById('upload_index').style.display="none";
	 document.getElementById('normalize_index').style.display="none";
	 document.getElementById('model_index').style.display="none";
	 document.getElementById('peak_index').style.display="none";
	 document.getElementById('statistics_index').style.display="block";
	 document.getElementById('more_index').style.display="none";
	 break;
	 case "more":
	 document.getElementById('model').className="";
	 document.getElementById('normalize').className="";
	 document.getElementById('upload').className="";
	 document.getElementById('peak').className="";
	 document.getElementById('statistics').className="none";
	 document.getElementById('more').className="active";
	 document.getElementById('upload_index').style.display="none";
	 document.getElementById('normalize_index').style.display="none";
	 document.getElementById('model_index').style.display="none";
	 document.getElementById('peak_index').style.display="none";
	 document.getElementById('statistics_index').style.display="none";
	 document.getElementById('more_index').style.display="block";
	 break;
	 
	 }
	 
	 }
 
 
 
 
 
 </script>   
</head>

<body>
<div class="container">

      <div class="masthead">
        <h3 class="muted">MARC</h3>
        <div class="navbar">
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
<ul class="nav nav-tabs" style="margin-bottom:-50px;">
<li role="presentation" class="active" id="upload" onClick="link('upload')"><a href="#">Upload data</a></li>
<li role="presentation"  id="normalize" onClick="link('normalize')"><a href="#">Data Normalization</a></li>
  <li role="presentation"  id="model" onClick="link('model')"><a href="#">Process 1</a></li>
  <li role="presentation" id="peak" onClick="link('peak')"><a href="#">Process 2</a></li>
  <li role="presentation" id="statistics" onClick="link('statistics')"><a href="#">Process 3</a></li>
  <li role="presentation" id="more" onClick="link('more')"><a href="#">More process</a></li>
</ul>
<div id="upload_index" class="container">
      <!-- Jumbotron -->
      <div class="jumbotron">
        <p class="pill-content" align="justify">Before this process, you need to analyze the raw data by metQC. In this process, you should upload three file (mass_inf.csv, sampel_mass_*.csv,clinical.csv) and mark the refernece compound in mass_inf.csv file. Then all subsequent steps will be automatically completed and the corresponding analysis report will be generated </p> 
        <div align="left">
        <p>mass_inf.csv</p>
        <div align="center">
        <img src="imges/mass_inf.jpg" width="504" height="700"/>
        </div>
        </div>
        <hr>
        <div align="left">
        <p>sampel_mass_*.csv</p>
        <div align="center">
        <img src="imges/sample_mass.jpg" width="504" height="700"/>
        </div>
        </div>
        <hr>
        <div align="left">
        <p>clinical.csv</p>
        <div align="center">
        <img src="imges/clinical.jpg" width="504" height="700"/>
        </div>
        </div>
        <div align="center" style="margin-top:30px; width:100%; background:#CCC; height:100px; line-height:100px;">
        <a class="btn btn-large btn-success" href="analysis/index.php">Get started</a>
        </div>
      </div>

</div>
<div id="normalize_index" style="display:none" class="container">
      <!-- Jumbotron -->
      <div class="jumbotron">
        <p class="pill-content" align="justify"> In this module, we designed two data Normalization methods: Normalization 1 based on statistical methods and Normalization 2 based on machine learning algorithms.</p> 
        <div>
        <img src="imges/normalize.jpg" width="504" height="700"/>
        </div>
       <div align="center" style="margin-top:30px; width:100%; background:#CCC; height:100px; line-height:100px;">
        <a class="btn btn-large btn-success" href="analysis/index.php">Get started</a>
        </div>
      </div>

</div>
<div id="model_index" style="display:none" class="container">
      <!-- Jumbotron -->
      <div class="jumbotron">
        <p class="pill-content" align="justify">Before this process, you need to analyze the raw data by metQC. In this process, you should upload three file (mass_inf.csv, sampel_mass_*.csv,clinical.csv) and mark the refernece compound in mass_inf.csv file. Then all subsequent steps will be automatically completed and the corresponding analysis report will be generated </p> 
        <div>
        <img src="imges/process1.png" width="504" height="700"/>
        </div>
        <div align="center" style="margin-top:30px; width:100%; background:#CCC; height:100px; line-height:100px;">
        <a class="btn btn-large btn-success" href="analysis/index.php">Get started</a>
        </div>
      </div>

</div>
<div id="peak_index" style="display:none" class="container">
      <!-- Jumbotron -->
      <div class="jumbotron">
        <!--<p class="lead" align="justify">Metabolism Analysis and  Resources Central(MARC) is a GC/LC-MASS original data analysis process software, and provides HMDB data integration, retrieval and data download.</p> -->
        <div>
        <img src="imges/process2.jpg" width="504" height="700"/>
        </div>
       <div align="center" style="margin-top:30px; width:100%; background:#CCC; height:100px; line-height:100px;">
        <a class="btn btn-large btn-success" href="analysis/index.php">Get started</a>
        </div>
      </div>
</div>
<div id="statistics_index" style="display:none" class="container">
      <!-- Jumbotron -->
      <div class="jumbotron">
        <!--<p class="lead" align="justify">Metabolism Analysis and  Resources Central(MARC) is a GC/LC-MASS original data analysis process software, and provides HMDB data integration, retrieval and data download.</p> -->
        <div>
        <img src="imges/process3.jpg" width="504" height="700"/>
        </div>
       <div align="center" style="margin-top:30px; width:100%; background:#CCC; height:100px; line-height:100px;">
        <a class="btn btn-large btn-success" href="analysis/index.php">Get started</a>
        </div>
      </div>
</div>

<div id="more_index" style="display:none" class="container">
      <!-- Jumbotron -->
      <div class="jumbotron" >
        <!--<p class="lead" align="justify">Metabolism Analysis and  Resources Central(MARC) is a GC/LC-MASS original data analysis process software, and provides HMDB data integration, retrieval and data download.</p> -->
        <div style="height:500px;"></div>
      <div align="center" style="margin-top:30px; width:100%; background:#CCC; height:100px; line-height:100px;">

        </div>
      </div>
</div>
</div>
</body>
</html>