#!/bin/bash

door_machine="yimu.th@login1.su18.alibaba.org"
#door_machine="james.zxr@login1.eu13.alibaba.org"
ssh_file=~/.ssh/master-${door_machine}:22

if [ $# -eq 0 ]; then
echo "select server:"
serverList=(
   "11.12.63.149(case1)"
   "11.9.78.163(case_tmp)"
   "11.140.90.101(preonline_101)"
   "11.140.90.103(preonline_103)"
   "11.140.21.245(buildindex_master)"
   "11.140.21.244(buildindex_backup)"
   "11.180.55.1(jump)"
)
select serverstring in ${serverList[@]}
do
break
done
#array=(${serverstring//(/ })
array=(`echo $serverstring | tr '(' ' '`)
server=${array[0]}
else
   server=$1
fi
#echo $server

if [ ! -S "${ssh_file}" ]; then
   echo "input token:"
   read token
fi

aligo ${door_machine} ${server} ${token}
