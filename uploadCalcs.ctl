options (skip=1)
load data
infile 'sandbarfiles.txt'
append
into table area_volume_calc_stage
when dataset <> 'Dataset'
fields terminated by ","
(dataset
,plane_height
,reference filler
,z_factor filler
,area_2d_amt "trim(:area_2d_amt)"
,area_3d_amt "trim(:area_3d_amt)"
,volume_amt  TERMINATED BY WHITESPACE "trim(:volume_amt)"
)