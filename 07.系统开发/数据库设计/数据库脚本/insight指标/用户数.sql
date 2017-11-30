SELECT
	p5.qyrq,
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
	t1.agerange,
	count(1) as fvalue
FROM
	hub_tqs_khxx t1
INNER JOIN (
	SELECT
		jys,
		khh,
		qyrq
	FROM
		hub_tqs_zjzhdy 
	WHERE
		qyzt = 0
) p5 on t1.jys=p5.jys and t1.khh=p5.khh
LEFT JOIN hub_user_jingweidu p1 ON t1.zjbhsplit = p1.zjbhsplit
inner join hub_d_period p2 on p5.qyrq= p2."PERIOD_CODE"
left join hub_dd_tqs_jysxx p3 on t1.jys = p3.jys
left join hub_ref_jysinfo p4 on p3.jys=p4.jys
group by
	p5.qyrq,
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
  t1.agerange