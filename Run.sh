#!/usr/bin/env bash
SUBJECT=$(echo "$1" | sed -e "s/ /+/g")
COUNT=0

helpText(){
    echo "Usage: ./Run.sh [OPTIONS]"
    echo "e.g. ./Run.sh -s \"Presentation\" -d 120"
    echo "  -s \"Search term\""
    echo "  -d Duration in seconds \(Default 60s\)"
    echo "  -h This text"
    echo "Use this utility to view view videos on as subject as they are uploaded"
    echo "Run.sh written by NfN Orange 2016, CC0"
    echo "Download Script written by Jacky Shih \<iluaster@gmail.com\> 2013 under GPLv2"
    echo "and futhur edited in 2016 by NfN Orange"
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        -s) shift
            SEARCHTERM="$(echo ${1} | sed -e "s/ /+/g")"
            ;;
        -d) shift
            DURATION="${1}"
            ;;
        -h) shift
            helpText
            ;;
         *)
            echo "Unknown ${1}"
            helpText
            exit 0
            ;;
    esac
    shift
done

SOURCE="https://www.youtube.com/results?q=intitle%3A%22$SEARCHTERM%22&sp=EgIIAQ%253D%253D"

while true; do
    wget -O .page "$SOURCE" -q --show-progress
    cat .page | uniq | sed -n 's/.*\(\"\/watch?v=\w*\"\).*/\1/p' | sed -e "s/\"\/watch?v=//g" -e "s/\"//g" > .currentvideos
    rm .page
    cd videos
    while read entry; do
        if [ ! -e $entry.mp4 ]; then
            ../Download.sh $entry
            totem --enqueue "$entry.mp4" &
        fi
    done < ../.currentvideos
    cd ..
    ls ./videos -1 | sed -e 's/.mp4//g'  > .downloadedvideos
    while read downloaded; do
        if [ $(grep -q $downloaded .currentvideos) ]; then
            rm videos/$downloaded.mp4
        fi
    done < .downloadedvideos
    (( COUNT++ ))
    sleep ${DURATION:-60}s
    echo "loop $COUNT"
done

