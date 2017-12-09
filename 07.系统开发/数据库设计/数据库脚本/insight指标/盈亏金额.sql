--非华银
-- 发售和转让
select 
to_char(now(),'yyyymmdd') vday,
t1.cid,
t2.khxm,
t1.jys,
	p3.jysmc,
	p4.jysinfo,
(a1.fvalue+a2.fvalue)-(a3.fvalue+a4.fvalue)-a5.fvalue2 as fvalue--盈亏金额
 from (	
SELECT DISTINCT
		jys,
		cid,
		khh
	FROM
		hub_tqs_zjzhdy 
	WHERE
		qyzt = 0 and jys<>'0003') t1
INNER JOIN hub_tqs_khxx t2 ON t1.jys = t2.jys AND t1.khh = t2.khh
LEFT JOIN hub_dd_tqs_jysxx p3 ON t1.jys = p3.jys
LEFT JOIN hub_ref_jysinfo p4 ON p3.jys = p4.jys
inner join hub_dd_tqs_jys p5 on p3.jys = p5.jys and p5.jyms in ('01','07')
left join insight_sendimentary_amount a1 on t1.jys=a1.jys and t1.cid=a1.cid and a1.vday=to_char(now() + interval '-1 day','yyyymmdd')--T-1期末资金
left JOIN insight_position_amount a2 on t1.jys=a2.jys and t1.cid=a2.cid and a2.vday=to_char(now() + interval '-1 day','yyyymmdd')--T-1持仓金额
left join insight_sendimentary_amount a3 on t1.jys=a3.jys and t1.cid=a3.cid and a3.vday=to_char(now() + interval '-2 day','yyyymmdd')--T-1期末资金
left JOIN insight_position_amount a4 on t1.jys=a4.jys and t1.cid=a4.cid and a4.vday=to_char(now() + interval '-2 day','yyyymmdd')--T-1持仓金额
left JOIN insight_in_out_amount a5 on t1.jys=a5.jys and t1.cid=a5.cid and a5.vday=to_char(now() + interval '-1 day','yyyymmdd')--T-1净入金
-- OTC
union ALL
select 
to_char(now(),'yyyymmdd') vday,
t1.cid,
t2.khxm,
t1.jys,
	p3.jysmc,
	p4.jysinfo,
a1.fvalue-a3.fvalue-a5.fvalue2 as fvalue--OTC盈亏金额
 from (	
SELECT DISTINCT
		jys,
		cid,
		khh
	FROM
		hub_tqs_zjzhdy 
	WHERE
		qyzt = 0 and jys<>'0003') t1
INNER JOIN hub_tqs_khxx t2 ON t1.jys = t2.jys AND t1.khh = t2.khh
LEFT JOIN hub_dd_tqs_jysxx p3 ON t1.jys = p3.jys
LEFT JOIN hub_ref_jysinfo p4 ON p3.jys = p4.jys
inner join hub_dd_tqs_jys p5 on p3.jys = p5.jys and p5.jyms='02'
left join insight_sendimentary_amount a1 on t1.jys=a1.jys and t1.cid=a1.cid and a1.vday=to_char(now() + interval '-1 day','yyyymmdd')--T-1期末资金
left join insight_sendimentary_amount a3 on t1.jys=a3.jys and t1.cid=a3.cid and a3.vday=to_char(now() + interval '-2 day','yyyymmdd')--T-2期末资金
left JOIN insight_in_out_amount a5 on t1.jys=a5.jys and t1.cid=a5.cid and a5.vday=to_char(now() + interval '-1 day','yyyymmdd')--T-1净入金