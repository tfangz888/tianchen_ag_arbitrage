//////////////////////  parameters  ///////////////////////////////////
HighMedianThrehold:2
LowMedianThrehold:2

///////////////////////////////////////////////////////////////////////////////
/ t:("ISFFFFFFF"; enlist ",") 0: `:e:/data/shi/condition/20200918.csv.2.cond
t:("ISFFFFFFF"; enlist ",") 0: `:/tmp/data/tmp.csv

qHighMedian: prev (t`qHigh)-(t`median)
qLowMedian: prev (t`median)-(t`qLow)

qHigher: (t`diff) > (prev t`qHigh) /当前处在qHigh之上
qLower: (t`diff) < (prev t`qLow)
enterSell: (qHighMedian>HighMedianThrehold) and qHigher and not prev qHigher /当前处在qHigh之上,上一次是在qHigh之下
enterBuy: (qLowMedian>LowMedianThrehold) and qLower and not prev qLower  /穿过qLow时买入

exitBuy: (t`diff) > (prev t`median)
exitBuy: exitBuy and not prev exitBuy /穿过或接触中间时平多
exitSell: (t`diff) < (prev t`median)
exitSell: exitSell and not prev exitSell /穿过或接触中间时平空

t: (select NR, sym, ask1, bid1 from t),'([]enterSell:enterSell; enterBuy:enterBuy; exitSell:exitSell; exitBuy:exitBuy)

`:/tmp/data/tmp.csv.sgl 0: csv 0: t

\\