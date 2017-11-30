-- 客户活跃度-按日
SELECT
jykhs.cjsj,jykhs.jys,khs.jysmc,khs.jysinfo,round(jykhs.fvalue/khs.khs,4) as khhyd
FROM
	(
		SELECT
			t1.cjsj,
			t1.jys,
			COUNT (DISTINCT t1.kpbz_fqf) AS fvalue
		FROM
			hub_tqs_imp_cjls_ls t1
		WHERE
			t1.cjsj = '20171112'
		GROUP BY
			t1.cjsj,
			t1.jys
	) jykhs
INNER JOIN (
	SELECT
		t1.vday,
		t1.jys,
		t1.jysmc,
		t1.jysinfo,
		SUM (t1.fvalue) AS khs
	FROM
		insight_user_qty t1
	where t1.vday='20171112'
		GROUP BY
		t1.vday,
		t1.jys,
		t1.jysmc,
		t1.jysinfo
) khs on jykhs.cjsj=khs.vday and jykhs.jys = khs.jys;

--客户活跃度按月
SELECT
jykhs.cjsj,jykhs.jys,khs.jysmc,khs.jysinfo,round(jykhs.fvalue/khs.khs,4) as khhyd
FROM
	(
		SELECT
			substr(t1.cjsj, 1 ,6) cjsj,
			t1.jys,
			COUNT (DISTINCT t1.kpbz_fqf) AS fvalue
		FROM
			hub_tqs_imp_cjls_ls t1
		WHERE
			substr(t1.cjsj, 1 ,6) = '201711'
		GROUP BY
			substr(t1.cjsj, 1 ,6),
			t1.jys
	) jykhs
INNER JOIN (
	SELECT
		substr(t1.vday, 1 ,6) vday,
		t1.jys,
		t1.jysmc,
		t1.jysinfo,
		SUM (t1.fvalue) AS khs
	FROM
		insight_user_qty t1
	where substr(t1.vday, 1 ,6)='20171112'
	GROUP BY
		substr(t1.vday, 1 ,6),
		t1.jys,
		t1.jysmc,
		t1.jysinfo
) khs on jykhs.cjsj=khs.vday and jykhs.jys = khs.jys