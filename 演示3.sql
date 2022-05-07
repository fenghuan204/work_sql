select *
          from yhq.cq_yhq_combo_config@to_air
         where  valid_flag = 1
         and expiration_date=date'2022-06-30'