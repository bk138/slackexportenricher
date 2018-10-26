#!/bin/sh

set -e

if [ -z "$1" ] || [ -z "$2" ]
then
    echo "usage $0 <in.zip> <out.zip>"
    exit 1
fi


# unpack
rm -rf in
mkdir -p in
unzip "$1" -d in

rm -rf out
mkdir out

# make dirs
for D in $(find in -mindepth 1 -type d)
do
    mkdir  out/$(basename $D)
done

# copy root data
for F in $(find in -maxdepth 1 -type f)
do
    cp $F out/
done

cd in
# get channel json files
for J in $(find . -mindepth 2 -name \*.json)
do
	echo "processing $J"

	echo "[" >> ../out/$J

	COUNT=$(jshon -l < $J)
	I=0
	while [ $I -lt $COUNT ]
	do

	    MSG="$(jshon -e $I < $J)"

	    TEXT=$(/bin/echo $MSG | jshon -e text)

	    if [ "$TEXT" = '""' ]
	    then
		if echo $(/bin/echo $MSG | jshon -k) | grep -q files
		then
		    echo "   has files"
		    FILE_URLS="$(/bin/echo $MSG | jshon -e files -a -e url_private -u)"
		    MSG=$(/bin/echo $MSG | jshon -s $FILE_URLS -i text)
		fi
	    fi

	    /bin/echo $MSG >> ../out/$J

	    if [ $I -lt $(($COUNT - 1)) ]
	    then
	    	echo "," >> ../out/$J
	    fi

	    # go on
	    I=$(($I + 1))
	done 

	echo "]" >> ../out/$J
done

cd out
zip -r ../"$2" *
cd ..