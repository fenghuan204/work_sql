select  case when t1.flights_date>=to_date('2015-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2016-07-01','yyyy-mm-dd') then '2016'
    when t1.flights_date>=to_date('2016-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2017-07-01','yyyy-mm-dd') then '2017'
    end 日期类型,to_char(t1.flights_date,'yyyymm') 航班月,

case when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id in(3,8) then 'IOS'
            when t1.channel='手机' and t1.station_id in(4,9) then 'Andriod'
            else t1.channel end 渠道,case when t1.is_swj=0 then '否'
            else '是' end 是否商务经济座,
            t1.seats_name 舱位,case when t1.sex=3 then 'YE'
            when t1.seats_name in('P2','P3','P4','P5') then '活动舱'
            when t1.seats_name in('P','P1','R1','R2','R3','R4') then 'PR舱'
            when t1.seats_name in('E','U','X') then 'EUX舱'
            when t1.seats_name in('A','D','Z','I','J','O') then '特殊舱位'
            else '5折以上舱位' end 舱位类型,
            case when t1.seats_name in('B','G','G1','G2') then '团队'
            else '散客' end 团散类型,
            t2.nationflag 航线性质,t2.originairport_name 始发站,t2.destairport_name 目的站,
            t2.segment_country 航线国家,t2.flights_segment_name 航线,
            t6.wf_city_name 往返航线,
            case when t1.channel in('手机','网站') and t5.users_id is not null then '代理'
            else '非代理' end  是否代理,
            case when t8.paytogether is null then '未购买行李'
            when t8.paytogether =0 then '一次'
            else '二次' end 购买场景,
            t8.bookprice,
            t8.luggage,
            sum(case when t1.seats_name is not null then 1 else  0 end) 销量,
            sum(t1.ticket_price) 机票金额,
            sum(t1.price) 民航公布价和,
            sum(t8.booknum) 产品数量,
            sum(t8.bookfee) 产品金额
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.da_restrict_userinfo t5 on t1.client_id=t5.users_id
  left join dw.adt_wf_segment t6 on t2.route_id=t6.route_id
  left join (select t7.flights_order_head_id,sum(t7.pay_together) paytogether,sum(t7.book_price) bookprice,sum(t7.luggage_weight) luggage,sum(t7.book_num) booknum,sum(t7.book_fee)
  bookfee
                from dw.fact_other_order_detail t7 
                where t7.flights_date>=to_date('2015-11-01','yyyy-mm-dd')
                  and t7.flights_date< to_date('2017-07-01','yyyy-mm-dd')
                  and to_char(t7.flights_date,'mm') in('11','12','01','06','02','03','04','05')
                  and t7.company_id=0
                  and t7.xtype_id in(6,10,17)
				  and t7.flag_Id=40
                  group by t7.flights_order_head_id)t8 on t1.flights_order_head_Id=t8.flights_order_head_id
  where t1.flights_date>=to_date('2015-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2017-07-01','yyyy-mm-dd')
    and t2.flag<>2
	and t1.flag_id =40
    and to_char(t1.flights_date,'mm') in('11','12','01','06','02','03','04','05')
    and t1.whole_flight like '9C%'
   group by case when t1.flights_date>=to_date('2015-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2016-07-01','yyyy-mm-dd') then '2016'
    when t1.flights_date>=to_date('2016-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2017-07-01','yyyy-mm-dd') then '2017'
    end,to_char(t1.flights_date,'yyyymm'),
   
   case when t1.flights_date>=to_date('2015-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2016-07-01','yyyy-mm-dd') then '2016'
    when t1.flights_date>=to_date('2016-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2017-07-01','yyyy-mm-dd') then '2017'
    end ,to_char(t1.flights_date,'yyyymm'), 

case when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id in(3,8) then 'IOS'
            when t1.channel='手机' and t1.station_id in(4,9) then 'Andriod'
            else t1.channel end ,case when t1.is_swj=0 then '否'
            else '是' end ,
            t1.seats_name ,case when t1.sex=3 then 'YE'
            when t1.seats_name in('P2','P3','P4','P5') then '活动舱'
            when t1.seats_name in('P','P1','R1','R2','R3','R4') then 'PR舱'
            when t1.seats_name in('E','U','X') then 'EUX舱'
            when t1.seats_name in('A','D','Z','I','J','O') then '特殊舱位'
            else '5折以上舱位' end,
            case when t1.seats_name in('B','G','G1','G2') then '团队'
            else '散客' end ,
            t2.nationflag ,t2.originairport_name ,t2.destairport_name ,
            t2.segment_country ,t2.flights_segment_name ,
            t6.wf_city_name ,
            case when t1.channel in('手机','网站') and t5.users_id is not null then '代理'
            else '非代理' end ,
            t8.bookprice,
            t8.luggage,case when t8.paytogether is null then '未购买行李'
            when t8.paytogether =0 then '一次'
            else '二次' end
			
			
---

select  case when t1.flights_date>=to_date('2015-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2016-07-01','yyyy-mm-dd') then '2016'
    when t1.flights_date>=to_date('2016-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2017-07-01','yyyy-mm-dd') then '2017'
    end 日期类型,to_char(t1.flights_date,'yyyymm') 航班月,
