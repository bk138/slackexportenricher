#!/bin/sh

if [ -z "$1" ]
then
    echo gimme archive
    exit 1
fi

# unpack
unzip "$1"

rm -rf /tmp/see-out
mkdir /tmp/see-out

# get channel json files
for J in $(find . -mindepth 2 -name \*.json)
do
	echo "processing $J"

	mkdir -p /tmp/see-out/$(dirname $J)

	echo "[" >> /tmp/see-out/$J

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

	    /bin/echo $MSG >> /tmp/see-out/$J

	    if [ $I -lt $(($COUNT - 1)) ]
	    then
	    	echo "," >> /tmp/see-out/$J
	    fi

	    # go on
	    I=$(($I + 1))
	done 

	echo "]" >> /tmp/see-out/$J
done
