#!/bin/bash

DIR='/media/sf_e/data/shi/condition/'
OUTDIR='/media/sf_e/data/shi/signal/'

for f in `ls $DIR`;  
do   
FILENAME=$DIR$f;
printf "\n\n    process $FILENAME\n"
mkdir /tmp/data/ -p
cp $FILENAME /tmp/data/tmp.csv
rm /tmp/data/tmp.csv.con

q /media/sf_e/data/shi/signal.q

mv /tmp/data/tmp.csv.sgl $OUTDIR${f%*${f:(-5)}}.sgl # delete tail ".cond"

done