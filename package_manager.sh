#!/usr/bin/bash
POSITIONAL=()
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
usesudo (){
    usesudo
$SUDO
    if [ "$REPLY" = "y"]
    then
        $SUDO="sudo "
    else
        $SUDO=""
    fi
}
update () {
    # Update
    sudo apt  update $2
    sudo apt  upgrade $2
    sudo snap refresh $2
    pip3 install --upgrade $(pip3 freeze) --progress-bar pretty $2
    sudo npm update -g $2
}
search () {
    # Search packages
    aptitude search "$2"
    snap     search "$2"
    pip3     search "$2"
    npm      search "$2"
    apm      search "$2"
    flatpak  search "$2"
}
remove (){
    dpkg=1
    snap=1
    pip3=1
    npm=1
    atom=1
    vscode=1
    yarn=1
    dpkg-query -W --showformat='${Status}\n' $2 2> /dev/null |grep "install ok installed" > /dev/null || dpkg=0
    snap list              2> /dev/null | grep "$2 "  > /dev/null || snap=0
    pip3 freeze            2> /dev/null | grep "$2="  > /dev/null || pip3=0
    npm list -g            2> /dev/null | grep " $2@" > /dev/null || npm=0
    apm list               2> /dev/null | grep " $2@" > /dev/null || atom=0
    code --list-extensions 2> /dev/null | grep $2     > /dev/null || vscode=0
    yarn --list            2> /dev/null | grep $2     > /dev/null || yarn=0
    # Add to list
    if [ $dpkg -eq 1 ]
	then
	    list+=("dpkg")
	fi
    if [ $snap -eq 1 ]
	then
	    list+=("snap")
	fi
    if [ $pip3 -eq 1 ]
	then
	    list+=("pip3")
	fi
    if [ $npm -eq 1 ]
	then
	    list+=("npm")
	fi
    if [ $atom -eq 1 ]
	then
	    list+=("atom")
	fi
    if [ $vscode -eq 1 ]
	then
	    list+=("vscode")
	fi
    if [ $yarn -eq 1 ]
	then
	    list+=("vscode")
	fi
    echo ${list[@]}
    if [ ${#list[@]} -eq 1 ]
    then
        echo "Removing with "${list[@]}
        REPLY=$(echo ${list[@]} | head -c 1)
    elif [ ${#list[@]} -eq 0 ]
    then
        echo "Package not installed"
        exit 1
    else
        ask "Which remover ?" ${list[@]}
    fi
    # Remove
    if [ "$REPLY" = "d" ]
	then
	    sudo apt autoremove                        "$2"
	fi
    if [ "$REPLY" = "s" ]
    then
	    sudo snap remove                           "$2"
	fi
    if [ "$REPLY" = "p" ]
    then
	    usesudo
        $SUDO pip3 uninstall "$2"
    fi
	if [ "$REPLY" = "n" ]
    then
	    sudo npm remove -g                         "$2"
	fi
    if [ "$REPLY" = "a" ]
    then
	    apm uninstall                              "$2"
	fi
    if [ "$REPLY" = "v" ]
    then
	    code --uninstall-extension                 "$2"
	fi
    if [ "$REPLY" = "y" ]
    then
	    usesudo
        $SUDO yarn remove    "$2"
	fi
    if [ "$REPLY" = "r" ]
    then
	    sudo rpm -e                                "$2"
	fi
    if [ "$REPLY" = "r" ]
    then
	    usesudo
        $SUDO flatpak remove "$2"
	fi
    if [ "$REPLY" = "y" ]
    then
	    usesudo
        $SUDO yarn remove    "$2"
	fi
}
ifpageexist (){
    # Check if a page exist
    HTTP_CODE=$(curl --write-out "%{http_code}\n" "$1" --output output.txt --silent)
    if [ $HTTP_CODE -eq 200 ]
    then
        return 0
    else
        return 1
    fi
}
autoinstall (){
    # Variables definitions
    dpkg=1
    snap=1
    pip3=1
    npm=1
    atom=1
    vscode=1
    yarn=1
    list=()
    # Check if exist
    if [[ $2 =~ "." ]]; then
        flatpak=1
        ifpageexist https://flathub.org/apps/details/$2 || flatpak=0
    fi
    apt show $2  >& /dev/null || dpkg=0
    snap info $2 >& /dev/null || snap=0
    ifpageexist https://pypi.org/project/$2   || pip3=0
    ifpageexist https://registry.npmjs.org/$2 || npm=0
    ifpageexist https://atom.io/packages/$2   || atom=0
    ifpageexist https://marketplace.visualstudio.com/items?itemName=$2 || vscode=0
    # Add to list
    if [ $dpkg -eq 1 ]
	then
	    list+=("dpkg")
	fi
    if [ $snap -eq 1 ]
	then
	    list+=("snap")
	fi
    if [ $pip3 -eq 1 ]
	then
	    list+=("pip3")
	fi
    if [ $npm -eq 1 ]
	then
	    list+=("npm")
	fi
    if [ $atom -eq 1 ]
	then
	    list+=("atom")
	fi
    if [ $vscode -eq 1 ]
	then
	    list+=("vscode")
	fi
    # Ask
    if [ ${#list[@]} -eq 1 ]
    then
        echo "Installing with "${list[@]}
        REPLY=$(echo ${list[@]} | head -c 1)
    elif [ ${#list[@]} -eq 0 ]
    then
        echo "Package not available"
        exit 1
    else
        ask "Which installer ?" ${list[@]}
    fi
    # Install
    if [ "$REPLY" = "d" ]
	then
	    sudo apt install         "$2"
	fi
    if [ "$REPLY" = "s" ]
    then
	    sudo snap install        "$2"
	fi
    if [ "$REPLY" = "p" ]
    then
	    usesudo
        $SUDO pip3 install             "$2"
    fi
	if [ "$REPLY" = "n" ]
    then
	    sudo npm install -g      "$2"
	fi
    if [ "$REPLY" = "a" ]
    then
	    apm install              "$2"
	fi
    if [ "$REPLY" = "v" ]
    then
	    code --install-extension "$2"
	fi
    if [ "$REPLY" = "y" ]
    then
	    usesudo
        $SUDO yarn add                 "$2"
	fi
    if [ "$REPLY" = "r" ]
    then
	    sudo rpm --install            "$2"
	fi
    if [ "$REPLY" = "r" ]
    then
	    usesudo
        $SUDO flatpak install          "$2"
	fi
    if [ "$REPLY" = "y" ]
    then
	    usesudo
        $SUDO yarn add                 "$2"
	fi
}
install () {
    # read -p "Which installer ? [a(pt),s(nap),p(ip3),n(pm)] " -n 1
    ask "Which installer ?" "dpkg" "snap" "pip3" "npm" "atom" "vscode" "yarn" "rpm" "flatpak"
	if [ "$REPLY" = "d" ]
	then
	    sudo apt install         "$2"
	fi
    if [ "$REPLY" = "s" ]
    then
	    sudo snap install        "$2"
	fi
    if [ "$REPLY" = "p" ]
    then
	    usesudo
        $SUDO pip3 install             "$2"
    fi
	if [ "$REPLY" = "n" ]
    then
	    sudo npm install -g      "$2"
	fi
    if [ "$REPLY" = "a" ]
    then
	    apm install              "$2"
	fi
    if [ "$REPLY" = "v" ]
    then
	    code --install-extension "$2"
	fi
    if [ "$REPLY" = "y" ]
    then
	    usesudo
        $SUDO yarn add                 "$2"
	fi
    if [ "$REPLY" = "r" ]
    then
	    sudo rpm --install            "$2"
	fi
    if [ "$REPLY" = "r" ]
    then
	    usesudo
        $SUDO flatpak install          "$2"
	fi
    if [ "$REPLY" = "y" ]
    then
	    usesudo
        $SUDO yarn add                 "$2"
	fi
    # apm install codestream
    # code --install-extension
}
help () {
    echo "Options :"
    echo "-h -? --help help         Show this help message"
    echo "-u update upgrade         Upgrade all app or selected app"
    echo "-s search                 Search for pip, aptitude, snap and npm"
    echo "-i install                Install from selected installer"
}
if [ $# -eq 0 ]
then
    echo "Please enter an argument"
    help
    exit 2
fi
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -u|u|update|upgrade)
            update $@
            shift # past argument
            shift # past value
        ;;
        -s|s|search)
            search $@
            shift # past argument
            shift # past value
        ;;
	    -i|i|install)
            autoinstall $@
	        shift # past argument
            shift # past value
	        ;;
        -r|r|remove|uninstall)
            remove $@
	        shift # past argument
            shift # past value
            ;;
        help|-h|-?|--help)
            help $@
            shift # past argument
            ;;
        *)
            POSITIONAL+=("$1")
            shift # past argument
            ;;
    esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters
if [[ -n $1 ]]
then
    echo "This option(s) isn't valid:"
    echo "$@"
    help
    exit 1
fi
