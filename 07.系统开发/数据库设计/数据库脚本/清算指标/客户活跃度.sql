-- 客户活跃度-按日
insert into insight_user_activation_day
SELECT
jykhs.ywrq,jykhs.jys,khs.jysmc,khs.jysinfo,round(jykhs.fvalue/khs.khs,4) as khhyd
FROM
	(
		SELECT
			t1.ywrq,
			t1.jys,
			COUNT (DISTINCT t1.kpbz_fqf) AS fvalue
		FROM
			hub_tqs_imp_cjls_ls t1
		WHERE
			t1.ywrq = '20170331'
		GROUP BY
			t1.ywrq,
			t1.jys
	) jykhs
INNER JOIN (
	SELECT
		t1.jys,
		t1.jysmc,
		t1.jysinfo,
		SUM (t1.fvalue) AS khs
	FROM
		insight_user_qty t1
	where t1.vday<='20170331'
		GROUP BY
		t1.jys,
		t1.jysmc,
		t1.jysinfo
) khs on jykhs.jys = khs.jys;

--客户活跃度按月
insert into insight_user_activation_month
SELECT
jykhs.ywrq,jykhs.jys,khs.jysmc,khs.jysinfo,round(jykhs.fvalue/khs.khs,4) as khhyd
FROM
	(
		SELECT
			substr(t1.ywrq, 1 ,6) ywrq,
			t1.jys,
			COUNT (DISTINCT t1.kpbz_fqf) AS fvalue
		FROM
			hub_tqs_imp_cjls_ls t1
		WHERE
			substr(t1.ywrq, 1 ,6) = '201703'
		GROUP BY
			t1.ywrq,
			t1.jys
	) jykhs
INNER JOIN (
	SELECT
		t1.jys,
		t1.jysmc,
		t1.jysinfo,
		SUM (t1.fvalue) AS khs
	FROM
		insight_user_qty t1
	where substr(t1.vday, 1 ,6)<='201703'
		GROUP BY
		t1.jys,
		t1.jysmc,
		t1.jysinfo
) khs on jykhs.jys = khs.jys;
