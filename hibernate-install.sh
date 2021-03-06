#!/bin/bash
swapfile="/swapfile"
if [ ! -f "$swapfile" ]; then
    >&2 echo "$swapfile not exist !"
    exit 1
fi
getword (){
    wordid=1
    for word in $2
    do
        if [[ $wordid -eq $1 ]]
        then
            echo $word
            return
        fi
        wordid=$((wordid+1))
    done
}
rootdev=$(getword 1 $(mount | grep "/ " ))
rootuuid=$(blkid -o value -s UUID $rootdev)
swapfileoffset=$(getword 25 "$(filefrag -v $swapfile)")
swapfileoffset=$(echo $swapfileoffset | rev | cut -c3- | rev)
tests (){
    read -p "Press enter to hibernate"
    hibernateerror=0
    systemctl hibernate || hibernateerror=1
    if [ $hibernateerror -eq 1 ]
    then
        >&2 echo "Error when trying to hibernate"
        if mokutil --sb-state | grep disabled > /dev/null
        then
            >&2 echo "Unable to activate hibernation"
            exit 1
        else
            echo "Trying to disable secure boot"
            echo "This program will ask a password, you don't have to give your real password : You can give 12345678 at password"
            mokutil --disable-validation
            echo "Your computer will restart when you click on enter"
            echo "During the restart, you will see a blue screen"
            echo "Click on a key then select \"change secure boot state\" in the menu"
            read -p "Press enter"
            reboot
        fi
    else
        echo "Successfully install hibernation"
    fi
}
install (){
    if grep "RESUME=$swapfile" /etc/initramfs-tools/conf.d/resume >&1 2> /dev/null
    then
        >&2 echo "Initramfs is already configured"
    else
        echo "RESUME=$swapfile" >> /etc/initramfs-tools/conf.d/resume
        sudo update-initramfs -u -k $(uname -r)
    fi
    if grep "$rootuuid" "/etc/default/grub" | grep "$swapfileoffset" | grep "resume_offset" 2>&1 > /dev/null
    then
        >&2 echo "Grub is already configured"
    else
        echo 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT resume=UUID='$rootuuid' "resume_offset"='$swapfileoffset'"' >> /etc/default/grub
        sudo update-grub
    fi
    tests
}
install
