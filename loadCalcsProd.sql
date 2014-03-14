show user;
set timing on;
set serveroutput on;
whenever sqlerror exit failure rollback;
whenever oserror exit failure rollback;
select 'start time: ' || systimestamp from dual;

insert into area_volume_calc (
site_id
,sandbar_id
,calc_date
,volume_amt
,calc_type
,plane_height
,area_2d_amt
,area_3d_amt)
select 
s.id 
,null 
,to_date(substr(acs.dataset,instr(acs.dataset, '_', 1, 3)+1),'yyyymmdd')
,case when upper(acs.volume_amt) like '%E%' then to_number(upper(acs.volume_amt),'99999999999999.999999999999999999EEEE') else to_number(acs.volume_amt) 
end
,substr(acs.dataset,instr(acs.dataset, '\')+1, instr(acs.dataset, '_',1,2)-instr(acs.dataset, '\')-1)
, acs.plane_height
, acs.area_2d_amt 
, acs.area_3d_amt  
from area_volume_calc_stage acs, sites s
where upper(substr(acs.dataset,instr(acs.dataset, '_', 1, 2)+1, instr(acs.dataset, '_',1,3)-instr(acs.dataset, '_', 1, 2)-1)) = s.gcmrc_site_id;

commit;

select 'end time: ' || systimestamp from dual;
