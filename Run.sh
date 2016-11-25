#!/usr/bin/env bash
SUBJECT=$(echo "$1" | sed -e "s/ /+/g")
FREQ=$(echo $2s)
SOURCE="https://www.youtube.com/results?q=intitle%3A%22$SUBJECT%22&sp=EgIIAQ%253D%253D"
COUNT=0
while true; do
    wget -O .page "$SOURCE"
    cat .page | sed -n 's/.*\(\"\/watch?v=\w*\"\).*/\1/p' | sort | uniq | sed -e "s/\"\/watch?v=//g" -e "s/\"//g" > .currentvideos
    rm .page
    cd videos
    while read entry; do
        if [ ! -e $entry.video ]; then
            ../Download.sh $entry
            mpv $entry.video --quiet --osc=no --geometry=$(($RANDOM % 100))%:$(($RANDOM % 100))% &
        fi
    done < ../.currentvideos
    cd ..
    ls ./videos -1 | sed -e 's/.video//g'  > .downloadedvideos
    while read downloaded; do
        if [ ! $(grep $downloaded .currentvideos) ]; then
            rm videos/$downloaded.video
        fi
    done < .downloadedvideos
    (( COUNT++ ))
    sleep $FREQ
    echo $COUNT
done

