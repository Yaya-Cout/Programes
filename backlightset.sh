backlightpath="/sys/class/backlight/intel_backlight/brightness"
max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)
get_brightness (){
    echo $(cat $backlightpath)
}
set_brightness (){
    echo $1 > $backlightpath
}
round (){
    echo $(echo $1 | awk '{print int($1)}')
}
converttopercent (){
    percent=$(echo "$1 / $max_brightness * 100" |bc -l)
    percent=$(round $percent)
    if [ $percent -gt 100 ]
    then
        >&2 echo "Brightness is over 100"
        exit 1
    elif [ $percent -lt 0 ]
    then
        >&2 echo "Brightness is less than 0"
    else
        echo $percent
    fi
}
converttoraw (){
    raw=$(echo "$1 * $max_brightness / 100" |bc -l)
    raw=$(round $raw)
    echo $raw
}
case $1 in
    d|decrease|down|less)
        addvalue=-5
        if [ "$2" != "" ]
        then
            addvalue=-$2
        fi
        nextbrightnessinpercent=$(($(converttopercent $(get_brightness))+$addvalue))
        nextbrightnessraw=$(converttoraw $nextbrightnessinpercent)
        set_brightness $nextbrightnessraw
        ;;
    u|i|up|more|increase)
        addvalue=5
        if [ "$2" != "" ]
        then
            addvalue=$2
        fi
        nextbrightnessinpercent=$(($(converttopercent $(get_brightness))+$addvalue))
        nextbrightnessraw=$(converttoraw $nextbrightnessinpercent)
        set_brightness $nextbrightnessraw
        ;;
    *)
        echo "Argument inconnu"
        ;;
esac
