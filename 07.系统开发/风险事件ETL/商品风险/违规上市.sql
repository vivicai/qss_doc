/**
违规上市
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
	to_char((SELECT now() :: TIMESTAMP),'yyyyMMdd HH24:mm:ss') AS bjsj,
	--报警时间
	'商品风险' AS fxlb,
	--风险类别
	'违规上市' AS fxzb,
	--风险指标
	zjzhdy.nums AS fxzbz,
	--风险指标值
	CASE
WHEN zjzhdy.nums <= 2 THEN
	1
WHEN zjzhdy.nums >2
AND zjzhdy.nums <=3 THEN
	2
ELSE
	3
END AS yuzhi,
 --阈值
CASE
WHEN zjzhdy.nums <= 2 THEN
	round(
		(zjzhdy.nums :: NUMERIC - 1) / 1 * 100,
		2
	)
WHEN zjzhdy.nums > 2
AND zjzhdy.nums <= 3 THEN
	round(
		(zjzhdy.nums :: NUMERIC - 2) / 2 * 100,
		2
	)
ELSE
	round(
		(zjzhdy.nums :: NUMERIC - 3) / 3 * 100,
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
'CPXX' AS ywcdbm,
 --业务菜单编码
'交易信息' AS ywcdmc,
 --业务菜单名称
'中心产品编码' AS ywlx,
 --业务类型
zjzhdy.cpdm AS ywbm,
 --业务编码
--(SELECT auto_gen_fxsj_id ('DZ'))  AS fxsj_id,
'' AS fxsj_id,
 --
'个' AS unit
FROM
(SELECT
	t1.ywrq,
	t1.cpdm,
	t1.jys,
	p3.jysmc,
	count(t1.cpdm)as  nums--今天最大值

FROM
	hub_tqs_imp_cjls_ls t1

LEFT JOIN hub_dd_tqs_jysxx p3 ON t1.jys = p3.jys
where t1.cpdm  NOT in(SELECT cpdm from hub_tqs_cpxx)
GROUP BY
	t1.ywrq,
	t1.jys,
	p3.jysmc,
	t1.cpdm
)zjzhdy
WHERE
	zjzhdy.nums > 1