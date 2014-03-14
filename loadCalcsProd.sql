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
,acs.volume_amt
,substr(acs.dataset,instr(acs.dataset, '\')+1, instr(acs.dataset, '_',1,2)-instr(acs.dataset, '\')-1)
, ACS.PLANE_HEIGHT
, ACS.AREA_2D_AMT 
, ACS.AREA_3D_AMT  
from AREA_VOLUME_CALC_stage acs, sites s
where upper(substr(acs.dataset,instr(acs.dataset, '_', 1, 2)+1, instr(acs.dataset, '_',1,3)-instr(acs.dataset, '_', 1, 2)-1)) = S.GCMRC_SITE_ID

commit;

select 'end time: ' || systimestamp from dual;
