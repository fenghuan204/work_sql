--针对2018年11~2020年优惠券被盗用的情况进行分析，找到真实被盗用的数量

select /*+parallel(4) */
tb1.*,tb2.yhqnum,tb2.useyhq,tb2.usemoney,tb3.tkt,tb3.tktuse,tb3.ntktuse
  from (select case
                 when t1.batch_no in
                      (4688, 4091, 3875, 4710, 4151, 3870, 4709, 4094, 4430, 5603, 4690, 4050, 4150, 3889, 4051, 4110, 4250, 3928, 4052, 4063, 4130, 5668, 4506, 4490, 4909, 4208, 4505, 4834, 5192) then
                  'admin'
                 when t1.batch_no in
                      (5088, 5177, 5142, 4348, 4751, 4817, 4836, 4837, 4893, 4894, 4835, 4870, 6408, 6410, 6411, 6412, 6421, 6428, 5592, 5594, 4589, 5597, 5614, 5684, 5685, 5728, 5729, 5753, 5754, 5772, 5773, 6631, 6509, 6671, 6670, 6669, 6668, 6732, 6731, 6730, 6729, 6728, 6710, 6708, 6709, 6148, 6190, 7289, 7288, 7108, 7248, 6948, 6808, 6788, 7928, 8468) then
                  'lijintian'
                 when t1.batch_no in
                      (5674, 9289, 9290, 8095, 8169, 8093, 7749, 8328, 7910, 7908, 7752, 7754, 8090, 7868, 8317, 8618, 8168, 8312, 8529, 8311, 8313, 8637, 8643, 8494, 8710, 8813, 8599, 8590, 8530, 8308, 8309, 8315, 8316, 8489, 8491, 8508, 8510, 8511, 8513, 8514, 8515, 8528, 8531, 8534, 8600, 8644, 8720, 8721, 8940, 8711, 8814, 8933, 8936, 8935, 8708, 8934) then
                  'yangmian'
               end 操作人,
               t1.batch_no,
               t2.act_name,
               min(t1.activity_name) activity_name,  ---cms有多个名称不一致的情况
               t2.total_num,
               t2.create_user,
               t2.create_date,
               t2.money_var,
               t2.status,
               t2.ssnum,
               t2.usenum,
               t2.nusenum,
               count(1) 生成量,
               sum(case
                     when t1.expand_feild is not null then
                      1
                     when t1.quan_status = '1' then
                      1
                     else
                      0
                   end) 兑换量,
               t2.money_var * sum(case
                                    when t1.expand_feild is not null then
                                     1
                                    when t1.quan_status = '1' then
                                     1
                                    else
                                     0
                                  end) 优惠金额
          from hdb.cms_yhq_create t1
          left join (select h1.batch_id,
                           h1.act_name,
                           h1.total_num,
                           h1.create_user,
                           h1.create_date,
                           h1.money_var,
                           h1.status,
                           count(distinct h2.id) ssnum,
                           count(distinct case when h2.STATUS=1 then h2.id else null end) usenum,
                           count(distinct case when h2.STATUS=1 and nvl(h2.INNERPID,'-') like '%无效%' then h2.id else null end) nusenum                 
                      from dw.bi_yhq_batch h1
                     left join YHQ.CQ_NEW_YHQ_RELATION@to_air h2 on h1.batch_id=h2.CREATE_ID                    
                     where h1.create_date>=to_date('20180101','yyyymmdd')
                     group by h1.batch_id,
                              h1.act_name,
                              h1.total_num,
                              h1.create_user,
                              h1.create_date,
                              h1.money_var,
                              h1.status
                   
                              ) t2 on to_char(t1.batch_no) =
                                               to_char(t2.batch_id)
         where t1.batch_no in
               (4688, 4091, 3875, 4710, 4151, 3870, 4709, 4094, 4430, 5603, 4690, 4050, 4150, 3889, 4051, 4110, 4250, 3928, 4052, 4063, 4130, 5668, 4506, 4490, 4909, 4208, 4505, 4834, 5192, 5088, 5177, 5142, 4348, 4751, 4817, 4836, 4837, 4893, 4894, 4835, 4870, 6408, 6410, 6411, 6412, 6421, 6428, 5592, 5594, 4589, 5597, 5614, 5684, 5685, 5728, 5729, 5753, 5754, 5772, 5773, 6631, 6509, 6671, 6670, 6669, 6668, 6732, 6731, 6730, 6729, 6728, 6710, 6708, 6709, 6148, 6190, 7289, 7288, 7108, 7248, 6948, 6808, 6788, 7928, 8468, 5674, 9289, 9290, 8095, 8169, 8093, 7749, 8328, 7910, 7908, 7752, 7754, 8090, 7868, 8317, 8618, 8168, 8312, 8529, 8311, 8313, 8637, 8643, 8494, 8710, 8813, 8599, 8590, 8530, 8308, 8309, 8315, 8316, 8489, 8491, 8508, 8510, 8511, 8513, 8514, 8515, 8528, 8531, 8534, 8600, 8644, 8720, 8721, 8940, 8711, 8814, 8933, 8936, 8935, 8708, 8934)
         group by case
                    when t1.batch_no in
                         (4688, 4091, 3875, 4710, 4151, 3870, 4709, 4094, 4430, 5603, 4690, 4050, 4150, 3889, 4051, 4110, 4250, 3928, 4052, 4063, 4130, 5668, 4506, 4490, 4909, 4208, 4505, 4834, 5192) then
                     'admin'
                    when t1.batch_no in
                         (5088, 5177, 5142, 4348, 4751, 4817, 4836, 4837, 4893, 4894, 4835, 4870, 6408, 6410, 6411, 6412, 6421, 6428, 5592, 5594, 4589, 5597, 5614, 5684, 5685, 5728, 5729, 5753, 5754, 5772, 5773, 6631, 6509, 6671, 6670, 6669, 6668, 6732, 6731, 6730, 6729, 6728, 6710, 6708, 6709, 6148, 6190, 7289, 7288, 7108, 7248, 6948, 6808, 6788, 7928, 8468) then
                     'lijintian'
                    when t1.batch_no in
                         (5674, 9289, 9290, 8095, 8169, 8093, 7749, 8328, 7910, 7908, 7752, 7754, 8090, 7868, 8317, 8618, 8168, 8312, 8529, 8311, 8313, 8637, 8643, 8494, 8710, 8813, 8599, 8590, 8530, 8308, 8309, 8315, 8316, 8489, 8491, 8508, 8510, 8511, 8513, 8514, 8515, 8528, 8531, 8534, 8600, 8644, 8720, 8721, 8940, 8711, 8814, 8933, 8936, 8935, 8708, 8934) then
                     'yangmian'
                  end,
                  t1.batch_no,
                  t2.act_name,
                  
                  t2.total_num,
                  t2.create_user,
                  t2.create_date,
                  t2.money_var,
                  t2.status,
                              t2.ssnum,
               t2.usenum,
               t2.nusenum) tb1
  left join (select tb1.batch_id,
                    count(distinct tb1.yhq_id) yhqnum,
                    sum(case
                          when tb1.status = 1 then
                           1
                          else
                           0
                        end) useyhq,
                    sum(tb1.usemoney) usemoney
               from (select t4.batch_id,
                            t1.users_id,
                            t1.id yhq_id,
                            t3.usemoney,
                            t1.status
                       from YHQ.CQ_NEW_YHQ_RELATION@to_air t1
                       join dw.bi_yhq_batch t4 on t1.create_id = t4.batch_id
                       left join (select yhq_id,
                                        sum(case
                                              when t2.flag = 1 then
                                               t2.use_money
                                              else
                                               0
                                            end) usemoney
                                   from dw.bi_yhq_use t2
                                  where t2.version = '2'
                                  group by yhq_id) t3 on t1.id = t3.yhq_id) tb1
               join hdb.crm_yhq_reason tb2 on tb1.batch_id = tb2.couponno
                                          and tb1.yhq_id = tb2.couponid
                                          and tb2.couponid is not null
              group by tb1.batch_id) tb2 on tb1.batch_no = tb2.batch_id

  left join (select t1.couponbatchno,
                    count(distinct t2.id) tkt,
                    count(distinct case
                          when t2.status = 1 then
                           t2.id
                          else
                           null
                        end) tktuse,
                     count(distinct case
                          when t2.status = 1 and  nvl(t2.INNERPID,'-') like '%无效%' then
                           t2.id
                          else
                           null
                        end) ntktuse
               from hdb.crm_coupon_grant_detail t1
               join YHQ.CQ_NEW_YHQ_RELATION@to_air t2 on t1.couponbatchno =
                                                         t2.create_id
                                                     and t1.userid =
                                                         t2.users_id
              where t1.status = 1
              group by t1.couponbatchno) tb3 on tb1.batch_no =
                                                tb3.couponbatchno;



