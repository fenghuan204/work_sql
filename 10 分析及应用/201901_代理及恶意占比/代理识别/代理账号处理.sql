select  count(distinct t1.users_id),count(distinct t2.user_id)
from dw.da_restrict_userinfo t1
left join cqsale.cq_user_restrict@to_air t2 on t1.users_id=t2.user_id and t2.flag in(4,5)

