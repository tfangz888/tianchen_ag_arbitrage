/ t:("ID**SFFFFFFFI*IFFFF**TIFIFIFIFIFIFIFIFIFIFIF"; enlist ",") 0: `:e:/data/shi/tmp.csv
t:("ID**SFFFFFFFI*IFFFF**TIFIFIFIFIFIFIFIFIFIFIF"; enlist ",") 0: `:/tmp/data/tmp.csv
t:select from t where sym in `AgTD`ag2012
t0:select from t where ((time > 21:00:00) and (time < 24:00:00))
t1:select from t where ((time > 00:00:00) and (time < 02:30:00))

t2:select from t where ((time > 09:00:00) and (time < 10:15:00))
t3:select from t where ((time > 10:30:00) and (time < 11:30:00))
t4:select from t where ((time > 13:30:00) and (time < 15:00:00))

/`:e:/data/shi/tmp1.csv 0: csv 0: `NR xasc t0,t1
/`:e:/data/shi/tmp2.csv 0: csv 0: `NR xasc t2
/`:e:/data/shi/tmp3.csv 0: csv 0: `NR xasc t3
/`:e:/data/shi/tmp4.csv 0: csv 0: `NR xasc t4
`:/tmp/data/tmp1.csv 0: csv 0: `NR xasc t0,t1
`:/tmp/data/tmp2.csv 0: csv 0: `NR xasc t2
`:/tmp/data/tmp3.csv 0: csv 0: `NR xasc t3
`:/tmp/data/tmp4.csv 0: csv 0: `NR xasc t4
\\
