#! /bin/bash
IFS=';' read updates security_updates < <(/usr/lib/update-notifier/apt-check 2>&1);
# snap_reponse=$(snap refresh --list)
snap_reponse=$(LANG=en_EN.UTF-8 snap refresh --list 2> >(t_err=$(cat); echo $t_err) )
snapexit=$?
if ([ "$snap_reponse" != "All snaps up to date." ] && [[ $snapexit -eq 0 ]])
then
    updates=$(($updates+1))
fi
if [ -z "$updates" ]
then
    updates=0
fi

# echo $updates | tee /tmp/update-available
echo $updates > /tmp/update-available
