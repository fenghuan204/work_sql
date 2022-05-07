1、4等分（4分位数）

SELECT region_id,
       cust_nbr,
       SUM(tot_sales) cust_sales,
       NTILE(4) OVER(ORDER BY SUM(tot_sales) DESC) sales_quartile
  FROM orders
 WHERE year = 2001
 GROUP BY region_id, cust_nbr
 ORDER BY sales_quartile, cust_sales DESC;

Ntile()over()

2、等宽函数
SELECT region_id,
       cust_nbr,

       SUM(tot_sales) cust_sales,
       WIDTH_BUCKET(SUM(tot_sales), 1, 3000000, 3) sales_buckets
  FROM orders
 WHERE year = 2001
 GROUP BY region_id, cust_nbr
 ORDER BY cust_sales;

Width_bucket()


3、列转行函数

with temp as(  
  select 'China' nation ,'Guangzhou' city from dual union all  
  select 'China' nation ,'Shanghai' city from dual union all  
  select 'China' nation ,'Beijing' city from dual union all  
  select 'USA' nation ,'New York' city from dual union all  
  select 'USA' nation ,'Bostom' city from dual union all  
  select 'Japan' nation ,'Tokyo' city from dual   
)  
select nation,listagg(city,',') within GROUP (order by city)  
from temp  
group by nation


4、累计数据

在每一行取得每月销售金额的合计。


select o.month,
       sum(o.tot_sales) monthly_sales,
       sum(sum(o.tot_sales)) over(order by o.month rows between unbounded preceding and unbounded following) total_sales1,
       sum(sum(o.tot_sales)) over() total_sales2
  from orders o
 where o.year = 2001
   and o.region_id = 6
 group by o.month
 order by o.month;
 
 
每一行显示，到目前为止最大的值。
 
 select o.month,
       sum(o.tot_sales) monthly_sales,
       max(sum(o.tot_sales)) over(order by o.month rows between unbounded preceding and current row) max_preceeding
  from orders o
 where o.year = 2001
   and o.region_id = 6
 group by o.month
 order by o.month;
 
 
 前面我们说过，窗口函数不单适用于指定记录集进行统计，而且也能适用于指定范围进行统计的情况，例如下面这个SQL语句就统计了当天销售额和五天内的评价销售额：

 select trunc(order_dt) day,
             sum(sale_price) daily_sales,
             avg(sum(sale_price)) over (order by trunc(order_dt)
                      range between interval '2' day preceding 
                                     and interval '2' day following) five_day_avg
   from cust_order
 where sale_price is not null 
     and order_dt between to_date('01-jul-2001','dd-mon-yyyy')
     and to_date('31-jul-2001','dd-mon-yyyy')

为了对指定范围进行统计，Oracle使用关键字range、interval来指定一个范围。上面的例子告诉Oracle查找当前日期的前2天，后2天范围内的记录，并统计其销售平均值。


Oracle提供了2个额外的函数：first_value、last_value，用于在窗口记录集中查找第一条记录和最后一条记录。假设我们的报表需要显示当前月、上一个月、后一个月的销售情况，以及每3
个月的销售平均值，这两个函数就可以派上用场了。
select month,
             first_value(sum(tot_sales)) over (order by month 
                                    rows between 1 preceding and 1 following) prev_month,
 
             sum(tot_sales) monthly_sales,
 
             last_value(sum(tot_sales)) over (order by month 
                                  rows between 1 preceding and 1 following) next_month,
 
             avg(sum(tot_sales)) over (order by month 
                                 rows between 1 preceding and 1 following) rolling_avg
    from orders
 where year = 2001 
      and region_id = 6
  group by month
 order by month;


 select month,
  2         sum(tot_sales) month_sales,
  3         sum(sum(tot_sales)) over(order by month
  4           rows between unbounded preceding and current row) current_total_sales
  5    from orders
  6   group by month;
 
 
 #窗口函数进阶－比较相邻记录
 
 select  month,            
          sum(tot_sales) monthly_sales,
          lag(sum(tot_sales), 1) over (order by month) prev_month_sales
   from orders
 where year = 2001
      and region_id = 6
  group by month
 order by month;
