#!/bin/bash

DIR='/tmp/data/'
mkdir $DIR -p

for f in `ls $DIR`;
do
FILENAME=$DIR$f;
FILENAMETMP="$FILENAME.tmp"

printf "process $FILENAMETMP\n"

# delete first row
sed -i '1d' $FILENAME
sed -i 's/Ag(T+D)/AgTD/g' $FILENAME

# add row number
# awk 'print $2; $0=NR","$0' $FILENAME > $FILENAMETMP
nl -s ',' $FILENAME > $FILENAMETMP
mv $FILENAMETMP $FILENAME

# add header
cat /home/zhaogong/bin/agtd/header.txt $FILENAME > $FILENAMETMP
mv $FILENAMETMP $FILENAME

done

