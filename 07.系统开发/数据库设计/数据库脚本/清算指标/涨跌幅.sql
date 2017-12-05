insert into insight_price_change
SELECT
	'20170331' vday,
	t1.jys,
	p3.jysmc,
	p4.jysinfo,
	t1.cpdm,
	t1.cpmc,
	case when COALESCE(a2.fvalue,0)=0 then 0 
		else round((COALESCE(a1.fvalue,0)-COALESCE(a2.fvalue,0))/COALESCE(a2.fvalue,0),4) end as fvalue -- 涨跌幅
FROM
	hub_tqs_cpxx t1
LEFT JOIN hub_dd_tqs_jysxx p3 ON t1.jys = p3.jys
LEFT JOIN hub_ref_jysinfo p4 ON p3.jys = p4.jys
left join 
(select t2.vday,t2.cpbm,t2.jys,t2.fvalue
 from insight_settlement_price t2 
where vday=to_char(to_date('20170331', 'yyyymmdd')+INTERVAL '-1 day','yyyymmdd')
) a1 on t1.jys=a1.jys and t1.cpdm=a1.cpbm-- T-1天结算价
left join 
(select t2.vday,t2.cpbm,t2.jys,t2.fvalue
 from insight_settlement_price t2 
where vday=to_char(to_date('20170331', 'yyyymmdd')+INTERVAL '-2 day','yyyymmdd')
) a2 on t1.jys=a2.jys and t1.cpdm=a2.cpbm -- T-2天结算价