----------------------------------------------------------兑换明细统计-------------------------------------------------------------------


--GDS优惠券统计( 额度、发券、使用)
select h1.batch_id,
                           h1.act_name,
                           h1.total_num,
                           h1.create_user,
                           h1.create_date,
                           h1.money_var,
                           h1.status,
						   h2.users_id,
						   h2.id yhq_id,
                           count(distinct h2.id) ssnum,
                           count(distinct case when h2.STATUS=1 then h2.id else null end) usenum,
                           count(distinct case when h2.STATUS=1 and nvl(h2.INNERPID,'-') like '%无效%' then h2.id else null end) nusenum                 
                      from dw.bi_yhq_batch h1
                     left join YHQ.CQ_NEW_YHQ_RELATION@to_air h2 on h1.batch_id=h2.CREATE_ID                    
                     where h1.create_date>=to_date('20180101','yyyymmdd')
						and  h1.batch_id in
               (4688, 4091, 3875, 4710, 4151, 3870, 4709, 4094, 4430, 5603, 4690, 4050, 4150, 3889, 4051, 4110, 4250, 3928, 4052, 4063, 4130, 5668, 4506, 4490, 4909, 4208, 4505, 4834, 5192, 5088, 5177, 5142, 4348, 4751, 4817, 4836, 4837, 4893, 4894, 4835, 4870, 6408, 6410, 6411, 6412, 6421, 6428, 5592, 5594, 4589, 5597, 5614, 5684, 5685, 5728, 5729, 5753, 5754, 5772, 5773, 6631, 6509, 6671, 6670, 6669, 6668, 6732, 6731, 6730, 6729, 6728, 6710, 6708, 6709, 6148, 6190, 7289, 7288, 7108, 7248, 6948, 6808, 6788, 7928, 8468, 5674, 9289, 9290, 8095, 8169, 8093, 7749, 8328, 7910, 7908, 7752, 7754, 8090, 7868, 8317, 8618, 8168, 8312, 8529, 8311, 8313, 8637, 8643, 8494, 8710, 8813, 8599, 8590, 8530, 8308, 8309, 8315, 8316, 8489, 8491, 8508, 8510, 8511, 8513, 8514, 8515, 8528, 8531, 8534, 8600, 8644, 8720, 8721, 8940, 8711, 8814, 8933, 8936, 8935, 8708, 8934)
                     group by h1.batch_id,
                           h1.act_name,
                           h1.total_num,
                           h1.create_user,
                           h1.create_date,
                           h1.money_var,
                           h1.status,
						   h2.users_id,
						   h2.id；
					
