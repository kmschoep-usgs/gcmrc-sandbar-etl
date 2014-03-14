options (skip=1)
load data
truncate
fields terminated by ","
trailing nullcols
into table area_volume_calc_stage
when dataset <> 'Dataset'
(dataset
,plane_height
,reference filler
,z_factor filler
,area_2d_amt "trim(:area_2d_amt)"
,area_3d_amt "trim(:area_3d_amt)"
,volume_amt "trim(:volume_amt)"
)