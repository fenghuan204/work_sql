  
 select t1.*,t2.name,t2.useid
 from(
 select  username,program,machine,client_info,case when client_info is  null
then case when machine ='wzm0226' then '192.168.0.226'
when machine ='SPRINGGROUP\003299PC' then '192.168.9.66'
when machine ='SPRINGGROUP\ITD-004858-1808' then '192.168.15.238'
when machine ='SPRINGGROUP\MMD-021349-1912' then '192.168.23.92' 
when machine ='SPRINGGROUP\SPRING809171730' then '192.168.15.177' 
when machine ='dwdb19280' then '192.168.192.80' 
when machine ='dwdg' then '192.168.0.107' 
when machine ='WORKGROUP\�¹��ػ�-DB' then '192.168.193.11' 
when machine ='WORKGROUP\WIN-YANJIUYUAN' then '192.168.193.15'
when machine ='SPRINGGROUP\018466PC' then '192.168.15.103'
when machine ='SPRINGGROUP\MMD-019647-1901' then '192.168.15.184'
end
else client_info end client_ip,
sys_context('userenv','ip_address') as ipadd
  from v$session s
  where username is not null)t1
  left join anl.wb_springgroup_ip t2 on t1.client_ip=t2.ip
  order by username,program,t1.machine
  
