select *
 from cqsale.cq_flights_cost@to_air
 where flights_date=trunc(sysdate-1)
  and flights_segment in('KWLNGB','NGBKWL')
  
 
 
 select *
  from cqsale.cq_financial_qr@to_air
  where flights_date=trunc(sysdate-1)
  and flights_segment in('KWLNGB','NGBKWL');
