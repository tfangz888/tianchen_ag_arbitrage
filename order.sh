#!/bin/bash

DIR='/media/sf_e/data/shi/position/'
OUTDIR='/media/sf_e/data/shi/order/'

for f in `ls ${DIR}*.sympos |xargs -n 1 basename`;  
do   
FILENAME=$DIR$f;
printf "\n\n    process $FILENAME\n"
mkdir /tmp/data/ -p
cp $FILENAME /tmp/data/tmp.csv
rm /tmp/data/tmp.Sym2SOrd
rm /tmp/data/tmp.Sym1BOrd
rm /tmp/data/tmp.Sym2BOrd
rm /tmp/data/tmp.Sym1SOrd

q /media/sf_e/data/shi/order.q

mv /tmp/data/tmp.Sym2SOrd $OUTDIR${f%*${f:(-7)}}.Sym2SOrd
mv /tmp/data/tmp.Sym1BOrd $OUTDIR${f%*${f:(-7)}}.Sym1BOrd
mv /tmp/data/tmp.Sym2BOrd $OUTDIR${f%*${f:(-7)}}.Sym2BOrd
mv /tmp/data/tmp.Sym1SOrd $OUTDIR${f%*${f:(-7)}}.Sym1SOrd

done