/**
大户持仓
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
	'大户持仓' AS fxzb,
	--风险指标
	zjzhdy.nums AS fxzbz,
	--风险指标值
	CASE
WHEN zjzhdy.nums <= 40 THEN
	30
WHEN zjzhdy.nums >40
AND zjzhdy.nums <=50 THEN
	40
ELSE
	50
END AS yuzhi,
 --阈值
CASE
WHEN zjzhdy.nums <= 40 THEN
	round(
		(zjzhdy.nums :: NUMERIC - 30) / 30 * 100,
		2
	)
WHEN zjzhdy.nums > 40
AND zjzhdy.nums <= 50 THEN
	round(
		(zjzhdy.nums :: NUMERIC - 40) / 40* 100,
		2
	)
ELSE
	round(
		(zjzhdy.nums :: NUMERIC - 50) / 50 * 100,
		2
	)
END AS cce,
 --超出额
zjzhdy.jys AS jgdm,
 --机构代码
zjzhdy.jysmc AS jgmc,
 --机构名称
zjzhdy.cid AS cust_id,
 --客户号
zjzhdy.khxm AS khmc,
 --客户名称
'JYXX' AS ywcdbm,
 --业务菜单编码
'交易信息' AS ywcdmc,
 --业务菜单名称
'中心产品编码' AS ywlx,
 --业务类型
zjzhdy.cpbm AS ywbm,
 --业务编码
--(SELECT auto_gen_fxsj_id ('DZ'))  AS fxsj_id,
'' AS fxsj_id,
 --
'%' AS unit

from(

SELECT vday,cid,khxm,jys,jysmc,jysinfo,cpbm,cpmc,sum(fvalue) as nu,
(SELECT sum(fvalue)  from insight_position_amount t  where t.vday=t1.vday and t.jys=t1.jys and t.cpbm=t1.cpbm ) as allnums,
round(sum(fvalue)/(SELECT sum(fvalue)  from insight_position_amount t  where t.vday=t1.vday and t.jys=t1.jys and t.cpbm=t1.cpbm )*100,2) as nums
 from insight_position_amount t1 GROUP BY vday,cid,khxm,jys,jysmc,jysinfo,cpbm,cpmc)zjzhdy
WHERE zjzhdy.nums>30