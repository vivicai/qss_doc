/**客户适当性**/
INSERT INTO hub_fxsj  (
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
to_char(	(SELECT now() :: TIMESTAMP),'yyyyMMdd HH24:mm:ss') AS bjsj,
	--报警时间
	'客户风险' AS fxlb,
	--风险类别
	'客户适当性' AS fxzb,
	COALESCE(t1.fxzbz,0) as fxzbz,
	--风险指标值
	CASE
WHEN COALESCE(t1.fxzbz,0) < 50000 THEN
	2
WHEN COALESCE(t1.fxzbz,0) < 100000 and COALESCE(t1.fxzbz,0) >= 50000
then 5
ELSE
10
END AS yuzhi,
 --阈值
	CASE
WHEN COALESCE(t1.fxzbz,0) <= 50000 THEN
	round((COALESCE(t1.fxzbz,0)-20000)::numeric /20000 * 100,2)
WHEN COALESCE(t1.fxzbz,0) <= 100000 and COALESCE(t1.fxzbz,0) > 50000
then 
round((COALESCE(t1.fxzbz,0)::numeric-50000) /50000 * 100,2)
ELSE
round((COALESCE(t1.fxzbz,0)::numeric-100000) /100000 * 100,2)
END
 AS cee,
 --超出额
t1.jys as jgdm,
 --机构代码
t1.jysmc AS jgmc,
 --机构名称
t1.cid,
 --客户号
t1.khxm,
 --客户名称
'KHXX' AS ywcdbm,
 --业务菜单编码
'客户信息' AS ywcdmc,
 --业务菜单名称
'身份证号' AS ywlx,
 --业务类型
'' AS ywbm,
 --业务编码
 --(SELECT auto_gen_fxsj_id ('DZ'))  AS fxsj_id,
'' AS fxsj_id,
 --
'万' AS unit

 from (

SELECT x.vday,x.cid,(COALESCE(x.fvalue2,0)+COALESCE(y.fvalue,0)) as fxzbz,x.jys,x.jysmc,x.khxm from 
--静入金
(SELECT a2.vday,a2.cid,COALESCE(a1.fvalue2,0) as fvalue2,a2.jys,a2.jysmc,a2.khxm  from insight_in_out_amount a1 RIGHT JOIN (SELECT MIN(vday) as vday,cid,jys,jysmc,khxm from insight_in_out_amount GROUP BY cid,jys,jysmc,khxm) a2
on a1.cid=a2.cid and a1.vday=a2.vday)x
LEFT join
--期末资金
(SELECT a4.vday,a4.cid,COALESCE(a3.fvalue,0) as fvalue,a3.jys,a3.jysmc,a3.khxm from insight_ending_balance_amount a3 RIGHT JOIN (SELECT MIN(vday) as vday,cid from insight_ending_balance_amount GROUP BY cid) a4
on a3.cid=a4.cid and a3.vday=a4.vday)y
on x.vday=y.vday and x.cid=y.cid
)t1
WHERE COALESCE(t1.fxzbz,0)>=20000 