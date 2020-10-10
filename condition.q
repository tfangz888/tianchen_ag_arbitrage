sym1:`AgTD
sym2:`ag2012
backTicks: 5 * 60 * 8 / 5min * 60sec * 8ticks/sec   /参数
lowPercentile:0.1
highPercentile:1-lowPercentile

//////////////////////////////////////////////////////////////////////////////////////////////
/ t:("ID**SFFFFFFFI*IFFFF**TIFIFIFIFIFIFIFIFIFIFIF"; enlist ",") 0: `:e:/data/shi/20200921.csv.1
t:("ID**SFFFFFFFI*IFFFF**TIFIFIFIFIFIFIFIFIFIFIF"; enlist ",") 0: `:/tmp/data/tmp.csv

t1: select NR, sym, arithMeanP: ((ask1 * bsize1) + (bid1 * asize1)) % (bsize1+asize1) from t

a:select NR, arithMeanP from t1 where sym=sym2
b:select NR, arithMeanP:0N from t1 where sym=sym1
tSym2: fills `NR xasc a,b / 正向填充
/ tSym2:reverse 1_ fills reverse tSym2 /去掉最后一个, 并填充, 好象不对
a:select NR, arithMeanP from t1 where sym=sym1
b:select NR, arithMeanP:0N from t1 where sym=sym2
tSym1:fills `NR xasc a,b
/ tSym1:reverse 1_ fills reverse tSym1 /去掉最后一个, 并填充, 好象不对

diff:(`NR xkey tSym2) - (`NR xkey tSym1)
diff:`NR`diff xcol diff /改key名字
/ () xkey diff

mmed: {[num;ys] med each {1_x,y}\[num#0;ys]}
diffMedian: select NR, median:mmed [backTicks; diff] from diff
// prevMedian:prev diffMedian `median

percentile:{r[0]+(p-i 0)*last r:0^deltas asc[x]i:0 1+\:floor p:y*-1+count x}
qHigh: percentile[;highPercentile]
qLow: percentile[;lowPercentile]
mqHigh:{[num;ys] qHigh each {1_x,y}\[num#0;ys]}
mqLow:{[num;ys] qLow each {1_x,y}\[num#0;ys]}
/ mqHigh[5; til 100]
diffMqHigh: select NR, qHigh:mqHigh [backTicks; diff] from diff
// prevMqHigh:prev diffMqHigh `qHigh
diffMqLow: select NR, qLow:mqLow [backTicks; diff] from diff
// prevMqLow:prev diffMqLow `qLow

////////////////////    save into csv          /////////////////////////////////
t:(select NR, sym, ask1, bid1 from t),'(select arithMeanP from t1),'(select diff from diff),'(select qLow from diffMqLow),'(select median from diffMedian),' (select qHigh from diffMqHigh)
/ `:e:/data/shi/tmp.csv.cond 0: csv 0: t
`:/tmp/data/tmp.csv.cond 0: csv 0: t

\\