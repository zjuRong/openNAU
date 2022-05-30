<?php
$uid=$_GET["uid"];
$p=$_GET["p"];
    //创建一个socket套接流AF_INET: IPv4 网络协议。TCP 和 UDP 都可使用此协议。一般都用这个，你懂的。AF_INET6：IPv6 网络协议。TCP 和 UDP 都可使用此协议。AF_UNIX:本地通讯协议。具有高性能和低成本的 IPC（进程间通讯）。
    $socket = socket_create(AF_INET,SOCK_STREAM,SOL_TCP);
    /****************设置socket连接选项，这两个步骤你可以省略*************/
     //接收套接流的最大超时时间1秒，后面是微秒单位超时时间，设置为零，表示不管它
    socket_set_option($socket, SOL_SOCKET, SO_RCVTIMEO, array("sec" => 10000000000, "usec" => 0));
     //发送套接流的最大超时时间为6秒
    socket_set_option($socket, SOL_SOCKET, SO_SNDTIMEO, array("sec" => 60000, "usec" => 0));
    /****************设置socket连接选项，这两个步骤你可以省略*************/

    //连接服务端的套接流，这一步就是使客户端与服务器端的套接流建立联系
    if(socket_connect($socket,'10.71.208.94',8761) == false){
        echo 'connect fail massege:'.socket_strerror(socket_last_error());
    }else{
        $message =$uid.'-'.$p;
        //转为GBK编码，处理乱码问题，这要看你的编码情况而定，每个人的编码都不同
        $message = mb_convert_encoding($message,'GBK','UTF-8');
        //向服务端写入字符串信息

        if(socket_write($socket,$message,strlen($message)) == false){
            echo 'fail to write'.socket_strerror(socket_last_error());

        }else{
            //读取服务端返回来的套接流信息
            while($callback = socket_read($socket,1024)){
                //echo 'server return message is:'.PHP_EOL.$callback;
				if($callback==1){
					echo 1;
					}else{
						echo  0;
						}
				
            }
        }
    }
    socket_close($socket);//工作完毕，关闭套接流

?>




