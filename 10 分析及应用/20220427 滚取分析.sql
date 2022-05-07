--20220427滚取分析
--1、提前期、取消、机型客座率、小时含税收入、下四分位数、中位数、上四分位数、平均值、标准差（机型客座率、小时含税收入）

select  t1.操作提前期,t1.取消,count(1) 样本量,sum(t1.轮档时间) 轮档小时
 from hdb.pj_income_cancel_flight t1
 where t1.操作提前期<=4 
 and t1.机型客座率 is not null
 and t1.含税小时收入1 is not null
 and t1.边际贡献 is not null
 and t1.预估航班最终边际贡献 is not null 
 and t1.轮档时间 is not null
 and t1.轮档时间>0
 group by t1.操作提前期,t1.取消;



 select  t1.操作提前期,t1.取消,t1.航线,count(1) 样本量,sum(t1.轮档时间) 轮档小时
 from hdb.pj_income_cancel_flight t1
 where t1.操作提前期<=4 
 and t1.机型客座率 is not null
 and t1.含税小时收入1 is not null
 and t1.边际贡献 is not null
 and t1.预估航班最终边际贡献 is not null 
 and t1.轮档时间 is not null
 and t1.轮档时间>0
 group by t1.操作提前期,t1.取消,t1.航线;



select distinct  t1.操作提前期,t1.取消,
    -- t1.机型客座率,
    --t1.含税小时收入1,
    --t1.边际贡献含航班补贴/t1.轮档时间 含补贴小时边际贡献,
    min(t1.机型客座率) over(partition by t1.操作提前期,t1.取消)  plf_min,
    percentile_cont(0.25) within  group( order by t1.机型客座率) over(partition by t1.操作提前期,t1.取消) plf_25, 
    percentile_cont(0.5) within  group( order by t1.机型客座率) over(partition by t1.操作提前期,t1.取消) plf_50, 
    percentile_cont(0.75) within  group( order by t1.机型客座率) over(partition by t1.操作提前期,t1.取消) plf_75,
    max(t1.机型客座率) over(partition by t1.操作提前期,t1.取消)  plf_max, 
    avg(t1.机型客座率) over(partition by t1.操作提前期,t1.取消)  plf_avg,
    stddev(t1.机型客座率)over(partition by t1.操作提前期,t1.取消) plf_std,
    min(t1.含税小时收入1) over(partition by t1.操作提前期,t1.取消)  hours_min,
    percentile_cont(0.25) within  group( order by t1.含税小时收入1) over(partition by t1.操作提前期,t1.取消) hours_25, 
    percentile_cont(0.5) within  group( order by t1.含税小时收入1) over(partition by t1.操作提前期,t1.取消) hours_50, 
    percentile_cont(0.75) within  group( order by t1.含税小时收入1) over(partition by t1.操作提前期,t1.取消) hours_75, 
    max(t1.含税小时收入1) over(partition by t1.操作提前期,t1.取消)  hours_max,
    avg(t1.含税小时收入1) over(partition by t1.操作提前期,t1.取消)  hours_avg,
    stddev(t1.含税小时收入1)over(partition by t1.操作提前期,t1.取消) hours_std,
    min(t1.边际贡献含航班补贴/t1.轮档时间) over(partition by t1.操作提前期,t1.取消)  hoursub_min,
    percentile_cont(0.25) within  group( order by t1.边际贡献含航班补贴/t1.轮档时间) over(partition by t1.操作提前期,t1.取消) hoursub_25, 
    percentile_cont(0.5) within  group( order by t1.边际贡献含航班补贴/t1.轮档时间) over(partition by t1.操作提前期,t1.取消) hoursub_50, 
    percentile_cont(0.75) within  group( order by t1.边际贡献含航班补贴/t1.轮档时间) over(partition by t1.操作提前期,t1.取消) hoursub_75, 
    max(t1.边际贡献含航班补贴/t1.轮档时间) over(partition by t1.操作提前期,t1.取消)  hoursub_max,
    avg(t1.边际贡献含航班补贴/t1.轮档时间) over(partition by t1.操作提前期,t1.取消)  hoursub_avg,
    stddev(t1.边际贡献含航班补贴/t1.轮档时间)over(partition by t1.操作提前期,t1.取消) hoursub_std,
    min(t1.预估航班最终边际贡献/t1.轮档时间) over(partition by t1.操作提前期,t1.取消)  lasts_min,
    percentile_cont(0.25) within  group( order by t1.预估航班最终边际贡献/t1.轮档时间) over(partition by t1.操作提前期,t1.取消) lasts_25, 
    percentile_cont(0.5) within  group( order by t1.预估航班最终边际贡献/t1.轮档时间) over(partition by t1.操作提前期,t1.取消) lasts_50, 
    percentile_cont(0.75) within  group( order by t1.预估航班最终边际贡献/t1.轮档时间) over(partition by t1.操作提前期,t1.取消) lasts_75, 
    max(t1.预估航班最终边际贡献/t1.轮档时间) over(partition by t1.操作提前期,t1.取消)  lasts_max,
    avg(t1.预估航班最终边际贡献/t1.轮档时间) over(partition by t1.操作提前期,t1.取消)  lasts_avg,
    stddev(t1.预估航班最终边际贡献/t1.轮档时间)over(partition by t1.操作提前期,t1.取消) lasts_std
 from hdb.pj_income_cancel_flight t1
 where t1.操作提前期<=4 
 and t1.机型客座率 is not null
 and t1.含税小时收入1 is not null
 and t1.边际贡献 is not null
 and t1.预估航班最终边际贡献 is not null 
 and t1.轮档时间 is not null
 and t1.轮档时间>0;




