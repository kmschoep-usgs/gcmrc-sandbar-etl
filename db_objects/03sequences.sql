/*   run as sandbar user */

create sequence area_volume_calc_sq
  start with 876041
  maxvalue 9999999999999999999999999999
  minvalue 1
  nocycle
  cache 20
  noorder
  nokeep
  global;


create sequence area_volume_calc_stage_sq
  start with 1
  maxvalue 9999999999999999999999999999
  minvalue 1
  nocycle
  cache 20
  noorder
  nokeep
  global;


create sequence django_flatpage_sites_sq
  start with 1
  maxvalue 9999999999999999999999999999
  minvalue 1
  nocycle
  cache 20
  noorder
  nokeep
  global;


create sequence django_flatpage_sq
  start with 1
  maxvalue 9999999999999999999999999999
  minvalue 1
  nocycle
  cache 20
  noorder
  nokeep
  global;


create sequence django_site_sq
  start with 21
  maxvalue 9999999999999999999999999999
  minvalue 1
  nocycle
  cache 20
  noorder
  nokeep
  global;

create sequence sites_sq
  start with 1
  maxvalue 9999999999999999999999999999
  minvalue 1
  nocycle
  cache 20
  noorder
  nokeep
  global;


create sequence site_sandbar_rel_sq
  start with 1
  maxvalue 9999999999999999999999999999
  minvalue 1
  nocycle
  cache 20
  noorder
  nokeep
  global;


create sequence surveys_sq
  start with 1
  maxvalue 9999999999999999999999999999
  minvalue 1
  nocycle
  cache 20
  noorder
  nokeep
  global;
