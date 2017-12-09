/**
大额入金
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
			'资金风险' AS fxlb,
			--风险类别
			'大额入金' AS fxzb,
			--风险指标
			zjzhdy.fvalue AS fxzbz,
			--风险指标值
		CASE WHEN zjzhdy.fvalue<=1000000 
then 50 WHEN zjzhdy.fvalue >1000000 and zjzhdy.fvalue<=2000000
then 100 ELSE 200 end 
			 AS yuzhi,
			--阈值
	CASE WHEN zjzhdy.fvalue<=1000000 
then round((zjzhdy.fvalue::numeric-500000) /500000 * 100,2)
 WHEN zjzhdy.fvalue >1000000 and zjzhdy.fvalue<=2000000
then 
 round((zjzhdy.fvalue::numeric-1000000) /1000000 * 100,2)
ELSE 
 round((zjzhdy.fvalue::numeric-2000000) /2000000 * 100,2)
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
			'ZJXX' AS ywcdbm,
			--业务菜单编码
			'资金信息' AS ywcdmc,
			--业务菜单名称
			'申请编号' AS ywlx,
			--业务类型
			'' AS ywbm,
			--业务编码
			--(SELECT auto_gen_fxsj_id ('DZ'))  AS fxsj_id,
			'' AS fxsj_id,
			--
			'万' AS unit
		FROM
			 insight_in_out_amount zjzhdy 
WHERE zjzhdy.fvalue>500000