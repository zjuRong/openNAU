<?php
$host='127.0.0.1'; //数据库地址
$database='metabolism';   //数据库名称
$user='zju_meta';   //数据库帐户
$pass='973254023';   //数据库密码
$path='';   //系统安装目录

$conn=new mysqli($host,$user,$pass,$database);
//mysql_query("set names 'utf8'");//这就是指定数据库字符集，一般放在连接数据库后面就系了 
mysqli_query($conn,"set names utf8");
if(!$conn)
 {
  die('数据库连接失败：'.mysql_error());
 }else{
	 
	//echo "success！"; 
	 }
function exec_p($id,$process,$conn){
	$sql="select * from jobs where results='$id'";
	$res= mysqli_query($conn,$sql);
	$num=mysqli_num_rows($res);
	if($num>0){
	$row=mysqli_fetch_row($res);	
	exec("Rscript /var/www/html/metabolism/R/".$process." ".$id." 1",$res,$status);
	return($status);
	}else{
		return(100);
		}
	}
//创建服务端的socket套接流,net协议为IPv4，protocol协议为TCP
$socket = socket_create(AF_INET,SOCK_STREAM,SOL_TCP);
    /*绑定接收的套接流主机和端口,与客户端相对应*/
    if(socket_bind($socket,'10.71.208.94',8761) == false){
        echo 'server bind fail:'.socket_strerror(socket_last_error());
        /*这里的127.0.0.1是在本地主机测试，你如果有多台电脑，可以写IP地址*/
    }else{
		echo 'server bind sucess!\n';
		}
    //监听套接流
    if(socket_listen($socket,5)==false){
        echo 'server listen fail:'.socket_strerror(socket_last_error());
    }else{
		echo 'server listen sucessed!\n';
		}
//让服务器无限获取客户端传过来的信息
do{
  /*接收客户端传过来的信息*/
    $client = socket_accept($socket);
    /*socket_accept的作用就是接受socket_bind()所绑定的主机发过来的套接流*/
    //创建子进程
    $pid = pcntl_fork();
    //父进程和子进程都会执行下面代码
    if ($pid == -1) {
        //错误处理：创建子进程失败时返回-1.
        die('could not fork');
    } else if ($pid) {
		
        //父进程会得到子进程号，所以这里是父进程执行的逻辑
        //pcntl_wait($status); //等待子进程中断，防止子进程成为僵尸进程。
        socket_close($client);
    } else {
        //子进程得到的$pid为0, 所以这里是子进程执行的逻辑。
	    $string = socket_read($client,1024);
		print($string);
        $res=explode("-",$string);
		$uid=$res[0];
		switch($res[1]){
			case 'norm':
			$status=exec_p($uid,"normalize.R",$conn);
			break;
			case 'norm1':
			$status=exec_p($uid,"normalize_1.R",$conn);
			break;
			case 'p1':
			$status=exec_p($uid,"process_1.R",$conn);
			break;
			case 'p2':
			$status=exec_p($uid,"process_2.R",$conn);
			break;
			case 'p3':
			$status=exec_p($uid,"process_3.R",$conn);
			break;
			}

		if(!$status){
			$return_client =1;
            /*向socket_accept的套接流写入信息，也就是回馈信息给socket_bind()所绑定的主机客户端*/
            socket_write($client,$return_client,strlen($return_client));
            /*socket_write的作用是向socket_create的套接流写入信息，或者向socket_accept的套接流写入信息*/
		}else{
			$return_client = 0;
            /*向socket_accept的套接流写入信息，也就是回馈信息给socket_bind()所绑定的主机客户端*/
            socket_write($client,$return_client,strlen($return_client));
            /*socket_write的作用是向socket_create的套接流写入信息，或者向socket_accept的套接流写入*/
			}
			
        socket_close($client);
    }
}while(true);


socket_close($socket);
