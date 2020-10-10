dir: "/media/sf_e/data/shi/order/"
files: system "ls /media/sf_e/data/shi/order/"
files:distinct 14#'files
tSym2Sell:()
tSym2Buy:()
tSym1Buy:()
tSym1Sell:()

profit:{[file] 
  date:8#file;
  date:"I"$date;
  
  sym2SellOrderFile: dir,file,".Sym2SOrd";
  sym1BuyOrderFile: dir,file,".Sym1BOrd";
  sym2BuyOrderFile: dir,file,".Sym2BOrd";
  sym1SellOrderFile: dir,file,".Sym1SOrd";
  
  sym2SellOrders:("IFFIIII"; enlist ",") 0: "S"$sym2SellOrderFile;
  sym1BuyOrders:("IFFIIII"; enlist ",") 0: "S"$sym1BuyOrderFile;
  sym2BuyOrders:("IFFIIII"; enlist ",") 0: "S"$sym2BuyOrderFile;
  sym1SellOrders:("IFFIIII"; enlist ",") 0: "S"$sym1SellOrderFile;
  
  ////////////////////////////   calculate profit   //////////////////////
  a:(sym2SellOrders `nbid1)*(sym2SellOrders `EnterSellSizeSym2);
  b:(sym2SellOrders `nask1)*(sym2SellOrders `ExitSellSizeSym2);
  sym2SellProfit: neg (a+b) ;
  sym2SellProfitTotal: sum sym2SellProfit;
  sym2SellNrOfOrders: (count sym2SellOrders) div 2;
  sym2SellProfitAvg: sym2SellProfitTotal % sym2SellNrOfOrders;
  
  a:(sym2BuyOrders `nask1)*(sym2BuyOrders `EnterBuySizeSym2);
  b:(sym2BuyOrders `nbid1)*(sym2BuyOrders `ExitBuySizeSym2);
  sym2BuyProfit: neg (a+b);
  sym2BuyProfitTotal: sum sym2BuyProfit;
  sym2BuyNrOfOrders: (count sym2BuyOrders) div 2;
  sym2BuyProfitAvg: sym2BuyProfitTotal % sym2BuyNrOfOrders;
  
  a:(sym1BuyOrders `nask1)*(sym1BuyOrders `EnterBuySizeSym1);
  b:(sym1BuyOrders `nbid1)*(sym1BuyOrders `ExitBuySizeSym1);
  sym1BuyProfit: neg (a+b);
  sym1BuyProfitTotal: sum sym1BuyProfit;
  sym1BuyNrOfOrders: (count sym1BuyOrders) div 2;
  sym1BuyProfitAvg: sym1BuyProfitTotal % sym1BuyNrOfOrders;
  
  a:(sym1SellOrders `nbid1)*(sym1SellOrders `EnterSellSizeSym1);
  b:(sym1SellOrders `nask1)*(sym1SellOrders `ExitSellSizeSym1);
  sym1SellProfit: neg (a+b) ;
  sym1SellProfitTotal: sum sym1SellProfit;
  sym1SellNrOfOrders: (count sym1SellOrders) div 2;
  sym1SellProfitAvg: sym1SellProfitTotal % sym1SellNrOfOrders;
  
  //   save profits as CSV
  / date, sym2BuyProfitTotal, sym2BuyNrOfOrders, sym2BuyProfitAvg
  / date, sym1SellProfitTotal, sym1SellNrOfOrders, sym1SellProfitAvg
  tSym2SellProfit:([]date:enlist date; sym2SellProfitTotal:enlist sym2SellProfitTotal; sym2SellNrOfOrders:enlist sym2SellNrOfOrders; sym2SellProfitAvg:enlist sym2SellProfitAvg);
  tSym2BuyProfit:([]date:enlist date; sym2BuyProfitTotal:enlist sym2BuyProfitTotal; sym2BuyNrOfOrders:enlist sym2BuyNrOfOrders; sym2BuyProfitAvg:enlist sym2BuyProfitAvg);
  tSym1BuyProfit:([]date:enlist date; sym1BuyProfitTotal:enlist sym1BuyProfitTotal; sym1BuyNrOfOrders:enlist sym1BuyNrOfOrders; sym1BuyProfitAvg:enlist sym1BuyProfitAvg);
  tSym1SellProfit:([]date:enlist date; sym1SellProfitTotal:enlist sym1SellProfitTotal; sym1SellNrOfOrders:enlist sym1SellNrOfOrders; sym1SellProfitAvg:enlist sym1SellProfitAvg);
  tSym2Sell:: tSym2Sell, tSym2SellProfit;
  tSym2Buy:: tSym2Buy, tSym2BuyProfit;
  tSym1Buy:: tSym1Buy, tSym1BuyProfit;
  tSym1Sell:: tSym1Sell, tSym1SellProfit;
  }

profit each files

`:/media/sf_e/data/shi/analysis/Sym2SellProfit.csv 0: csv 0: tSym2Sell
`:/media/sf_e/data/shi/analysis/Sym2BuyProfit.csv 0: csv 0: tSym2Buy
`:/media/sf_e/data/shi/analysis/Sym1BuyProfit.csv 0: csv 0: tSym1Buy
`:/media/sf_e/data/shi/analysis/Sym1SellProfit.csv 0: csv 0: tSym1Sell

