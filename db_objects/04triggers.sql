/*   run as sandbar user */

create or replace trigger area_volume_calc_stage_tr
before insert on area_volume_calc_stage
for each row
when (
new.id is null
      )
begin
        select area_volume_calc_stage_sq.nextval
        into :new.id from dual;
    end;
/


create or replace trigger area_volume_calc_tr
before insert on area_volume_calc
for each row
when (
new.id is null
      )
begin
        select area_volume_calc_sq.nextval
        into :new.id from dual;
    end;
/


create or replace trigger django_flatpage_sites_tr
before insert on django_flatpage_sites
for each row
when (
new.id is null
      )
begin
        select django_flatpage_sites_sq.nextval
        into :new.id from dual;
    end;
/


create or replace trigger django_flatpage_tr
before insert on django_flatpage
for each row
when (
new.id is null
      )
begin
        select django_flatpage_sq.nextval
        into :new.id from dual;
    end;
/


create or replace trigger django_site_tr
before insert on django_site
for each row
when (
new.id is null
      )
begin
        select django_site_sq.nextval
        into :new.id from dual;
    end;
/


create or replace trigger sites_tr
before insert on sites
for each row
when (
new.id is null
      )
begin
        select sites_sq.nextval
        into :new.id from dual;
    end;
/


create or replace trigger site_sandbar_rel_tr
before insert on site_sandbar_rel
for each row
when (
new.id is null
      )
begin
        select site_sandbar_rel_sq.nextval
        into :new.id from dual;
    end;
/


create or replace trigger surveys_tr
before insert on surveys
for each row
when (
new.id is null
      )
begin
        select surveys_sq.nextval
        into :new.id from dual;
    end;
/
