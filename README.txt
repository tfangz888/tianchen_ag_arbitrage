ag目录下的文件
在原数据的文件基础上：
1. 替换header为英文
2. 添加行号
3. 替换Ag(T+D)为AgTD

ag_divide目录下的文件
在ag目录的基础上：
1. 去掉了除AgTD, ag2012之外的其它品种
2. 把一天的文件分成4个时间段，文件结尾的1，2，3，4分别代表了这4个时间段
   1) 21:00:00 < time < 24:00:00， 00:00:00 < time < 02:30:00, 零点时有不想要的数据
   2) 09:00:00 < time < 10:15:00
   3) 10:30:00 < time < 11:30:00
   4) 13:30:00 < time < 15:00:00
   以上不包含整点数据