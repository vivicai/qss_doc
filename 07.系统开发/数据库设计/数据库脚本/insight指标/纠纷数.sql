SELECT
	to_char(t1.insert_date,'yyyymmdd') as jfrq,
	p2."PERIOD_YEAR_MONTH",
	p1.weidu,
	p1.jingdu,
	p1.country,
	p1.area,
	p1.province,
	p1.city,
	t1.jys,
	p3.jysmc,
	p4.jysinfo,
	t1.status,
	count(1) as fvalue
FROM
	hub_user_issue_list t1
inner join hub_tqs_khxx p6 on t1.jys=p6.jys and t1.cust_id=p6.khh
LEFT JOIN hub_user_jingweidu p1 ON p6.zjbhsplit = p1.zjbhsplit
inner join hub_d_period p2 on to_char(t1.insert_date,'yyyymmdd')= p2."PERIOD_CODE"
left join hub_dd_tqs_jysxx p3 on t1.jys = p3.jys
left join hub_ref_jysinfo p4 on p3.jys=p4.jys
group by
	to_char(t1.insert_date,'yyyymmdd'),
	p2."PERIOD_YEAR_MONTH",
	p1.weidu,
	p1.jingdu,
	p1.country,
	p1.area,
	p1.province,
	p1.city,
	t1.jys,
	p3.jysmc,
	p4.jysinfo,
	t1.status