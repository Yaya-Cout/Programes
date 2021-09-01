echo "Saving active processes"
ps -eo pid,cmd,tty,args > /etc/oldps
