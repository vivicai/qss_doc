SELECT
	t1.ywrq,
	t1.cid,
	t2.khxm,
	t1.jys,
	p3.jysmc,
	p4.jysinfo,
	t1.yhdm,
	t1.qmje fvalue
FROM
	hub_tqs_qs_zjye_ls t1
INNER JOIN hub_tqs_khxx t2 ON t1.cid = t2.cid
LEFT JOIN hub_dd_tqs_jysxx p3 ON t1.jys = p3.jys
LEFT JOIN hub_ref_jysinfo p4 ON p3.jys = p4.jys
WHERE
	t1.ywrq = '20171112'