#!/bin/bash

DIR='/media/sf_e/data/shi/signal/'
OUTDIR='/media/sf_e/data/shi/position/'

for f in `ls $DIR`;  
do   
FILENAME=$DIR$f;
printf "\n\n    process $FILENAME\n"
mkdir /tmp/data/ -p
cp $FILENAME /tmp/data/tmp.csv
rm /tmp/data/tmp.rawpos
rm /tmp/data/tmp.sympos

q /media/sf_e/data/shi/position.q

mv /tmp/data/tmp.rawpos $OUTDIR${f%*${f:(-4)}}.rawpos
mv /tmp/data/tmp.sympos $OUTDIR${f%*${f:(-4)}}.sympos # delete tail ".csv"

done