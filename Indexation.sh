#! /bin/bash
# set -xv
# cd /
find > /home/neo/TMP/Test
echo "Que voulez-vous rechercher ?"
read finding
# cat /home/neo/TMP/Test | grep $finding
search="cat '/home/neo/TMP/Test' | grep \"$finding\""
$search
# echo $search
while true
do
    echo "Texte a filtrer :"
    read filtrer
    search=$search" | grep \"$filtrer\""
    # $search
    echo $search
done
# cat /home/neo/TMP/Test | while read line
# do
#     cat "$line" >> /home/neo/TMP/Test2
#     # echo 3 > sudo /proc/sys/vm/drop_caches
#     echo 3 > /proc/sys/vm/drop_caches
# done