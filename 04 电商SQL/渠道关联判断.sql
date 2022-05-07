--机票渠道
select c.part, c.channel, c.terminal
  from stg.s_cq_order t
  left join dw.da_channel_part c on c.terminal_id = t.terminal_id
                                and c.web_id = nvl(t.web_id, 0)
                                and c.station_id =
                                    (case when t.terminal_id < 0 and
                                     nvl(t.ex_nfd1, 0) <= 1 then 1 else
                                     nvl(t.ex_nfd1, 0) end)
                                and t.order_date >= c.sdate
                                and t.order_date < c.edate + 1;

--辅收渠道
select c.part, c.channel, c.terminal
  from stg.s_cq_other_order tb
  left join dw.da_channel_part c on c.terminal_id = tb.terminal_id
                                and c.web_id = nvl(tb.ext_1, 0)
                                and c.station_id =
                                    (case when tb.terminal_id < 0 and
                                     nvl(tb.ex_nfd1, 0) <= 1 then 1 else
                                     nvl(tb.ex_nfd1, 0) end)
                                and tb.order_date >= c.sdate
                                and tb.order_date < c.edate + 1;
								
---实时渠道数据	
select 
trunc(t.order_date),c.part, c.channel, c.terminal,t1.r_flights_date,t2.flights_segment_name,count(1)
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.da_channel_part c on c.terminal_id = t.terminal_id
                                and c.web_id = nvl(t.web_id, 0)
                                and c.station_id =
                                    (case when t.terminal_id < 0 and
                                     nvl(t.ex_nfd1, 0) <= 1 then 1 else
                                     nvl(t.ex_nfd1, 0) end)
                                and t.order_date >= c.sdate
                                and t.order_date < decode(c.edate,trunc(sysdate-1),trunc(sysdate),c.edate) + 1
   left join dw.da_restrict_userinfo t3 on t.client_id=t3.users_id
   where t.order_date>=trunc(sysdate-7)
    and trunc(t.order_date) in(trunc(sysdate-7),trunc(sysdate),trunc(sysdate-1))
    and t3.users_id is not null
    and t.client_Id>0
    and t1.whole_flight like '9C%'
    and t.web_id=0
    and t1.flag_id in(3,5,40,41)
    and to_char(t.order_date,'hh24:mi')< '13:00'
    group by trunc(t.order_date),c.part, c.channel, c.terminal,t1.r_flights_date,t2.flights_segment_name;
	
	
	
	

	
	
	
    

