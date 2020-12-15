#!/bin/bash
set -x

source /etc/profile            

NOW_IP=`ip a |awk -F '[ /]+' 'NR==9 {print $3}'`   //采集IP地址信息，输出ip a中9行3列的内容。
myPath="/var/"  
#myFile="/var/$LAST_DATE.txt"  
find / -regextype posix-extended -regex ".*\.(jpg|png|bmp)" ! -path "./sys/*" ! -path "./etc/*"  ! -path "./bin/*"  ! -path "./lib/*"  ! -path "./lib64/*"  >>  /var/$NOW_IP.txt    //全盘检索.jpg|png|bmp等文件内容，输入文本，并排除-path相关目录。

TO_HOST="10.1.*.*"
USER="checklog"
PASSWD="****"
TO_DIR="/bakdata/checklogs/"
 
/expect/expect5.45/expect <<-EOF
set timeout -1
spawn scp  -o "StrictHostKeyChecking no"  /var/$NOW_IP.txt $USER@$TO_HOST:$TO_DIR
 
expect "assword:"
send "$PASSWD\n"
 
expect "100%"
expect eof
EOF
 
 
rm -rf  /var/$NOW_IP.txt


test111
11111
test