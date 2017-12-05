/**
盈利比例
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
			'盈利比例' AS fxzb,
			--风险指标
			zjzhdy.nums AS fxzbz,
			--风险指标值
		CASE WHEN zjzhdy.nums<=50  
then 30 WHEN zjzhdy.nums >30 and zjzhdy.nums<=70
then 50 ELSE 70 end 
			 AS yuzhi,
			--阈值
	CASE WHEN zjzhdy.nums<=50
then round((zjzhdy.nums::numeric-30) /30 * 100,2)
 WHEN zjzhdy.nums >50 and zjzhdy.nums<=70
then 
 round((zjzhdy.nums::numeric-50) /50 * 100,2)
ELSE 
 round((zjzhdy.nums::numeric-70) /70 * 100,2)
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
		FROM (
SELECT x.cid,x.vday,COALESCE(y.fvalue/x.jrj,0) as nums,x.jys,x.jysmc,x.khxm from
--本金（净入金）
(SELECT cid,vday,(SELECT sum(fvalue2) from insight_in_out_amount a2 WHERE  a2.vday<=a1.vday and a1.cid=a2.cid) as jrj,jys,jysmc,khxm FROM insight_in_out_amount a1 GROUP BY a1.cid,a1.vday,a1.jys,a1.jysmc,a1.khxm
)x
LEFT JOIN
--单日客户盈利
(SELECT cid,vday,fvalue,jys,jysmc,khxm from insight_profit_loss_amount WHERE fvalue>0 )y
on x.cid=y.cid and x.vday=y.vday
 ) zjzhdy 
where  zjzhdy.nums>30