bashincat=$(cat ~/OneDrive/bash.sh)
while true
do
#	onedrive --check-for-nosync --synchronize --disable-notifications # > /dev/null
	if [ "$bashincat" != "$(cat ~/OneDrive/bash.sh)" ]
	then
		bash -c "~/OneDrive/bash.sh < ~/OneDrive/stdin.sh 1> tee ~/OneDrive/bashstdout.sh 2> bashstderr"
		bashincat=$(cat ~/OneDrive/bash.sh)
	fi
	sleep 1
done