---CMS 发券、使用


select t1.batch_no,t1.users_id,count(1) cms_ssnum,count(distinct case when  t1.quan_status=1 then t1.id else null end) cms_dhnum
from hdb.risk_yhq_cms  t1
and 	 t1.batch_no in
               (4688, 4091, 3875, 4710, 4151, 3870, 4709, 4094, 4430, 5603, 4690, 4050, 4150, 3889, 4051, 4110, 4250, 3928, 4052, 4063, 4130, 5668, 4506, 4490, 4909, 4208, 4505, 4834, 5192, 5088, 5177, 5142, 4348, 4751, 4817, 4836, 4837, 4893, 4894, 4835, 4870, 6408, 6410, 6411, 6412, 6421, 6428, 5592, 5594, 4589, 5597, 5614, 5684, 5685, 5728, 5729, 5753, 5754, 5772, 5773, 6631, 6509, 6671, 6670, 6669, 6668, 6732, 6731, 6730, 6729, 6728, 6710, 6708, 6709, 6148, 6190, 7289, 7288, 7108, 7248, 6948, 6808, 6788, 7928, 8468, 5674, 9289, 9290, 8095, 8169, 8093, 7749, 8328, 7910, 7908, 7752, 7754, 8090, 7868, 8317, 8618, 8168, 8312, 8529, 8311, 8313, 8637, 8643, 8494, 8710, 8813, 8599, 8590, 8530, 8308, 8309, 8315, 8316, 8489, 8491, 8508, 8510, 8511, 8513, 8514, 8515, 8528, 8531, 8534, 8600, 8644, 8720, 8721, 8940, 8711, 8814, 8933, 8936, 8935, 8708, 8934)
         
