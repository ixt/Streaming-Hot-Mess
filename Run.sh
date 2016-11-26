#!/usr/bin/env bash
SUBJECT=$(echo "$1" | sed -e "s/ /+/g")
FREQ=$(echo $2s)
SOURCE="https://www.youtube.com/results?q=intitle%3A%22$SUBJECT%22&sp=EgIIAQ%253D%253D"
COUNT=0
while true; do
    wget -O .page "$SOURCE"
    cat .page | sort | uniq | sed -n 's/.*\(\"\/watch?v=\w*\"\).*/\1/p' | sed -e "s/\"\/watch?v=//g" -e "s/\"//g" > .currentvideos
    rm .page
    cd videos
    while read entry; do
        if [ ! -e $entry.mp4 ]; then
            ../Download.sh $entry
            mpv $entry.mp4 --quiet --osc=no --geometry=$(($RANDOM % 100))%:$(($RANDOM % 100))% &
        fi
    done < ../.currentvideos
    cd ..
    ls ./videos -1 | sed -e 's/.mp4//g'  > .downloadedvideos
    while read downloaded; do
        if [ ! $(grep $downloaded .currentvideos) ]; then
            rm videos/$downloaded.mp4
        fi
    done < .downloadedvideos
    (( COUNT++ ))
    sleep $FREQ
    echo $COUNT
done

