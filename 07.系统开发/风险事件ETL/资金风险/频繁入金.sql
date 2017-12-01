/**
频繁入金
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
			'频繁入金' AS fxzb,
			--风险指标
			zjzhdy.nums AS fxzbz,
			--风险指标值
		CASE WHEN zjzhdy.nums<=5   
then 3 WHEN zjzhdy.nums >5 and zjzhdy.nums<=8
then 5 ELSE 8 end 
			 AS yuzhi,
			--阈值
	CASE WHEN zjzhdy.nums<=5 
then round((zjzhdy.nums::numeric-3) /3 * 100,2)
 WHEN zjzhdy.nums >5 and zjzhdy.nums<=8
then 
 round((zjzhdy.nums::numeric-5) /5 * 100,2)
ELSE 
 round((zjzhdy.nums::numeric-8) /8 * 100,2)
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
			'客户信息' AS ywcdmc,
			--业务菜单名称
			'客户号' AS ywlx,
			--业务类型
			'' AS ywbm,
			--业务编码
			--(SELECT auto_gen_fxsj_id ('DZ'))  AS fxsj_id,
			'' AS fxsj_id,
			--
			'次' AS unit
		FROM (SELECT cid,fvalue3 as nums ,jys,jysmc,khxm FROM insight_in_out_amount ) zjzhdy
WHERE zjzhdy.nums>3