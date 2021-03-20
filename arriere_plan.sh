    #!bin/bash

    #wait for internet connection up to 15 seconds
    host=google.com
    CONNECTED=$(ping -w5 -c1 $host > /dev/null 2>&1 && echo "up" || echo "down")
    STOPWATCH=0
    while [ "$CONNECTED" = "down" ] && [ $STOPWATCH -lt 15 ]; do
        sleep 1;
        CONNECTED=$(ping -w5 -c1 $host > /dev/null 2>&1 && echo "up" || echo "down")
        let STOPWATCH++
    done

    #run Thunderbird
    thunderbird &

    #Search for Thunderbird window
    TB=$(xdotool search --class thunderbird)
    while [ -z "$TB" ]; do
        sleep 10 #Adjust this to your system needs
        TB=$(xdotool search --class thunderbird)
    done

    #dispose Thunderbird window
    xdotool search --class thunderbird windowunmap %@
