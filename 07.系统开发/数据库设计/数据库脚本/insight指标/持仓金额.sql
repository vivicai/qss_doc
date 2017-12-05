SELECT
	t1.ywrq,
	t2.cid,
	t2.khxm,
	t1.jys,
	p3.jysmc,
	p4.jysinfo,
	t1.cpdm,
	p5.cpmc,
	t1.ccjg * t1.ccsl fvalue,
	t1.ccsl fvalue1,
	t1.ccjg fvalue2
FROM
	hub_tqs_imp_ccmx_ls t1
INNER JOIN hub_tqs_khxx t2 ON t1.jys = t2.jys AND t1.khh = t2.khh
LEFT JOIN hub_dd_tqs_jysxx p3 ON t1.jys = p3.jys
LEFT JOIN hub_ref_jysinfo p4 ON p3.jys = p4.jys
LEFT JOIN hub_tqs_cpxx p5 ON t1.jys = p5.jys
AND t1.cpdm = p5.cpdm
WHERE
	t1.ywrq = '20170428'
