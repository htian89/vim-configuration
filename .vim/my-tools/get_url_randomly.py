#!/usr/bin/python

import sys
import os
import random
import commands

result_record = []
result_url = []

if len(sys.argv) < 3:
    exit(1)
path_name = sys.argv[1]
total_num = int(sys.argv[2])
sub_dirs = os.listdir(path_name)
total_url_num = 0
for sub_dir in sub_dirs:
    target_dir = path_name + '/' + sub_dir
    if not os.path.isdir(target_dir):
        continue
    url_num = int(commands.getoutput("grep '^http' " + target_dir + "/diff/*old | wc -l"))
    total_url_num = total_url_num + url_num

print "total url num: " + str(total_url_num)

while len(result_url) < total_num:
    if len(result_record) == total_url_num:
        break
    sub_dir = random.choice(sub_dirs)
    target_dir = path_name + '/' + sub_dir
    if not os.path.isdir(target_dir):
        continue
    url_num = int(commands.getoutput("grep '^http' " + target_dir + "/diff/*old | wc -l"))
    url_index = random.randint(1, url_num)
    record_str = sub_dir + '_' + str(url_index)
    if record_str in result_record:
        continue
    result_record.append(record_str)
    url = commands.getoutput("grep '^http' " + target_dir + "/diff/*old | awk 'NR==" + str(url_index) + "'")
    url_split = url.split('?')
    real_url = 'proxy.jd.com/?' + url_split[0] + "?debug=&debug_model=&trace_group_id=&" + url_split[1]
    if real_url in result_url:
        continue
    result_url.append(real_url)
    print record_str + ":"
    print real_url
    print ""

print "url num: " + str(len(result_url))
