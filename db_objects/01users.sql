/* main user that owns the tables and other database objects */

create user sandbar
  identified by <password>
  default tablespace sandbar
  temporary tablespace temp
  profile default
  account unlock;
  -- 2 Roles for SANDBAR 
  grant connect to sandbar;
  grant resource to sandbar;
  alter user sandbar default role all;
  -- 8 System Privileges for SANDBAR 
  grant create database link to sandbar;
  grant create procedure to sandbar;
  grant create sequence to sandbar;
  grant create synonym to sandbar;
  grant create table to sandbar;
  grant create trigger to sandbar;
  grant create view to sandbar;
  grant unlimited tablespace to sandbar;
  -- 1 Tablespace Quota for SANDBAR 
  alter user sandbar quota unlimited on sandbar;
  
  
  /* Read-only user account that application connects as. */
  
  create user sandbar_user
  identified by <password>
  default tablespace sandbar
  temporary tablespace temp
  profile default
  account unlock;
  -- 2 Roles for SANDBAR_USER 
  grant connect to sandbar_user;
  grant resource to sandbar_user;
  alter user sandbar_user default role all;
  -- 3 System Privileges for SANDBAR_USER 
  grant create synonym to sandbar_user;
  grant create table to sandbar_user;
  grant unlimited tablespace to sandbar_user;
  -- 8 Object Privileges for SANDBAR_USER 
    grant select on sandbar.area_volume_calc to sandbar_user;
    grant select on sandbar.django_flatpage to sandbar_user;
    grant select on sandbar.django_flatpage_sites to sandbar_user;
    grant select on sandbar.django_site to sandbar_user;
    grant execute on sandbar.sb_calcs to sandbar_user;
    grant select on sandbar.sites to sandbar_user;
    grant select on sandbar.site_sandbar_rel to sandbar_user;
    grant select on sandbar.surveys to sandbar_user;
