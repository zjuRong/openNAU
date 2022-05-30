<?php
//error_reporting(0);
include('config/conn.php');
$sql1="select * from ref_meta order by number desc";
$res=mysqli_query($conn,$sql1);
$id=$data=$dlink=array();
while($urow=mysqli_fetch_row($res)){
	$id[]=$urow[1];
	$data[]=$urow[3];
	$dlink[]=$urow[2];
	}

$ud=implode("','",$id);
$ud="'".$ud."'";
$da=implode(",",$data);

$dl=implode("','",$dlink);
$dl="'".$dl."'";
?>


<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>The line graph of literature data update</title>
	<script src="js/echarts.min.js"></script>
	
</head>
<body>
	 <div id="main" style="width:100%; height:400px;"></div>
	<script>
	 var myChart = echarts.init(document.getElementById('main'));
	 option = {
		 title: {
        text: 'The bar graph of data resource'
    },
    tooltip: {
        trigger: 'axis',
        axisPointer: {            // 坐标轴指示器，坐标轴触发有效
            type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
        }
    },
    grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        containLabel: true
    },
    xAxis: [
        {
            type: 'category',
           data: [<?php echo $ud;?>],
            axisTick: {
                alignWithLabel: true
            }
        }
    ],
    yAxis: [
        {
            type: 'value'
        }
    ],
    series: [
        {
            name: "Number",
            type: 'bar',
            barWidth: '60%',
           data: [<?php echo $da;?>]
        }
    ]
};

 myChart.setOption(option);
myChart.on('click', function(params){
	  //self.location='world/research.php?state='+params.name;
	  //window.open(params.name);
		//console.log(params.id);//此处写点击事件内容
		});
	</script>
</body>
</html>
