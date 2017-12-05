/**开户年龄**/
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
			'客户风险' AS fxlb,
			--风险类别
			'开户年龄' AS fxzb,
			--风险指标
			khxx.age AS fxzbz,
		--风险指标值
		CASE
WHEN khxx.age< 18 THEN 	'18'
WHEN khxx.age > 65 THEN 	'65'
WHEN khxx.age > 60 AND khxx.age<=65 THEN 	'60' 
END AS yuzhi,
		--阈值
		 CASE
WHEN khxx.age < 18 THEN
	round((18::numeric - khxx.age) / 18 * 100, 2)
WHEN khxx.age > 65 THEN
	round((khxx.age::numeric - 65) / 65 * 100, 2)
WHEN khxx.age > 60 AND khxx.age<=65 THEN
	round((khxx.age::numeric - 60) / 60 * 100, 2)
END AS cce,
		--超出额
		zjzhdy.jys AS jgdm,
		--机构代码
		p3.jysmc AS jgmc,
		--机构名称
		khxx.cid AS cust_id,
		--客户号
		khxx.khxm AS khmc,
		--客户名称
		'KHXX' AS ywcdbm,
		--业务菜单编码
		'客户信息' AS ywcdmc,
		--业务菜单名称
		'身份证号' AS ywlx,
		--业务类型
		'' AS ywbm,
		--业务编码
		--(SELECT auto_gen_fxsj_id ('DZ')) AS fxsj_id,
		'' AS fxsj_id,
		--
		'岁' AS unit
	FROM
		hub_tqs_khxx khxx
	INNER JOIN hub_tqs_zjzhdy zjzhdy ON zjzhdy.cid = khxx.cid
  LEFT JOIN hub_dd_tqs_jysxx p3 ON zjzhdy.jys = p3.jys
	WHERE
		TRIM (zjzhdy.qyzt) = '0'
	AND TRIM (khxx.zjlb) = '0'
  AND khxx.age < 18
  OR khxx.age > 60