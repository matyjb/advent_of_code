#! /bin/bash
YEAR=${1:-`date +%Y`}
cd $YEAR
for d in */ ; do
  cd $d
  dart main.dart
  cd ..
done
cd ..