select 操作提前期,取消,航线,
    PLF_25,	PLF_50,	PLF_75,	PLF_AVG,    PLF_STD,
    HOURS_25,	HOURS_50,	HOURS_75,	HOURS_AVG,	HOURS_STD,	
    HOURSUB_25,	HOURSUB_50,	HOURSUB_75,	HOURSUB_AVG,	HOURSUB_STD,	
    BJGX_25,	BJGX_50,	BJGX_75,	BJGX_AVG,	BJGX_STD,	
    LASTS_25,	LASTS_50,	LASTS_75,	LASTS_AVG,	LASTS_STD,
    sum(samples) samples

from(
select  t1.操作提前期,t1.取消,t1.航线,
    --t1.机型客座率,
    --t1.含税小时收入1,
    --t1.边际贡献含航班补贴/t1.轮档时间 含补贴小时边际贡献,
    --t1.边际贡献,
    --t1.预估航班最终边际贡献,
    percentile_cont(0.25) within  group( order by t1.机型客座率) over(partition by t1.操作提前期,t1.取消,t1.航线) plf_25, 
    percentile_cont(0.5) within  group( order by t1.机型客座率) over(partition by t1.操作提前期,t1.取消,t1.航线) plf_50, 
    percentile_cont(0.75) within  group( order by t1.机型客座率) over(partition by t1.操作提前期,t1.取消,t1.航线) plf_75, 
    avg(t1.机型客座率) over(partition by t1.操作提前期,t1.取消,t1.航线)  plf_avg,
    stddev(t1.机型客座率)over(partition by t1.操作提前期,t1.取消,t1.航线) plf_std,
    percentile_cont(0.25) within  group( order by t1.含税小时收入1) over(partition by t1.操作提前期,t1.取消,t1.航线) hours_25, 
    percentile_cont(0.5) within  group( order by t1.含税小时收入1) over(partition by t1.操作提前期,t1.取消,t1.航线) hours_50, 
    percentile_cont(0.75) within  group( order by t1.含税小时收入1) over(partition by t1.操作提前期,t1.取消,t1.航线) hours_75, 
    avg(t1.含税小时收入1) over(partition by t1.操作提前期,t1.取消,t1.航线)  hours_avg,
    stddev(t1.含税小时收入1)over(partition by t1.操作提前期,t1.取消,t1.航线) hours_std,
    percentile_cont(0.25) within  group( order by t1.边际贡献含航班补贴/t1.轮档时间) over(partition by t1.操作提前期,t1.取消,t1.航线) hoursub_25, 
    percentile_cont(0.5) within  group( order by t1.边际贡献含航班补贴/t1.轮档时间) over(partition by t1.操作提前期,t1.取消,t1.航线) hoursub_50, 
    percentile_cont(0.75) within  group( order by t1.边际贡献含航班补贴/t1.轮档时间) over(partition by t1.操作提前期,t1.取消,t1.航线) hoursub_75, 
    avg(t1.边际贡献含航班补贴/t1.轮档时间) over(partition by t1.操作提前期,t1.取消,t1.航线)  hoursub_avg,
    stddev(t1.边际贡献含航班补贴/t1.轮档时间)over(partition by t1.操作提前期,t1.取消,t1.航线) hoursub_std,
    percentile_cont(0.25) within  group( order by t1.边际贡献) over(partition by t1.操作提前期,t1.取消,t1.航线) bjgx_25, 
    percentile_cont(0.5) within  group( order by t1.边际贡献) over(partition by t1.操作提前期,t1.取消,t1.航线) bjgx_50, 
    percentile_cont(0.75) within  group( order by t1.边际贡献) over(partition by t1.操作提前期,t1.取消,t1.航线) bjgx_75, 
    avg(t1.边际贡献) over(partition by t1.操作提前期,t1.取消,t1.航线)  bjgx_avg,
    stddev(t1.边际贡献)over(partition by t1.操作提前期,t1.取消,t1.航线) bjgx_std,
    percentile_cont(0.25) within  group( order by t1.预估航班最终边际贡献) over(partition by t1.操作提前期,t1.取消,t1.航线) lasts_25, 
    percentile_cont(0.5) within  group( order by t1.预估航班最终边际贡献) over(partition by t1.操作提前期,t1.取消,t1.航线) lasts_50, 
    percentile_cont(0.75) within  group( order by t1.预估航班最终边际贡献) over(partition by t1.操作提前期,t1.取消,t1.航线) lasts_75, 
    avg(t1.预估航班最终边际贡献) over(partition by t1.操作提前期,t1.取消,t1.航线)  lasts_avg,
    stddev(t1.预估航班最终边际贡献)over(partition by t1.操作提前期,t1.取消,t1.航线) lasts_std,
    1 samples
 from hdb.pj_income_cancel_flight t1
 where t1.操作提前期<=4 
 and t1.机型客座率 is not null
 and t1.含税小时收入1 is not null
 and t1.边际贡献 is not null
 and t1.预估航班最终边际贡献 is not null 
 and t1.轮档时间 is not null
 and t1.轮档时间>0)
 group by 操作提前期,取消,航线,
    PLF_25,	PLF_50,	PLF_75,	PLF_AVG,    PLF_STD,
    HOURS_25,	HOURS_50,	HOURS_75,	HOURS_AVG,	HOURS_STD,	
    HOURSUB_25,	HOURSUB_50,	HOURSUB_75,	HOURSUB_AVG,	HOURSUB_STD,	
    BJGX_25,	BJGX_50,	BJGX_75,	BJGX_AVG,	BJGX_STD,	
    LASTS_25,	LASTS_50,	LASTS_75,	LASTS_AVG,	LASTS_STD