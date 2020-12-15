## ubuntu检测脚本安装说明（以下操作以root用户身份进行）

### 1.首先需要安装Except

##### 1.1 查看是否有Except服务

![1569834278071](https://boke-1259222504.cos.ap-shanghai.myqcloud.com/github/1569834278071.png)

**注:如果有则跳过第一步except步骤直接进行第二步。**



##### 1.2 检查tcl 安装情况

```shell
#whereis tcl
```

![1569834693116](https://boke-1259222504.cos.ap-shanghai.myqcloud.com/github/1569834693116.png)

如果如上图为空则需要进行安装。



##### 1.3 下载安装包

tcl版本 8.4.19

https://jaist.dl.sourceforge.net/project/tcl/Tcl/8.4.19/tcl8.4.19-src.tar.gz

except版本5.45

http://sourceforge.net/projects/expect/files/Expect/5.45/expect5.45.tar.gz

下载两个包，分别解压。



##### 1.4 先安装tcl

 进入tcl解压目录，然后进入unix目录：

![1569834890714](https://boke-1259222504.cos.ap-shanghai.myqcloud.com/github/1569834890714.png)

```shell
#sudo ./configure
#sudo make
#sudo make install
```



##### 1.5 安装expect

进入expect解压目录：

安装时需指定tcl的相关目录

--with-tclinclude 参数就是  tcl开发包的解压安装位置

```shell
#sudo ./configure --with-tclinclude=/usr/local/src/tcl8.4.19/generic/ --with-tclconfig=/usr/local/lib/       //(这里的with-tclinclude=位置处需要写入tcl安装包解压的位置)
#sudo make
#sudo make install
```

注意这里的configure命令需要使用–with-tclinclude选项传入tcl安装包中的generic文件夹路径。

安装完成之后运行expect命令，查看是否安装成功。

```shell
# expect
expect1.1>
```



### 2. 检查脚本安装

##### 2.1 检查脚本有一处需要编辑地方

```shell
#!/bin/bash
set -x
source /etc/profile

NOW_IP=`ip a |awk -F '[ /]+' 'NR==9 {print $3}'`
myPath="/var/"  

find ./ -regextype posix-extended -regex ".*\.(jpg|png|bmp)" ! -path "./sys/*" ! -path "./etc/*"  ! -path "./bin/*"  ! -path "./lib/*"  ! -path "./lib64/*"  >>  /var/$NOW_IP.txt 

TO_HOST="**"
USER="**"
PASSWD="***"
TO_DIR="/bakdata/checklogs/"
 
/expect5.45/expect <<-EOF  #该处改为你expect安装的目录
set timeout -1
spawn scp  -o "StrictHostKeyChecking no"  /var/$NOW_IP.txt $USER@$TO_HOST:$TO_DIR
 
expect "assword:"
send "$PASSWD\n"
 
expect "100%"
expect eof
EOF
  
rm -rf  /var/$NOW_IP.txt
```

dataacp.sh需要设置可执行权限。chmod 655 dataacp.sh

下面为dataacp1.1.sh 升级了版本。需求是分别输出大于60天与小于60天的文件

```shell
#!/bin/bash
set -x

source /etc/profile

NOW_IP=`ip a |awk -F '[ /]+' 'NR==9 {print $3}'`
myPath="/var/"  
  
find / -regextype posix-extended -regex ".*\.(jpg|png|bmp)" -mtime -60 ! -path "./sys/*" ! -path "./etc/*"  ! -path "./bin/*"  ! -path "./lib/*"  ! -path "./lib64/*"  >>  /var/$NOW_IP.txt.min 
find / -regextype posix-extended -regex ".*\.(jpg|png|bmp)" -mtime +60 ! -path "./sys/*" ! -path "./etc/*"  ! -path "./bin/*"  ! -path "./lib/*"  ! -path "./lib64/*"  >>  /var/$NOW_IP.txt.max 

TO_HOST="10.*.*.*"
USER="***"
PASSWD="******"
TO_DIR="/bakdata/checklogs/"
 
/expect/expect5.45/expect <<-EOF
set timeout -1
spawn scp  -o "StrictHostKeyChecking no"  /var/$NOW_IP.txt.min $USER@$TO_HOST:$TO_DIR
 
expect "assword:"
send "$PASSWD\n"
 
expect "100%"
expect eof
EOF
rm -rf  /var/$NOW_IP.txt.min

/expect/expect5.45/expect <<-EOF
set timeout -1
spawn scp  -o "StrictHostKeyChecking no"  /var/$NOW_IP.txt.max $USER@$TO_HOST:$TO_DIR
 
expect "assword:"
send "$PASSWD\n"
 
expect "100%"
expect eof
EOF
rm -rf  /var/$NOW_IP.txt.max
```



##### 2.2 写时间计划

​		ubuntu第一次进行操作时候，需要进行编辑器选择。选择第二个工具。

![1570512424469](https://boke-1259222504.cos.ap-shanghai.myqcloud.com/github/1570512424469.png)

然后时间计划如下进行写入

![1570522932392](https://boke-1259222504.cos.ap-shanghai.myqcloud.com/github/1570522932392.png)

重启时间计划任务：

```shell
#service cron restart
```





#### 注：

1:请将datacap.sh脚本放于root目录下	

2:将datacap.sh权限设置为655

3:全程用root身份进行操作