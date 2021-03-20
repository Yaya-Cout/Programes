boucle () {
$@ | while read directory
do
	cd "$directory"
	cd ../
	echo "$directory"
	git config pull.rebase false
	git pull > /dev/null
	#git push > /dev/null
	cd "$1"
done
}
find "$1" -name .git 2> /dev/null | boucle
ls "$1" -w1 | boucle
