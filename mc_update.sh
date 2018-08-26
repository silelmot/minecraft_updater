#!/bin/bash

link=$(wget -q https://minecraft.net/de-de/download/server -O - | \
	tr "\t\r\n'" '   "' | \
	grep -i -o '<a[^>]\+href[ ]*=[ \t]*"\(ht\|f\)tps\?:[^"]\+"' | \
	sed -e 's/^.*"\([^"]\+\)".*$/\1/g'| \
	grep 'server.jar')


version=$(echo $link | grep -o -P '(?<=game/).*(?=/server/)')

if [ $version != $(cat version.txt) ]; then
	echo $version > version.txt
	rm ./server.jar
	wget $link
	tmux kill-session -t minecraft
	sh start.sh

	#echo "link="$link
	echo "New Version "$version "installed and running!"
fi
