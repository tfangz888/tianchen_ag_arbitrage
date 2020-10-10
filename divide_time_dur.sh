#!/bin/bash

DIR='/media/sf_e/data/shi/ag/'
OUTDIR='/media/sf_e/data/shi/ag_divide/'

for f in `ls $DIR`;  
do   
FILENAME=$DIR$f;
printf "\n\n    process $FILENAME\n"
mkdir /tmp/data/ -p
cp $FILENAME /tmp/data/tmp.csv
rm /tmp/data/tmp1.csv
rm /tmp/data/tmp2.csv
rm /tmp/data/tmp3.csv
rm /tmp/data/tmp4.csv

q /media/sf_e/data/shi/divide_time_dur.q

mv /tmp/data/tmp1.csv $OUTDIR${f}.1
mv /tmp/data/tmp2.csv $OUTDIR${f}.2
mv /tmp/data/tmp3.csv $OUTDIR${f}.3
mv /tmp/data/tmp4.csv $OUTDIR${f}.4

done