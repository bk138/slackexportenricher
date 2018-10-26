#!/bin/sh

# unpack
#unzip "$1"

rm -rf out
mkdir out

# get channel json files
for J in $(find . -mindepth 2 -name \*.json)
do
	echo "processing $J"

	mkdir -p out/$(dirname $J)

	echo "[" >> out/$J

	COUNT=$(jshon -l < $J)
	I=0
	while [ $I -lt $COUNT ]
	do

	    MSG="$(jshon -e $I < $J)"

	    TEXT=$(/bin/echo $MSG | jshon -e text)

	    if [ "$TEXT" = '""' ]
	    then
		echo "  empty"
		if echo $(/bin/echo $MSG | jshon -k) | grep -q files
		then
		    echo "   has files"
		    FILE_URLS="$(/bin/echo $MSG | jshon -e files -a -e url_private)"
		    MSG=$(/bin/echo $MSG | jshon -s $FILE_URLS -i text)
		fi
	    fi

	    /bin/echo $MSG >> out/$J

	    if [ $I -lt $(($COUNT - 1)) ]
	    then
	    	echo "," >> out/$J
	    fi

	    # go on
	    I=$(($I + 1))
	done 

	echo "]" >> out/$J
done
