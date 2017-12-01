/**
客户黑名单指标：客户黑名单表中的身份证号与ACCOUNT.TQS_KHXX中的ZJBH匹配+客户id配置
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
			'客户风险' AS fxlb,
			--风险类别
			'客户黑名单' AS fxzb,
			--风险指标
			'' AS fxzbz,
			--风险指标值
			'' AS yuzhi,
			--阈值
			'' AS cce,
			--超出额
			zjzhdy.jgdm AS jgdm,
			--机构代码
			zjzhdy.jgmc AS jgmc,
			--机构名称
			zjzhdy.cust_id AS cust_id,
			--客户号
			zjzhdy.cust_name AS khmc,
			--客户名称
			'KHHMD' AS ywcdbm,
			--业务菜单编码
			'客户黑名单' AS ywcdmc,
			--业务菜单名称
			'身份证号' AS ywlx,
			--业务类型
			'' AS ywbm,
			--业务编码
			--(SELECT auto_gen_fxsj_id ('DZ')) AS fxsj_id,
      '' AS fxsj_id,
			--
			'' AS unit
		FROM  hub_blacklist zjzhdy 