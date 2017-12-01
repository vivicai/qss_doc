/**
频繁交易
**/
INSERT INTO hub_fxsj (
	bjsj,
	fxlb,
	fxzb,
	fxzbz,
	yuzhi,
	cce,
	jgdm,
	jgmc,
	cust_id,
	khmc,
	ywcdbm,
	ywcdmc,
	ywlx,
	ywbm,
	fxsj_id,
	unit
)
SELECT
	to_char(
		(SELECT now() :: TIMESTAMP),
		'yyyyMMdd HH24:mm:ss'
	) AS bjsj,
	--报警时间
	'交易风险' AS fxlb,
	--风险类别
	'频繁交易' AS fxzb,
	--风险指标
	zjzhdy.nums AS fxzbz,
	--风险指标值
	CASE
WHEN zjzhdy.nums <= 40 THEN
	20
WHEN zjzhdy.nums > 40
AND zjzhdy.nums <= 60 THEN
	40
ELSE
	60
END AS yuzhi,
 --阈值
CASE
WHEN zjzhdy.nums <= 40 THEN
	round(
		(zjzhdy.nums :: NUMERIC - 20) / 20 * 100,
		2
	)
WHEN zjzhdy.nums > 40
AND zjzhdy.nums <= 60 THEN
	round(
		(zjzhdy.nums :: NUMERIC - 40) / 40 * 100,
		2
	)
ELSE
	round(
		(zjzhdy.nums :: NUMERIC - 60) / 60 * 100,
		2
	)
END AS cce,
 --超出额
zjzhdy.jys AS jgdm,
 --机构代码
zjzhdy.jysmc AS jgmc,
 --机构名称
'' AS cust_id,
 --客户号
'' AS khmc,
 --客户名称
'JYXX' AS ywcdbm,
 --业务菜单编码
'交易信息' AS ywcdmc,
 --业务菜单名称
'客户号' AS ywlx,
 --业务类型
zjzhdy.cpdm AS ywbm,
 --业务编码
--(SELECT auto_gen_fxsj_id ('DZ'))  AS fxsj_id,
'' AS fxsj_id,
 --
'次' AS unit
FROM
	(
		SELECT
			t1.ywrq,
			t1.cpdm,
			COUNT (t1.cpdm) nums,
			t1.jys,
			p3.jysmc
		FROM
			hub_tqs_imp_cjls_ls t1
		LEFT JOIN hub_dd_tqs_jysxx p3 ON t1.jys = p3.jys
		GROUP BY
			t1.ywrq,
			t1.jys,
			t1.cpdm,
			p3.jysmc
	) zjzhdy
WHERE
	zjzhdy.nums > 20