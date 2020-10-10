//////////////////////  parameters  ///////////////////////////////////
sym1:`AgTD
sym2:`ag2012
zeroTicks: 6 * 60 * 8 / 5min * 60sec * 8ticks/sec   /必须大于condition.q中的参数backTicks

///////////////////////////////////////////////////////////////////////////////
/ t:("ISFFIIII"; enlist ",") 0: `:e:/data/shi/signal/20200921.csv.1.sgl
t:("ISFFIIII"; enlist ",") 0: `:/tmp/data/tmp.csv
$[0=count t;system "\\";] /如果t的大小为0时,则退出程序

//////////////// 先对前面几分种的信号清零  ////////////////////////////////////
initialValues:zeroTicks#0
enterSell: {a:t `enterSell;a[til zeroTicks]:initialValues;neg a}[] /开空为-1
enterBuy: {a:t `enterBuy;a[til zeroTicks]:initialValues;a}[]
////////////////  把第一次开仓前的平仓信号全部清零   //////////////////////////
initialExitSellValues: {a:first where enterSell <>0; a:$[0N=a;count enterSell; a+1]; b:min (a; count enterSell); b#0}[] / if 取最小值
initialExitBuyValues: {a:first where enterBuy <>0; a:$[0N=a;count enterBuy; a+1]; b:min (a; count enterBuy); b#0}[]
exitSell: {a:t `exitSell;a[til (count initialExitSellValues)]:initialExitSellValues;a}[]
exitBuy: {a:t `exitBuy;a[til (count initialExitBuyValues)]:initialExitBuyValues;neg a}[] /平多为-1

//////////////// 闭市前不开仓. 并保证最后几个TICK把所有的仓以市价平掉   ////////
/ TODO

t12:([]NR:t `NR; sym:t `sym; ask1:t `ask1; bid1:t `bid1;enterSell:enterSell;enterBuy:enterBuy;exitSell:exitSell;exitBuy:exitBuy)
///////////// 调整仓位，去掉连续的开仓  ///////////////////////////////////////
//  https://blog.neueda.com/kdb/kdb-iterators-for-dummies/
/ 多单仓位调整。一次只持有一个仓位。连续的开仓或平仓信号会被忽略。
/ 上次的多单没平仓，不会再开新仓。如果没有持仓，不会产生平仓
buyAdjustSizeFunc:{sumSize:x[0]+y+z; y:$[sumSize=2;y-1;y];z:$[sumSize=-1;z+1;z];sumSize:x[0]+y+z;"i"$(sumSize;y;z)}

/ 返回三列，第一列为持仓状态，仓位加总和，只能为空仓0或持仓1。
/ 第二列为调整后的开多动作，为1表示开多仓。0表示不操作。
/ 第三列为平多动作，为-1表示平掉先前的多仓。0表示不操作
/ buyAdjustSizeFunc \[0 0 0; enterBuyList; exitBuyList] 

sellAdjustSizeFunc:{sumSize:x[0]+y+z; y:$[sumSize=-2;y+1;y];z:$[sumSize=1;z-1;z];sumSize:x[0]+y+z;"i"$(sumSize;y;z)}

/ 返回三列，第一列为持仓状态，仓位加总和，只能为空仓0或持仓-1。
/ sellAdjustSizeFunc \[0 0 0; enterSellList; exitSellList] 


a:buyAdjustSizeFunc  \[0 0 0; t12 `enterBuy; t12 `exitBuy] 
b:sellAdjustSizeFunc \[0 0 0; t12 `enterSell; t12 `exitSell] 
update enterBuy:a[;1], exitBuy:a[;2], buyHoldings:a[;0], enterSell:b[;1], exitSell:b[;2], sellHoldings:b[;0] from `t12
/ save t12 as CSV
`:/tmp/data/tmp.rawpos 0: csv 0: t12

////////////////////////////////////////////////////////////////////////////////
/ enterSell开空时: enterSell sym2, enterBuy  sym1
/ exitSell平空时:  exitSell  sym2, exitBuy   sym1
/ enterBuy开多时:  enterBuy  sym2, enterSell sym1
/ exitBuy平多时:   exitBuy   sym2, exitSell  sym1

/ enterSell
EnterSellSizeSym2: t12 `enterSell
EnterBuySizeSym1: neg t12 `enterSell
/ exitSell
ExitSellSizeSym2: t12 `exitSell
ExitBuySizeSym1: neg t12 `exitSell

/ enterBuy
EnterBuySizeSym2: t12 `enterBuy
EnterSellSizeSym1: neg t12 `enterBuy
/ exitBuy
ExitBuySizeSym2: t12 `exitBuy
ExitSellSizeSym1: neg t12 `exitBuy

t13: select NR, sym, ask1, bid1, EnterSellSizeSym2:EnterSellSizeSym2, EnterBuySizeSym1:EnterBuySizeSym1, ExitSellSizeSym2:ExitSellSizeSym2, ExitBuySizeSym1:ExitBuySizeSym1, EnterBuySizeSym2:EnterBuySizeSym2, EnterSellSizeSym1:EnterSellSizeSym1, ExitBuySizeSym2:ExitBuySizeSym2, ExitSellSizeSym1:ExitSellSizeSym1 from t12
/ save t13 as CSV
`:/tmp/data/tmp.sympos 0: csv 0: t13

\\