case when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id in(3,8) then 'IOS'
            when t1.channel='手机' and t1.station_id in(4,9) then 'Andriod'
            else t1.channel end 主订单渠道,
case when t7.channel='手机' and t7.station_id =2 then 'M网站'
            when t7.channel='手机' and t7.station_id in(5,10) then '微信'
            when t7.channel='手机' and t7.station_id in(3,8) then 'IOS'
            when t7.channel='手机' and t7.station_id in(4,9) then 'Andriod'
            else t7.channel end 辅收订单渠道,
      case when t7.flights_date-t7.order_day<=0 then '00'
      when t7.flights_date-t7.order_day<=1  then '01'
      when t7.flights_date-t7.order_day<=2  then '02'
      when t7.flights_date-t7.order_day<=3  then '03'
      else '03+' end 行李购买提前期,      
      case when t1.is_swj=0 then '否'
            else '是' end 是否商务经济座,
            t1.seats_name 舱位,case when t1.sex=3 then 'YE'
            when t1.seats_name in('P2','P3','P4','P5') then '活动舱'
            when t1.seats_name in('P','P1','R1','R2','R3','R4') then 'PR舱'
            when t1.seats_name in('E','U','X') then 'EUX舱'
            when t1.seats_name in('A','D','Z','I','J','O') then '特殊舱位'
            else '5折以上舱位' end 舱位类型,
            case when t1.seats_name in('B','G','G1','G2') then '团队'
            else '散客' end 团散类型,
            t2.nationflag 航线性质,t2.originairport_name 始发站,t2.destairport_name 目的站,
            t2.segment_country 航线国家,t2.flights_segment_name 航线,
            t6.wf_city_name 往返航线,
            case when t1.channel in('手机','网站') and t5.users_id is not null then '代理'
            else '非代理' end  ,
            case when t7.pay_together=0 then '一次'
            when t7.pay_together>=1 then '二次'
            end 购买场景,
            t7.book_price,
            t7.luggage_weight,
            sum(t7.book_num) 产品数量,
            sum(t7.book_fee) 产品金额
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  join dw.fact_other_order_detail t7 on t1.flights_order_head_Id=t7.flights_order_head_Id
  left join dw.da_restrict_userinfo t5 on t1.client_id=t5.users_id
  left join dw.adt_wf_segment t6 on t2.route_id=t6.route_id
  where t1.flights_date>=to_date('2015-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2017-07-01','yyyy-mm-dd')
    and t2.flag<>2
  and t7.xtype_id in(6,10,17)
    and to_char(t1.flights_date,'mm') in('11','12','01','06','02','03','04','05')
    and t1.whole_flight like '9C%'
   group by case when t1.flights_date>=to_date('2015-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2016-07-01','yyyy-mm-dd') then '2016'
    when t1.flights_date>=to_date('2016-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2017-07-01','yyyy-mm-dd') then '2017'
    end ,to_char(t1.flights_date,'yyyymm') ,
case when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id in(3,8) then 'IOS'
            when t1.channel='手机' and t1.station_id in(4,9) then 'Andriod'
            else t1.channel end ,
case when t7.channel='手机' and t7.station_id =2 then 'M网站'
            when t7.channel='手机' and t7.station_id in(5,10) then '微信'
            when t7.channel='手机' and t7.station_id in(3,8) then 'IOS'
            when t7.channel='手机' and t7.station_id in(4,9) then 'Andriod'
            else t7.channel end ,
      case when t7.flights_date-t7.order_day<=0 then '00'
      when t7.flights_date-t7.order_day<=1  then '01'
      when t7.flights_date-t7.order_day<=2  then '02'
      when t7.flights_date-t7.order_day<=3  then '03'
      else '03+' end ,      
      case when t1.is_swj=0 then '否'
            else '是' end ,
            t1.seats_name ,case when t1.sex=3 then 'YE'
            when t1.seats_name in('P2','P3','P4','P5') then '活动舱'
            when t1.seats_name in('P','P1','R1','R2','R3','R4') then 'PR舱'
            when t1.seats_name in('E','U','X') then 'EUX舱'
            when t1.seats_name in('A','D','Z','I','J','O') then '特殊舱位'
            else '5折以上舱位' end ,
            case when t1.seats_name in('B','G','G1','G2') then '团队'
            else '散客' end ,
            t2.nationflag ,t2.originairport_name ,t2.destairport_name ,
            t2.segment_country ,t2.flights_segment_name ,
            t6.wf_city_name ,
            case when t1.channel in('手机','网站') and t5.users_id is not null then '代理'
            else '非代理' end  ,
            case when t7.pay_together=0 then '一次'
            when t7.pay_together>=1 then '二次'
            end,
            t7.book_price,
            t7.luggage_weight
			
			
-------



select  case when t1.flights_date>=to_date('2015-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2016-07-01','yyyy-mm-dd') then '2016'
    when t1.flights_date>=to_date('2016-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2017-07-01','yyyy-mm-dd') then '2017'
    end 日期类型,to_char(t1.flights_date,'yyyymm') 航班月,
