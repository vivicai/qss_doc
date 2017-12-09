/**
最大波幅
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
	'商品风险' AS fxlb,
	--风险类别
	'最大波幅' AS fxzb,
	--风险指标
	zjzhdy.nums AS fxzbz,
	--风险指标值
	CASE
WHEN zjzhdy.nums <= 12 THEN
	8
WHEN zjzhdy.nums > 12
AND zjzhdy.nums <= 16 THEN
	12
ELSE
	16
END AS yuzhi,
 --阈值
CASE
WHEN zjzhdy.nums <= 12 THEN
	round(
		(zjzhdy.nums :: NUMERIC - 8) / 8 * 100,
		2
	)
WHEN zjzhdy.nums > 12
AND zjzhdy.nums <= 16 THEN
	round(
		(zjzhdy.nums :: NUMERIC - 12) / 12 * 100,
		2
	)
ELSE
	round(
		(zjzhdy.nums :: NUMERIC - 16) / 16 * 100,
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
'中心产品编码' AS ywlx,
 --业务类型
zjzhdy.cpdm AS ywbm,
 --业务编码
--(SELECT auto_gen_fxsj_id ('DZ'))  AS fxsj_id,
'' AS fxsj_id,
 --
'%' AS unit
FROM
(SELECT
	t1.ywrq,
	t1.cpdm,
	t1.jys,
	p3.jysmc,
	MAX (t1.cjje) maxcjje,--今天最大值
  min(t1.cjje) mincjje,--今天最小值
MAX(t1.cjje)-min(t1.cjje) as ce,--今天差值
(SELECT  min(i.cjje) from hub_tqs_imp_cjls_ls i where   i.ywrq=to_char(to_date(t1.ywrq, 'yyyymmdd') + interval '-1 day','yyyymmdd')) as lastmin,
--T-1日最低成交价格
(MAX(t1.cjje)-min(t1.cjje))/(SELECT  min(i.cjje) from hub_tqs_imp_cjls_ls i where   i.ywrq=to_char(to_date(t1.ywrq, 'yyyymmdd') + interval '-1 day','yyyymmdd')) as nums
FROM
	hub_tqs_imp_cjls_ls t1

LEFT JOIN hub_dd_tqs_jysxx p3 ON t1.jys = p3.jys

GROUP BY
	t1.ywrq,
	t1.jys,
	p3.jysmc,
	t1.cpdm
)zjzhdy
WHERE
	zjzhdy.nums > 8