#! /bin/bash
IFS=';' read updates security_updates < <(/usr/lib/update-notifier/apt-check 2>&1);
# snap_reponse=$(snap refresh --list)
snap_reponse=$(snap refresh --list 2> >(t_err=$(cat); echo $t_err) )
if [ "$snap_reponse" != "Tous les paquets Snaps sont à jour." ]
then
    if (("$updates" < "1"))
    then
        updates=1
    fi
fi
if [ -z "$updates" ]
then
    updates=0
fi

# echo $updates | tee /tmp/update-available
echo $updates > /tmp/update-available

