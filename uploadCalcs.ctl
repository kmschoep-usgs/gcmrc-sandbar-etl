options (skip=1)
load data
into table area_volume_calc_stage
truncate
fields terminated by ","
trailing nullcols
(dataset
,plane_height
,reference filler
,z_factor filler
,area_2d_amt
,area_3d_amt
,volume_amt
)