group by  t1.batch_no,t1.users_id;



---CRM 现有服务优惠券发送数据

select t.couponid batch_id,t1.users_id,t1.id yhq_id,
count(distinct t1.id) ssnum,
                           count(distinct case when t1.STATUS=1 then t1.id else null end) usenum,
                           count(distinct case when t1.STATUS=1 and nvl(t1.INNERPID,'-') like '%无效%' then h2.id else null end) nusenum 
from hdb.crm_yhq_reason t
join YHQ.CQ_NEW_YHQ_RELATION@to_air t1 on t.couponid=t1.id
where 	 t.couponid in
               (4688, 4091, 3875, 4710, 4151, 3870, 4709, 4094, 4430, 5603, 4690, 4050, 4150, 3889, 4051, 4110, 4250, 3928, 4052, 4063, 4130, 5668, 4506, 4490, 4909, 4208, 4505, 4834, 5192, 5088, 5177, 5142, 4348, 4751, 4817, 4836, 4837, 4893, 4894, 4835, 4870, 6408, 6410, 6411, 6412, 6421, 6428, 5592, 5594, 4589, 5597, 5614, 5684, 5685, 5728, 5729, 5753, 5754, 5772, 5773, 6631, 6509, 6671, 6670, 6669, 6668, 6732, 6731, 6730, 6729, 6728, 6710, 6708, 6709, 6148, 6190, 7289, 7288, 7108, 7248, 6948, 6808, 6788, 7928, 8468, 5674, 9289, 9290, 8095, 8169, 8093, 7749, 8328, 7910, 7908, 7752, 7754, 8090, 7868, 8317, 8618, 8168, 8312, 8529, 8311, 8313, 8637, 8643, 8494, 8710, 8813, 8599, 8590, 8530, 8308, 8309, 8315, 8316, 8489, 8491, 8508, 8510, 8511, 8513, 8514, 8515, 8528, 8531, 8534, 8600, 8644, 8720, 8721, 8940, 8711, 8814, 8933, 8936, 8935, 8708, 8934)
   
group by t.couponid,t1.users_id,t1.id



---CRM以前发送数据

 select t1.couponbatchno batch_id,t1.userid,t2.id yhq_id,
                    count(distinct t2.id) qcrm_ssnum,
                    count(distinct case
                          when t2.status = 1 then
                           t2.id
                          else
                           null
                        end) qcrm_usenum,
                     count(distinct case
                          when t2.status = 1 and  nvl(t2.INNERPID,'-') like '%无效%' then
                           t2.id
                          else
                           null
                        end) qcrm_ntktuse
               from hdb.crm_coupon_grant_detail t1
               join YHQ.CQ_NEW_YHQ_RELATION@to_air t2 on t1.couponbatchno =
                                                         t2.create_id
                                                     and t1.userid =
                                                         t2.users_id
              where t1.status = 1
			  and t1.couponbatchno in
               (4688, 4091, 3875, 4710, 4151, 3870, 4709, 4094, 4430, 5603, 4690, 4050, 4150, 3889, 4051, 4110, 4250, 3928, 4052, 4063, 4130, 5668, 4506, 4490, 4909, 4208, 4505, 4834, 5192, 5088, 5177, 5142, 4348, 4751, 4817, 4836, 4837, 4893, 4894, 4835, 4870, 6408, 6410, 6411, 6412, 6421, 6428, 5592, 5594, 4589, 5597, 5614, 5684, 5685, 5728, 5729, 5753, 5754, 5772, 5773, 6631, 6509, 6671, 6670, 6669, 6668, 6732, 6731, 6730, 6729, 6728, 6710, 6708, 6709, 6148, 6190, 7289, 7288, 7108, 7248, 6948, 6808, 6788, 7928, 8468, 5674, 9289, 9290, 8095, 8169, 8093, 7749, 8328, 7910, 7908, 7752, 7754, 8090, 7868, 8317, 8618, 8168, 8312, 8529, 8311, 8313, 8637, 8643, 8494, 8710, 8813, 8599, 8590, 8530, 8308, 8309, 8315, 8316, 8489, 8491, 8508, 8510, 8511, 8513, 8514, 8515, 8528, 8531, 8534, 8600, 8644, 8720, 8721, 8940, 8711, 8814, 8933, 8936, 8935, 8708, 8934)
            group by t1.couponbatchno,t1.userid,t2.id yhq_id;
			
	
