#!/bin/bash

DIR='/media/sf_e/data/shi/ag_divide/'
OUTDIR='/media/sf_e/data/shi/condition/'

for f in `ls $DIR`;  
do   
FILENAME=$DIR$f;
printf "\n\n    process $FILENAME\n"
mkdir /tmp/data/ -p
cp $FILENAME /tmp/data/tmp.csv
rm /tmp/data/tmp.csv.con

q /media/sf_e/data/shi/condition.q

mv /tmp/data/tmp.csv.cond $OUTDIR${f}.cond

done