#! /bin/bash
YEAR=${1:-"2022"}
cd $YEAR
for d in */ ; do
  cd $d
  dart main.dart
  cd ..
done
cd ..