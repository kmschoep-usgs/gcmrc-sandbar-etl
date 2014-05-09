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
min_surv as
(select 
site_id
, sandbar_id
, plane_height
, calc_date
, calc_type
 from 
(select
astg.site_id
,astg.sandbar_id
, astg.plane_height
, min(astg.plane_height) over (partition by astg.site_id, astg.sandbar_id, astg.calc_type, astg.calc_date) min_plane
, astg.calc_date
, astg.calc_type
, astg.area_2d_amt
, astg.area_3d_amt
, astg.volume_amt
from avc_stg astg
where astg.calc_type in ('eddy','chan')) min_ph
where site_id = min_ph.site_id and  
calc_type = min_ph.calc_type and 
calc_date = min_ph.calc_date and 
plane_height = min_ph.min_plane and
nvl(sandbar_id,-99) = nvl(min_ph.sandbar_id,-99)
) ,
min_surf as 
(select 
av.site_id
, av.sandbar_id
, av.plane_height
, min_surv.calc_date
, min_surv.calc_type
, av.area_2d_amt
, av.area_3d_amt
, av.volume_amt
from avc_stg av, min_surv 
where av.calc_type in ('mineddy','minchan')
and av.site_id = min_surv.site_id
and nvl(av.sandbar_id,-99) = nvl(min_surv.sandbar_id,-99)
and replace(av.calc_type, min_surv.calc_type,null) = 'min'
and av.plane_height = min_surv.plane_height
) 
select 
av.site_id,
av.sandbar_id, 
av.calc_date,
av.volume_amt - av2.volume_amt volume_amt,
av.calc_type,
av.plane_height ,
av.area_2d_amt ,
av.area_3d_amt ,
lag(av.plane_height, 1, 0) over (partition by av.site_id, av.sandbar, av.calc_type, av.calc_date order by av.site_id, av.sandbar, av.calc_type, av.calc_date, av.plane_height) prev_plane_height,
nvl(lead(av.plane_height, 1) over (partition by av.site_id, av.sandbar, av.calc_type, av.calc_date order by av.site_id, av.sandbar, av.calc_type, av.calc_date, av.plane_height), av.plane_height) next_plane_height 
from avc_stg av, min_surf av2
where av.calc_type in ('chan','eddy')
and av.site_id = av2.site_id
and av.calc_type = av2.calc_type
and av.calc_date = av2.calc_date
order by av.calc_type, av.calc_date, av.plane_height;

commit;

select 'end time: ' || systimestamp from dual;
