select t.users_id,t1.ticket_id,t1.combo_price from anl.wb_baihuahua_user@to_dds t
LEFT JOIN DW.Fact_Unlimited_Combo t1 on t.users_id=t1.buy_user_id and t1.status<>2
