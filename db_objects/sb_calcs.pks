CREATE OR REPLACE package sb_calcs as
function f_elev (p_site_id in number, p_ds in number) return number;
function f_get_area_vol_tf (p_site_id in number, p_ds_min IN NUMBER, p_ds_max in number) RETURN t_av_tab;
end;