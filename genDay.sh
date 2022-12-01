#! /bin/bash
YEAR=$1
DAY=$2

formattedDay=$(printf "%02d" $DAY)
folderPath="$YEAR/day$formattedDay"

mkdir -p $folderPath
touch $folderPath/input.txt
touch $folderPath/example_input.txt
cp main_template.txt $folderPath/main.dart
sed -i "s/<<YEAR>>/$YEAR/g;s/<<DAY>>/$DAY/g" $folderPath/main.dart
