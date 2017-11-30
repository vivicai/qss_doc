insert into insight_settlement_price
SELECT
	'20170329' vday,
	t1.jys,
	p3.jysmc,
	p4.jysinfo,
	t1.cpdm,
	t1.cpmc,
	a3.cjjg fvalue
FROM
	hub_tqs_cpxx t1
LEFT JOIN hub_dd_tqs_jysxx p3 ON t1.jys = p3.jys
LEFT JOIN hub_ref_jysinfo p4 ON p3.jys = p4.jys
LEFT JOIN (
	SELECT
		a2.jys,
		a2.cpdm,
		a2.cjbh,
		a1.cjjg
	FROM
		hub_tqs_imp_cjls_ls a1
	INNER JOIN (
		SELECT
			ywrq,
			cpdm,
			jys,
			MAX (cjbh) cjbh
		FROM
			hub_tqs_imp_cjls_ls
		WHERE
			ywrq = '20170329'
		GROUP BY
			ywrq,
			cpdm,
			jys
	) a2 ON a1.cpdm = a2.cpdm
	AND a1.jys = a2.jys
	AND a1.cjbh = a2.cjbh
	AND a1.ywrq = a2.ywrq
	WHERE
		a1.kpbz_fqf = 1
) a3 ON t1.jys = a3.jys
AND t1.cpdm = a3.cpdm