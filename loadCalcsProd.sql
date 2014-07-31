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
,area_3d_amt
,prev_plane_height
,next_plane_height)
with avc_stg as
(select 
s.site_id
,s.sandbar_id
,to_date(substr(acs.dataset,-8),'yyyymmdd') calc_date
,case when upper(acs.volume_amt) like '%E%' then to_number(upper(acs.volume_amt),'99999999999999.999999999999999999EEEE') else to_number(acs.volume_amt) 
end volume_amt
,substr(acs.dataset,instr(acs.dataset, '\')+1, instr(acs.dataset, '_',1,2)-instr(acs.dataset, '\')-1) calc_type
, acs.plane_height
, acs.area_2d_amt 
, acs.area_3d_amt  
from area_volume_calc_stage acs, 
(select s.id site_id, S.GCMRC_SITE_ID, ss.sandbar_name, ss.id sandbar_id from
sites s, SITE_SANDBAR_REL ss
where s.id = ss.site_id(+)) s
where upper(substr(acs.dataset,instr(acs.dataset, '_', 1, 2)+1, instr(acs.dataset, '_',1,3)-instr(acs.dataset, '_', 1, 2)-1)) = s.gcmrc_site_id
and 
(substr(acs.dataset,instr(acs.dataset, '\')+1, instr(acs.dataset, '_',1,2)-instr(acs.dataset, '\')-1) like '%eddy%' and
nvl(case rtrim(replace(substr(acs.dataset,instr(acs.dataset, '_', 1, 3)+1), substr(acs.dataset,-8), null),'_') when cast('r' as nvarchar2(20)) then 'reatt' when cast('s' as nvarchar2(20)) then 'sep'  end,'x') =  nvl(S.SANDBAR_NAME,'x'))
union
select 
s.id site_id
,null sandbar_id
,to_date(substr(acs.dataset,-8),'yyyymmdd') calc_date
,case when upper(acs.volume_amt) like '%E%' then to_number(upper(acs.volume_amt),'99999999999999.999999999999999999EEEE') else to_number(acs.volume_amt) 
end volume_amt
,substr(acs.dataset,instr(acs.dataset, '\')+1, instr(acs.dataset, '_',1,2)-instr(acs.dataset, '\')-1) calc_type
, acs.plane_height
, acs.area_2d_amt 
, acs.area_3d_amt  
from area_volume_calc_stage acs, sites s
where upper(substr(acs.dataset,instr(acs.dataset, '_', 1, 2)+1, instr(acs.dataset, '_',1,3)-instr(acs.dataset, '_', 1, 2)-1)) = s.gcmrc_site_id
and 
substr(acs.dataset,instr(acs.dataset, '\')+1, instr(acs.dataset, '_',1,2)-instr(acs.dataset, '\')-1) like '%chan%'),
surv as
(select
astg.site_id
,astg.sandbar_id
, astg.plane_height
, astg.calc_date
, astg.calc_type
, astg.area_2d_amt
, astg.area_3d_amt
, astg.volume_amt
from avc_stg astg
where astg.calc_type in ('eddy','chan')
) ,
surf as 
(select 
av.site_id
, av.sandbar_id
, av.plane_height
, av.calc_date
, av.calc_type
, av.area_2d_amt
, av.area_3d_amt
, av.volume_amt
from avc_stg av
where av.calc_type in ('mineddy','minchan')
) 
select 
surv.site_id,
surv.sandbar_id, 
surv.calc_date,
surf.volume_amt - surv.volume_amt volume_amt,
surv.calc_type,
surv.plane_height ,
surv.area_2d_amt ,
surv.area_3d_amt ,
lag(surv.plane_height, 1, 0) over (partition by surv.site_id, surv.sandbar_id, surv.calc_type, surv.calc_date order by surv.site_id, surv.sandbar_id, surv.calc_type, surv.calc_date, surv.plane_height) prev_plane_height,
nvl(lead(surv.plane_height, 1) over (partition by surv.site_id, surv.sandbar_id, surv.calc_type, surv.calc_date order by surv.site_id, surv.sandbar_id, surv.calc_type, surv.calc_date, surv.plane_height), surv.plane_height) next_plane_height 
from surv, surf
where surv.calc_type in ('chan','eddy')
and surv.site_id = surf.site_id
and nvl(surv.sandbar_id, -9) = nvl(surf.sandbar_id,-9)
and surv.plane_height = surf.plane_height
and replace(surf.calc_type, surv.calc_type,null) = 'min'
order by surv.calc_type, surv.calc_date, surv.plane_height;

commit;

select 'end time: ' || systimestamp from dual;
