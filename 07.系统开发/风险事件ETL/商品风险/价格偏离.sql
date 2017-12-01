/**
价格偏离
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
	'价格偏离' AS fxzb,
	--风险指标
	zjzhdy.nums AS fxzbz,
	--风险指标值
	CASE
WHEN zjzhdy.nums <= 4 THEN
	2
WHEN zjzhdy.nums >4
AND zjzhdy.nums <=6 THEN
	4
ELSE
	6
END AS yuzhi,
 --阈值
CASE
WHEN zjzhdy.nums <= 4 THEN
	round(
		(zjzhdy.nums :: NUMERIC - 2) / 2 * 100,
		2
	)
WHEN zjzhdy.nums > 4
AND zjzhdy.nums <= 6 THEN
	round(
		(zjzhdy.nums :: NUMERIC - 4) / 4* 100,
		2
	)
ELSE
	round(
		(zjzhdy.nums :: NUMERIC - 6) / 6 * 100,
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
'XXLG' AS ywcdbm,
 --业务菜单编码
'线下价格' AS ywcdmc,
 --业务菜单名称
'中心产品编码' AS ywlx,
 --业务类型
zjzhdy.cpbm AS ywbm,
 --业务编码
--(SELECT auto_gen_fxsj_id ('DZ'))  AS fxsj_id,
'' AS fxsj_id,
 --
'%' AS unit
FROM
(SELECT
	(P .fvalue - x.jg) / x.jg AS nums,
	P .jys,
	P .jysmc,
	P .cpbm,
	P .cpmc
FROM
	insight_settlement_price P
INNER JOIN hub_xxjg x ON x.pzdm = P .cpbm
)zjzhdy
WHERE
	zjzhdy.nums > 2