case when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id in(3,8) then 'IOS'
            when t1.channel='手机' and t1.station_id in(4,9) then 'Andriod'
            else t1.channel end 主订单渠道,
case when t7.channel='手机' and t7.station_id =2 then 'M网站'
            when t7.channel='手机' and t7.station_id in(5,10) then '微信'
            when t7.channel='手机' and t7.station_id in(3,8) then 'IOS'
            when t7.channel='手机' and t7.station_id in(4,9) then 'Andriod'
            else t7.channel end 辅收订单渠道,
      case when t7.flights_date-t7.order_day<=0 then '00'
      when t7.flights_date-t7.order_day<=1  then '01'
      when t7.flights_date-t7.order_day<=2  then '02'
      when t7.flights_date-t7.order_day<=3  then '03'
      else '03+' end 行李购买提前期,      
      case when t1.is_swj=0 then '否'
            else '是' end 是否商务经济座,
            t1.seats_name 舱位,case when t1.sex=3 then 'YE'
            when t1.seats_name in('P2','P3','P4','P5') then '活动舱'
            when t1.seats_name in('P','P1','R1','R2','R3','R4') then 'PR舱'
            when t1.seats_name in('E','U','X') then 'EUX舱'
            when t1.seats_name in('A','D','Z','I','J','O') then '特殊舱位'
            else '5折以上舱位' end 舱位类型,
            case when t1.seats_name in('B','G','G1','G2') then '团队'
            else '散客' end 团散类型,
            t2.nationflag 航线性质,t2.originairport_name 始发站,t2.destairport_name 目的站,
            t2.segment_country 航线国家,t2.flights_segment_name 航线,
            t6.wf_city_name 往返航线,
            case when t1.channel in('手机','网站') and t5.users_id is not null then '代理'
            else '非代理' end  代理与否,
            case when t7.pay_together=0 then '一次'
            when t7.pay_together>=1 then '二次'
            end 购买场景,
			case when t7.xtype_id in(6,10,17)  then '网上逾重'
			when t7.xtype_id=24 then '现场行李扫码' end 行李类型,
            t7.book_price,
            t7.luggage_weight,
            sum(t7.book_num) 产品数量,
            sum(t7.book_fee) 产品金额
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  join dw.fact_other_order_detail t7 on t1.flights_order_head_Id=t7.flights_order_head_Id
  left join dw.da_restrict_userinfo t5 on t1.client_id=t5.users_id
  left join dw.adt_wf_segment t6 on t2.route_id=t6.route_id
  where t1.flights_date>=to_date('2015-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2017-07-01','yyyy-mm-dd')
    and t2.flag<>2
    and t7.xtype_id in(6,10,17,24)
    and to_char(t1.flights_date,'mm') in('11','12','01','06','02','03','04','05')
    and t1.whole_flight like '9C%'
   group by case when t1.flights_date>=to_date('2015-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2016-07-01','yyyy-mm-dd') then '2016'
    when t1.flights_date>=to_date('2016-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2017-07-01','yyyy-mm-dd') then '2017'
    end ,to_char(t1.flights_date,'yyyymm') ,
case when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id in(3,8) then 'IOS'
            when t1.channel='手机' and t1.station_id in(4,9) then 'Andriod'
            else t1.channel end ,
case when t7.channel='手机' and t7.station_id =2 then 'M网站'
            when t7.channel='手机' and t7.station_id in(5,10) then '微信'
            when t7.channel='手机' and t7.station_id in(3,8) then 'IOS'
            when t7.channel='手机' and t7.station_id in(4,9) then 'Andriod'
            else t7.channel end ,
      case when t7.flights_date-t7.order_day<=0 then '00'
      when t7.flights_date-t7.order_day<=1  then '01'
      when t7.flights_date-t7.order_day<=2  then '02'
      when t7.flights_date-t7.order_day<=3  then '03'
      else '03+' end ,      
      case when t1.is_swj=0 then '否'
            else '是' end ,
            t1.seats_name ,case when t1.sex=3 then 'YE'
            when t1.seats_name in('P2','P3','P4','P5') then '活动舱'
            when t1.seats_name in('P','P1','R1','R2','R3','R4') then 'PR舱'
            when t1.seats_name in('E','U','X') then 'EUX舱'
            when t1.seats_name in('A','D','Z','I','J','O') then '特殊舱位'
            else '5折以上舱位' end ,
            case when t1.seats_name in('B','G','G1','G2') then '团队'
            else '散客' end ,
            t2.nationflag ,t2.originairport_name ,t2.destairport_name ,
            t2.segment_country ,t2.flights_segment_name ,
            t6.wf_city_name ,
            case when t1.channel in('手机','网站') and t5.users_id is not null then '代理'
            else '非代理' end  ,
            case when t7.pay_together=0 then '一次'
            when t7.pay_together>=1 then '二次'
            end,
            t7.book_price,
            t7.luggage_weight,case when t7.xtype_id in(6,10,17)  then '网上逾重'
			when t7.xtype_id=24 then '现场行李扫码' end 
			
