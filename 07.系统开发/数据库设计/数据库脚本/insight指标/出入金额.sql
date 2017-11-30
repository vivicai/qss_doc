select 
	clrq,
	cid,
	khxm,
	jys,
	jysmc,
	jysinfo,
	fvalue,
	fvalue1,
	fvalue-fvalue1 as fvalue2,
	fvalue3,
	fvalue4
from 
(
SELECT
	t1.clrq,
	t2.cid,
	t2.khxm,
	t1.jys,
	p3.jysmc,
	p4.jysinfo,
	sum(case when t1.xtywdm=1 then t1.zzje else 0 end) fvalue,-- 入金
sum(case when t1.xtywdm=2 then t1.zzje else 0 end) fvalue1,-- 出金
	sum(case when t1.xtywdm=1 then 1 else 0 end) fvalue3,-- 入金次数
sum(case when t1.xtywdm=2 then 1 else 0 end) fvalue4-- 出金次数
FROM
	hub_tqs_zjjysq_ls t1
INNER JOIN hub_tqs_khxx t2 ON t1.jys=t2.jys and t1.khh = t2.khh
LEFT JOIN hub_dd_tqs_jysxx p3 ON t1.jys = p3.jys
LEFT JOIN hub_ref_jysinfo p4 ON p3.jys = p4.jys
WHERE
	t1.clrq = '20170304' and t1.cljg='111'
group BY
	t1.clrq,
	t2.cid,
	t2.khxm,
	t1.jys,
	p3.jysmc,
	p4.jysinfo
) p5