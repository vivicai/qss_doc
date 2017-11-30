insert into insight_deposit_amount
SELECT
	t1.ywrq,
	t1.jys,
	p3.jysmc,
	p4.jysinfo,
	count(t1.bzj) fvalue
FROM
	hub_tqs_ccye_ls t1
LEFT JOIN hub_dd_tqs_jysxx p3 ON t1.jys = p3.jys
LEFT JOIN hub_ref_jysinfo p4 ON p3.jys = p4.jys
WHERE
	t1.ywrq = '20170426' 
GROUP BY
	t1.ywrq,
	t1.jys,
	p3.jysmc,
	p4.jysinfo