----有问题的这些服务券使用的情况说明	
			
select hb1.*,hb2.crm_ssnum,hb2.crm_usenum,hb2.crm_nusenum,hb3.qcrm_ssnum,hb3.qcrm_usenum,hb3.qcrm_ntktuse--,hb4.flights_order_id,hb4.flights_order_head_id,hb4.other_order_
from(
select h1.batch_id,
                           h1.act_name,
                           h1.total_num,
                           h1.create_user,
                           h1.create_date,
                           h1.money_var,
                           h1.status,
               h2.users_id,
               h2.id yhq_id,
                           count(distinct h2.id) ssnum,
                           count(distinct case when h2.STATUS=1 then h2.id else null end) usenum,
                           count(distinct case when h2.STATUS=1 and nvl(h2.INNERPID,'-') like '%无效%' then h2.id else null end) nusenum                 
                      from dw.bi_yhq_batch h1
                     left join YHQ.CQ_NEW_YHQ_RELATION@to_air h2 on h1.batch_id=h2.CREATE_ID                    
                     where h1.create_date>=to_date('20180101','yyyymmdd')
                     and h1.act_name like '%服务%'
            and  h1.batch_id in
               (4688, 4091, 3875, 4710, 4151, 3870, 4709, 4094, 4430, 5603, 4690, 4050, 4150, 3889, 4051, 4110, 4250, 3928, 4052, 4063, 4130, 5668, 4506, 4490, 4909, 4208, 4505, 4834, 5192, 5088, 5177, 5142, 4348, 4751, 4817, 4836, 4837, 4893, 4894, 4835, 4870, 6408, 6410, 6411, 6412, 6421, 6428, 5592, 5594, 4589, 5597, 5614, 5684, 5685, 5728, 5729, 5753, 5754, 5772, 5773, 6631, 6509, 6671, 6670, 6669, 6668, 6732, 6731, 6730, 6729, 6728, 6710, 6708, 6709, 6148, 6190, 7289, 7288, 7108, 7248, 6948, 6808, 6788, 7928, 8468, 5674, 9289, 9290, 8095, 8169, 8093, 7749, 8328, 7910, 7908, 7752, 7754, 8090, 7868, 8317, 8618, 8168, 8312, 8529, 8311, 8313, 8637, 8643, 8494, 8710, 8813, 8599, 8590, 8530, 8308, 8309, 8315, 8316, 8489, 8491, 8508, 8510, 8511, 8513, 8514, 8515, 8528, 8531, 8534, 8600, 8644, 8720, 8721, 8940, 8711, 8814, 8933, 8936, 8935, 8708, 8934)
                     group by h1.batch_id,
                           h1.act_name,
                           h1.total_num,
                           h1.create_user,
                           h1.create_date,
                           h1.money_var,
                           h1.status,
               h2.users_id,
               h2.id)hb1
 left join (
 
 select t.couponid batch_id,t1.users_id,t1.id yhq_id,
count(distinct t1.id) crm_ssnum,
                           count(distinct case when t1.STATUS=1 then t1.id else null end) crm_usenum,
                           count(distinct case when t1.STATUS=1 and nvl(t1.INNERPID,'-') like '%无效%' then t1.id else null end) crm_nusenum 
from hdb.crm_yhq_reason t
join YHQ.CQ_NEW_YHQ_RELATION@to_air t1 on t.couponid=t1.id
where 	 t.couponid in
               (4688, 4091, 3875, 4710, 4151, 3870, 4709, 4094, 4430, 5603, 4690, 4050, 4150, 3889, 4051, 4110, 4250, 3928, 4052, 4063, 4130, 5668, 4506, 4490, 4909, 4208, 4505, 4834, 5192, 5088, 5177, 5142, 4348, 4751, 4817, 4836, 4837, 4893, 4894, 4835, 4870, 6408, 6410, 6411, 6412, 6421, 6428, 5592, 5594, 4589, 5597, 5614, 5684, 5685, 5728, 5729, 5753, 5754, 5772, 5773, 6631, 6509, 6671, 6670, 6669, 6668, 6732, 6731, 6730, 6729, 6728, 6710, 6708, 6709, 6148, 6190, 7289, 7288, 7108, 7248, 6948, 6808, 6788, 7928, 8468, 5674, 9289, 9290, 8095, 8169, 8093, 7749, 8328, 7910, 7908, 7752, 7754, 8090, 7868, 8317, 8618, 8168, 8312, 8529, 8311, 8313, 8637, 8643, 8494, 8710, 8813, 8599, 8590, 8530, 8308, 8309, 8315, 8316, 8489, 8491, 8508, 8510, 8511, 8513, 8514, 8515, 8528, 8531, 8534, 8600, 8644, 8720, 8721, 8940, 8711, 8814, 8933, 8936, 8935, 8708, 8934)
   
group by t.couponid,t1.users_id,t1.id) hb2 on hb1.batch_id=hb2.batch_id and hb1.users_id=hb2.users_id and hb1.yhq_id=hb2.yhq_id

