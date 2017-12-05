/**
出入金异常
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
			to_char((SELECT now() :: TIMESTAMP),'yyyyMMdd HH24:mm:ss') AS bjsj,
			--报警时间
			'资金风险' AS fxlb,
			--风险类别
			'出入金异常' AS fxzb,
			--风险指标
			zjzhdy.nums AS fxzbz,
			--风险指标值
		CASE WHEN zjzhdy.nums<=20   
then 10 WHEN zjzhdy.nums >20 and zjzhdy.nums<=30
then 20 ELSE 30 end 
			 AS yuzhi,
			--阈值
	CASE WHEN zjzhdy.nums<=20 
then round((zjzhdy.nums::numeric-10) /10 * 100,2)
 WHEN zjzhdy.nums >20 and zjzhdy.nums<=30
then 
 round((zjzhdy.nums::numeric-20) /20 * 100,2)
ELSE 
 round((zjzhdy.nums::numeric-30) /30 * 100,2)
 end 
			 AS cce,
			--超出额
			zjzhdy.jys AS jgdm,
			--机构代码
			p4.jysmc AS jgmc,
			--机构名称
			zjzhdy.cid AS cust_id,
			--客户号
			khxx.khxm AS khmc,
			--客户名称
			'ZJXX' AS ywcdbm,
			--业务菜单编码
			'资金信息' AS ywcdmc,
			--业务菜单名称
			'市场编码' AS ywlx,
			--业务类型
			'' AS ywbm,
			--业务编码
			--(SELECT auto_gen_fxsj_id ('DZ'))  AS fxsj_id,
			'' AS fxsj_id,
			--
			'次' AS unit
		FROM
			hub_tqs_khxx khxx
		INNER JOIN (SELECT cid,count(cid) as nums,jys FROM hub_tqs_zjjysq_ls where cljg='-111' GROUP BY cid,clrq,jys) zjzhdy on
		 zjzhdy.cid = khxx.cid
LEFT JOIN hub_dd_tqs_jysxx  p4 ON zjzhdy.jys = p4.jys
WHERE zjzhdy.nums>10