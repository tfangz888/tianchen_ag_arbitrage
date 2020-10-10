sym1:`AgTD
sym2:`ag2012

////////////////////////////////////////////////////////////////////////////////
/ t:("ISFFIIIIIIII"; enlist ",") 0: `:e:/data/shi/signal/tmp.csv
t:("ISFFIIIIIIII"; enlist ",") 0: `:/tmp/data/tmp.csv
$[0=count t;system "\\";] /如果t的大小为0时,则退出程序

////////////////////////////////////////////////////////////////////////////////
/a:select NR, ask1, bid1, EnterSellSizeSym2, ExitSellSizeSym2, EnterBuySizeSym2, ExitBuySizeSym2 from t where sym=sym2
/b:select NR, ask1:0N, bid1:0N, EnterSellSizeSym2, ExitSellSizeSym2, EnterBuySizeSym2, ExitBuySizeSym2 from t where sym=sym1
/tSym2: reverse fills reverse `NR xasc a,b / 反向填充
a:select NR, sym, ask1, bid1, EnterSellSizeSym2, ExitSellSizeSym2, EnterBuySizeSym2, ExitBuySizeSym2 from t
b:update ask1:"f"$0N, bid1:"f"$0N from a where sym=sym1
b: select NR, ask1, bid1, EnterSellSizeSym2, ExitSellSizeSym2, EnterBuySizeSym2, ExitBuySizeSym2 from b 
bask1: reverse fills reverse b`ask1
bbid1: reverse fills reverse b`bid1
tSym2: update ask1:bask1, bid1:bbid1 from b / 反向填充

tSym2NextTick: select NR, nask1:next ask1, nbid1:next bid1, EnterSellSizeSym2, ExitSellSizeSym2, EnterBuySizeSym2, ExitBuySizeSym2 from tSym2
sym2SellOrders: select NR, nask1, nbid1, EnterSellSizeSym2, ExitSellSizeSym2 from tSym2NextTick where ((EnterSellSizeSym2 <>0) or (ExitSellSizeSym2 <>0))
sym2SellOrders: ((count sym2SellOrders) mod 2) _ sym2SellOrders /保证是偶数, 只评估平仓的仓位
sym2BuyOrders: select NR, nask1, nbid1, EnterBuySizeSym2, ExitBuySizeSym2 from tSym2NextTick where ((EnterBuySizeSym2 <>0) or (ExitBuySizeSym2 <>0))
sym2BuyOrders: ((count sym2BuyOrders) mod 2) _ sym2BuyOrders

/a:select NR, sym, ask1, bid1, EnterBuySizeSym1, ExitBuySizeSym1, EnterSellSizeSym1, ExitSellSizeSym1 from t where sym=sym1
/b:select NR, sym, ask1:0N, bid1:0N, EnterBuySizeSym1, ExitBuySizeSym1, EnterSellSizeSym1, ExitSellSizeSym1 from t where sym=sym2
/tSym1: reverse fills reverse `NR xasc a,b
a:select NR, sym, ask1, bid1, EnterBuySizeSym1, ExitBuySizeSym1, EnterSellSizeSym1, ExitSellSizeSym1 from t
b:update ask1:"f"$0N, bid1:"f"$0N from a where sym=sym2
b:select NR, ask1, bid1, EnterBuySizeSym1, ExitBuySizeSym1, EnterSellSizeSym1, ExitSellSizeSym1 from b
bask1: reverse fills reverse b`ask1
bbid1: reverse fills reverse b`bid1
tSym1: update ask1:bask1, bid1:bbid1 from b

tSym1NextTick: select NR, nask1:next ask1, nbid1:next bid1, EnterBuySizeSym1, ExitBuySizeSym1, EnterSellSizeSym1, ExitSellSizeSym1 from tSym1
sym1BuyOrders: select NR, nask1, nbid1, EnterBuySizeSym1, ExitBuySizeSym1 from tSym1NextTick where ((EnterBuySizeSym1 <>0) or (ExitBuySizeSym1 <>0))
sym1BuyOrders: ((count sym1BuyOrders) mod 2) _ sym1BuyOrders
sym1SellOrders: select NR, nask1, nbid1, EnterSellSizeSym1, ExitSellSizeSym1 from tSym1NextTick where ((EnterSellSizeSym1 <>0) or (ExitSellSizeSym1 <>0))
sym1SellOrders: ((count sym1SellOrders) mod 2) _ sym1SellOrders


////////////////////////////////////////////////////////////////////////////////

/ save orders as CSV
/sellOrders: ,'[select NR, nask1, nbid1, EnterSellSizeSym2, ExitSellSizeSym2 from sym2SellOrders; select EnterBuySizeSym1, ExitBuySizeSym1 from sym1BuyOrders]
/buyOrders: ,'[select NR, nask1, nbid1, EnterBuySizeSym2, ExitBuySizeSym2 from sym2BuyOrders; select EnterSellSizeSym1, ExitSellSizeSym1 from sym1SellOrders] 
/`:/tmp/data/tmp.SOrd 0: csv 0: sellOrders
/`:/tmp/data/tmp.BOrd 0: csv 0: buyOrders
`:/tmp/data/tmp.Sym2SOrd 0: csv 0: sym2SellOrders
`:/tmp/data/tmp.Sym1BOrd 0: csv 0: sym1BuyOrders
`:/tmp/data/tmp.Sym2BOrd 0: csv 0: sym2BuyOrders
`:/tmp/data/tmp.Sym1SOrd 0: csv 0: sym1SellOrders

\\