left join(
select t1.couponbatchno batch_id,t1.userid users_id,t2.id yhq_id,
                    count(distinct t2.id) qcrm_ssnum,
                    count(distinct case
                          when t2.status = 1 then
                           t2.id
                          else
                           null
                        end) qcrm_usenum,
                     count(distinct case
                          when t2.status = 1 and  nvl(t2.INNERPID,'-') like '%无效%' then
                           t2.id
                          else
                           null
                        end) qcrm_ntktuse
               from hdb.crm_coupon_grant_detail t1
               join YHQ.CQ_NEW_YHQ_RELATION@to_air t2 on t1.couponbatchno =
                                                         t2.create_id
                                                     and t1.userid =
                                                         t2.users_id
              where t1.status = 1
			  and t1.couponbatchno in
               (4688, 4091, 3875, 4710, 4151, 3870, 4709, 4094, 4430, 5603, 4690, 4050, 4150, 3889, 4051, 4110, 4250, 3928, 4052, 4063, 4130, 5668, 4506, 4490, 4909, 4208, 4505, 4834, 5192, 5088, 5177, 5142, 4348, 4751, 4817, 4836, 4837, 4893, 4894, 4835, 4870, 6408, 6410, 6411, 6412, 6421, 6428, 5592, 5594, 4589, 5597, 5614, 5684, 5685, 5728, 5729, 5753, 5754, 5772, 5773, 6631, 6509, 6671, 6670, 6669, 6668, 6732, 6731, 6730, 6729, 6728, 6710, 6708, 6709, 6148, 6190, 7289, 7288, 7108, 7248, 6948, 6808, 6788, 7928, 8468, 5674, 9289, 9290, 8095, 8169, 8093, 7749, 8328, 7910, 7908, 7752, 7754, 8090, 7868, 8317, 8618, 8168, 8312, 8529, 8311, 8313, 8637, 8643, 8494, 8710, 8813, 8599, 8590, 8530, 8308, 8309, 8315, 8316, 8489, 8491, 8508, 8510, 8511, 8513, 8514, 8515, 8528, 8531, 8534, 8600, 8644, 8720, 8721, 8940, 8711, 8814, 8933, 8936, 8935, 8708, 8934)
            group by t1.couponbatchno,t1.userid,t2.id) hb3 on hb1.batch_id=hb3.batch_id and hb1.users_id=hb3.users_id and hb1.yhq_id=hb3.yhq_id	
 --left join dw.bi_yhq_use hb4  on hb1.yhq_id=hb4.yhq_id
 where  hb1.usenum-hb1.nusenum>nvl(hb2.crm_usenum,0)-nvl(hb2.crm_nusenum,0)+nvl(hb3.qcrm_usenum,0)-nvl(hb3.qcrm_ntktuse,0)
   and hb1.usenum-hb1.nusenum>0;
