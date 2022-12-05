#! /bin/bash
DAY=${1:-`date +%-d`} # 1st arg or current day
YEAR=${2:-`date +%Y`} # 2nd arg or current year

formattedDay=$(printf "%02d" $DAY)
folderPath="$YEAR/day$formattedDay"

mkdir -p $folderPath
aoc d --year $YEAR --day $DAY --input-only --input-file $folderPath/input.txt --overwrite
touch $folderPath/example_input.txt
cp main.dart.template $folderPath/main.dart
sed -i "s/<<YEAR>>/$YEAR/g;s/<<DAY>>/$DAY/g" $folderPath/main.dart
cd $folderPath
start chrome https://adventofcode.com/$YEAR/day/$DAY