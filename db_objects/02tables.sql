/*   run as sandbar user */

/* sites table */

create table sites
(
  id               number(11)     not null,
  river_mile       float(126)     not null,
  site_name        nvarchar2(128),
  deposit_type     nvarchar2(100),
  eddy_size        number(11),
  exp_ratio_8000   number(5,2),
  exp_ratio_45000  number(5,2),
  stage_change     number(5,2),
  sed_budget_reach nvarchar2(100),
  campsite         nvarchar2(3),
  geom             mdsys.sdo_geometry,
  river_side       nvarchar2(1),
  gcmrc_site_id    nvarchar2(5),
  gdaws_site_id    nvarchar2(40),
  cur_stage_relation       nvarchar2(200),
  stage_discharge_coeff_a  number(16,13)   not null,
  stage_discharge_coeff_b  number(15,13)   not null,
  stage_discharge_coeff_c  number(18,15)   not null,
  photo_from       nvarchar2(10),
  photo_view       nvarchar2(30),
  flow_direction   nvarchar2(30),
  image_name       nvarchar2(50),
  image_name_med   nvarchar2(50),
  image_name_small nvarchar2(50),
  p_month  nvarchar2(20),
  p_day    nvarchar2(2) ,
  p_year   nvarchar2(4) ,
  gdaws_site_display       nvarchar2(100),
  secondary_gdaws_site_id  nvarchar2(40),
  second_gdaws_site_disp   nvarchar2(100)       
);

create index sites_geom_id on sites
(geom)
indextype is mdsys.spatial_index;

create unique index sites_river_mile_53c27b9d_uniq on sites
(river_mile, site_name);


/* site_sandbar_rel table */

create table site_sandbar_rel
(
  id            number(11)  not null,
  site_id       number(11)  not null,
  sandbar_name  nvarchar2(20)
);


create index site_sandbar_rel_99732b5c on site_sandbar_rel
(site_id);

alter table site_sandbar_rel add (
  constraint site_sandbar_rel_site_id_2c218
  unique (site_id, sandbar_name)
  enable validate);


alter table site_sandbar_rel add (
  constraint site_id_refs_id_f82d7072 
  foreign key (site_id) 
  references sites (id)
  deferrable initially deferred
  enable validate);

/* surveys table */
create table surveys
(
  id             number(11)     not null,
  site_id        number(11)     not null,
  survey_date    date           not null,
  survey_method  nvarchar2(100),
  uncrt_a_8000   number(11)     not null,
  uncrt_b_8000   number(11)     not null,
  discharge      number(8,2)    not null,
  trip_date      date,
  calc_type      nvarchar2(20),
  sandbar_id     number(11)
);


create index surveys_99732b5c on surveys
(site_id);

alter table surveys add (
  constraint site_id_refs_id_12af096d 
  foreign key (site_id) 
  references sites (id)
  deferrable initially deferred
  enable validate);
  
/* area_volume_calc_stage table.  raw data are inserted here first */
  
create table area_volume_calc_stage
(
  id            number(11)      not null,
  plane_height  nvarchar2(100),
  area_2d_amt   nvarchar2(100),
  area_3d_amt   nvarchar2(100),
  volume_amt    nvarchar2(100),
  dataset       nvarchar2(100)
);

/* area_volume_calc table */

create table area_volume_calc
(
  id                 number(11)   not null,
  site_id            number(11)   not null,
  sandbar_id         number(11),
  calc_date          date         not null,
  volume_amt         number(20,9),
  calc_type          nvarchar2(15),
  plane_height       number(20,9),
  area_2d_amt        number(20,9),
  area_3d_amt        number(20,9),
  prev_plane_height  number(20,9),
  next_plane_height  number(20,9) 
);

create index area_volume_calc_6337347d on area_volume_calc
(sandbar_id);

create index area_volume_calc_99732b5c on area_volume_calc
(site_id);

alter table area_volume_calc add (
  constraint area_volume_calc_site_id_de48a
  unique (site_id, sandbar_id, calc_date, calc_type, plane_height, prev_plane_height, next_plane_height)
  enable validate);

alter table area_volume_calc add (
  constraint sandbar_id_refs_id_fc38602e 
  foreign key (sandbar_id) 
  references site_sandbar_rel (id)
  deferrable initially deferred
  enable validate);

alter table area_volume_calc add (
  constraint site_id_refs_id_3543b096 
  foreign key (site_id) 
  references sites (id)
  deferrable initially deferred
  enable validate);
  
/* Django-specific tables to manage static content */
  
/* django_site table */
  
create table django_site
(
  id      number(11),
  domain  nvarchar2(100),
  name    nvarchar2(50)
);

/* django_flatpage table */

create table django_flatpage
(
  id                     number(11),
  url                    nvarchar2(100),
  title                  nvarchar2(200),
  content                nclob,
  enable_comments        number(1),
  template_name          nvarchar2(70),
  registration_required  number(1)
);


create index django_flatpage_c379dc61 on django_flatpage
(url);

alter table django_flatpage add (
  check (enable_comments in (0,1))
  enable validate);

alter table django_flatpage add (
  check (registration_required in (0,1))
  enable validate);
  
/* django_flatpage_sites table */

create table django_flatpage_sites
(
  id           number(11),
  flatpage_id  number(11),
  site_id      number(11)
);

create index django_flatpage_sites_872c4601 on django_flatpage_sites
(flatpage_id);

create index django_flatpage_sites_99732b5c on django_flatpage_sites
(site_id);

alter table django_flatpage_sites add (
  unique (flatpage_id, site_id)
  enable validate);

alter table django_flatpage_sites add (
  constraint flatpage_id_refs_id_83cd0023 
  foreign key (flatpage_id) 
  references django_flatpage (id)
  deferrable initially deferred
  enable validate);

alter table django_flatpage_sites add (
  foreign key (site_id) 
  references django_site (id)
  deferrable initially deferred
  enable validate);

