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
                <li><a href="index.php">Home</a></li>
                <li><a href="analysis.php">Analysis</a></li>
                <li><a href="search.php">Search</a></li>
                <li class="active"><a href="download.php">Downloads</a></li>
                <li ><a href="about.php">About</a></li>
                <li><a href="help.php">FAQ</a></li>
              </ul>
            </div>
          </div>
        </div><!-- /.navbar -->
      </div>
       <!-- Jumbotron -->

<hr>

<p align="justify">Refmet data resources mainly integrate AIICCS (2020-10-17), Massbank (version 2021.03), KEGG (2021-3-3), Reactome (version 2020), SMPDB (2018-14), HMDB,The metabolite or metabolic pathway information of Chebi (2021-3-1), Pathbank (2019-8-15), Npatlas (v2020_06), MsigDB (V7.2) database, and the current version of the database is marked.Among them, the molecular data of metabolites are mainly composed of:1729(AIICCS), 113984(HMDB), 18776(KEGG), 1977781(Pathbank), 124919(Chebi), 86576(Massbank), 29006(NPATLAS), 55700(SMPDB).Due to cross-referencing among databases, this study normalized the data and finally obtained 476,830 compounds.Among them, the m/z data of 322550 is complete, which constitutes the reference database of metabolic compounds in this study.</p>
<a class="btn btn-link" href="data/refMet/refMet_all_compound_link_database.csv">Dowmload</a>
<hr>
<p align="justify">The related pathway data were from PathBank(48656) and MSIGDB (27123) totaling 75779.</p>
<a class="btn btn-link" href="data/refMet/human_pathway_pathbank.csv">Dowmload</a>
<hr>
<p align="justify">In this study, pathway-compound GMT reference files were constructed based on human pathway and compound information in PathBank and KEGG databases.This file contains 48802 reference channels in total.</p>
<a class="btn btn-link" href="data/refMet/hmdb_compound_pathway.gmt">Dowmload</a>
<hr>
<p align="justify">The metabolized and corresponding target information is contained in the HMDB database, which contains 5459 related target gene proteins.</p>
<a class="btn btn-link" href="data/refMet/hmdb_proteins.csv">Dowmload</a>
<hr>
<p align="justify">The KEGG database contains 5613 related enzymes corresponding to metabolites</p>
<a class="btn btn-link" href="data/refMet/enyme_compound_hmdb.csv">Dowmload</a>
</div>

<hr>


</div>
</body>
</html>