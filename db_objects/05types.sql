/*   run as sandbar user */

create or replace type t_av_row  as object (
  site_id number, 
  calc_date date, 
  min_elev number,
  max_elev number,
  eddy_int_area number, 
  eddy_s_int_area number,
  eddy_r_int_area number,
  sum_reatt_sep_area number,
  eddy_int_volume number,
  eddy_s_int_volume number,
  eddy_r_int_volume number,
  sum_reatt_sep_vol number,
  eddy_vol_error_low number,
  eddy_s_vol_error_low number,
  eddy_r_vol_error_low number,
  sum_reatt_sep_vel number,
  eddy_vol_error_high number,
  eddy_s_vol_error_high number,
  eddy_r_vol_error_high number,
  sum_reatt_sep_veh number,
  dy_chan_int_vol varchar2(100),
  dy_eddy_int_vol varchar2(100),
  dy_eddy_s_vol varchar2(100),
  dy_eddy_r_vol varchar2(100),
  dy_eddy_sum_vol varchar2(100),
  dy_ts_int_vol varchar2(100),
  chan_int_area number,
  chan_int_volume number,
  chan_vol_error_low number,
  chan_vol_error_high number,
  ts_int_area number,
  ts_int_volume number,
  ts_vol_error_low number,
  ts_vol_error_high number
);
/


create or replace type t_av_tab is table of t_av_row;
/