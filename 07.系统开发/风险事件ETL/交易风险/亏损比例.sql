/**
亏损比例
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
			'亏损比例' AS fxzb,
			--风险指标
			zjzhdy.nums AS fxzbz,
			--风险指标值
		CASE WHEN 0-zjzhdy.nums<=40  
then 20 WHEN 0-zjzhdy.nums >40 and 0-zjzhdy.nums<=60
then 40 ELSE 60 end 
			 AS yuzhi,
			--阈值
	CASE WHEN 0-zjzhdy.nums<=40
then round((0-zjzhdy.nums::numeric-20) /20 * 100,2)
 WHEN 0-zjzhdy.nums >40 and 0-zjzhdy.nums<=60
then 
 round((0-zjzhdy.nums::numeric-40) /40 * 100,2)
ELSE 
 round((zjzhdy.nums::numeric-60) /60 * 100,2)
 end 
			 AS cce,
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
			'客户号' AS ywlx,
			--业务类型
			'' AS ywbm,
			--业务编码
			--(SELECT auto_gen_fxsj_id ('DZ'))  AS fxsj_id,
     			 '' AS fxsj_id,
			--
			'%' AS unit
		FROM(
SELECT x.cid,x.vday,COALESCE(y.fvalue/x.jrj,0) as nums,x.khxm,x.jys,x.jysmc from
--本金（净入金）
(SELECT cid,vday,(SELECT sum(fvalue2) from insight_in_out_amount a2 WHERE  a2.vday<=a1.vday and a1.cid=a2.cid) as jrj,a1.khxm,a1.jys,a1.jysmc FROM insight_in_out_amount a1 GROUP BY a1.cid,a1.vday,a1.khxm,a1.jys,a1.jysmc
)x
LEFT JOIN
--单日客户盈利
(SELECT cid,vday,fvalue,khxm,jys,jysmc from insight_profit_loss_amount WHERE fvalue>0 )y
on x.cid=y.cid and x.vday=y.vday
 ) zjzhdy
where  0-zjzhdy.nums>20