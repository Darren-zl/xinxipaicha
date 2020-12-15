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
