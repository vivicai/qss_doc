/**
大额亏损
**/
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
			to_char(
				(SELECT now() :: TIMESTAMP),
				'yyyyMMdd HH24:mm:ss'
			) AS bjsj,
			--报警时间
			'交易风险' AS fxlb,
			--风险类别
			'大额亏损' AS fxzb,
			--风险指标
			zjzhdy.nums AS fxzbz,
			--风险指标值
		CASE WHEN 0-zjzhdy.nums<=500000   
then 20 WHEN 0-zjzhdy.nums >500000 and 0-zjzhdy.nums<=1000000
then 50 ELSE 100 end 
			 AS yuzhi,
			--阈值
	CASE WHEN 0-zjzhdy.nums<=500000
then round((0-zjzhdy.nums::numeric-200000) /200000 * 100,2)
 WHEN 0-zjzhdy.nums >500000 and 0-zjzhdy.nums<=1000000
then 
 round((0-zjzhdy.nums::numeric-500000) /500000 * 100,2)
ELSE 
 round((0-zjzhdy.nums::numeric-1000000) /1000000 * 100,2)
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
			'KHXX' AS ywcdbm,
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
		FROM (SELECT cid,sum(fvalue) as nums,jys,jysmc,khxm FROM insight_profit_loss_amount GROUP BY cid,vday,jys,jysmc,khxm ) zjzhdy
where  0-zjzhdy.nums>200000