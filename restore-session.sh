#!/bin/bash
activeprocess=$(ps -eo pid,cmd,tty,args | while read PID CMD TTY ARG; do echo "$ARG"; done )
oldactiveprocess=$(cat /etc/oldps | while read PID CMD TTY ARG; do echo "$ARG"; done )
#$oldactiveprocess | while read PID CMD TTY ARG; do echo $ARG; done
echo "$activeprocess" > /tmp/activeprocess
echo "$oldactiveprocess" > /tmp/oldactiveprocess
# sucess=()
ASKVALUES=()
diff -u /tmp/activeprocess /tmp/oldactiveprocess | sed -n '/^+[^+]/ s/^+//p' | while read args
do
    if type "$args" &> /dev/null; then
        echo "$args"
        # $args &
        # echo "End of $line"
        sucess+="$line\n"
    fi
done
echo -e "${sucess[@]}"
