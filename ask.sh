#!/usr/bin/bash
ask (){
    # Variables definitions
    ASKVALUES=()
    INITIALS=()
    PROMPT="$1 ["
    shift
    # Add to list
    while [[ $# -gt 0 ]]
    do
        ASKVALUES+=("$1")
        INITIALS+=("$(echo $1 | head -c 1)")
        shift
    done
    # Generate prompt
    firstrun=1
    for itempos in $(seq 0 $((${#ASKVALUES[@]}-1)))
    do
        item=${ASKVALUES[$itempos]}
        initial=${INITIALS[$itempos]}
        if [ $firstrun -eq 0 ]
        then
            PROMPT+=", "
        fi
        PROMPT+=$initial"(${item:1})"
        firstrun=0
    done
    PROMPT+="] "
    # Ask and save
    found=0
    tput sc
    while [ $found -eq 0 ]
    do
        tput rc
        tput el
        REPLY=""
        while [ "$REPLY" = "" ]
        do
            read -p "$PROMPT" -n 1 -s REPLY
        done
        # Complete
        for item in ${ASKVALUES[@]}
        do
            if [ $REPLY = $(echo $item | head -c 1) ]
            then
                echo $item
                found=1
            fi
        done
    done
}
