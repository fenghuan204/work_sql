  
  select 'ÍËÆ±',sum(t1.money_fy)
 from dw.da_order_drawback t1
 where t1.money_terminal in(300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505)
   and t1.money_date>=to_date('2020-01-01','yyyy-mm-dd')
   and t1.money_date< to_date('2020-07-01','yyyy-mm-dd')
   
   
   union all
   
 select '¸ÄÇ©', sum(t2.money_fy * t2.RATE)
   from dw.da_order_change t2
   join stg.s_cq_user t3 on t2.users_id = t3.users_id
  where t3.terminal_id in(300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505)
    and t2.modify_date >= to_date('2019-01-01', 'yyyy-mm-dd')
  and t2.modify_date < to_date('2020-01-01', 'yyyy-mm-dd');

