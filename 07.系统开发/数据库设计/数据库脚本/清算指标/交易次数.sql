insert into insight_transaction_frequence
SELECT
	t1.ywrq,
	t2.cid,
	t2.khxm,
	t1.jys,
	p3.jysmc,
	p4.jysinfo,
	count(t1.khh_fqf) fvalue
FROM
	hub_tqs_imp_cjls_ls t1
INNER JOIN hub_tqs_khxx t2 ON t1.jys=t2.jys and t1.khh_fqf = t2.khh
LEFT JOIN hub_dd_tqs_jysxx p3 ON t1.jys = p3.jys
LEFT JOIN hub_ref_jysinfo p4 ON p3.jys = p4.jys
WHERE
	t1.ywrq = '20170331' 
GROUP BY
	t1.ywrq,
	t2.cid,
	t2.khxm,
	t1.jys,
	p3.jysmc,
	p4.jysinfo