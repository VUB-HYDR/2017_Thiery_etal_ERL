
% --------------------------------------------------------------------
% subroutine to load the variables
% note: preferably run "main"
% --------------------------------------------------------------------



% --------------------------------------------------------------------
% Load observational data
% --------------------------------------------------------------------


% load overshooting top detection data
load('mw_OT_msg');



% --------------------------------------------------------------------
% Load CCLM² model data - present-day
% --------------------------------------------------------------------


if flags.conc == 1

    
% load lake surface temperature data for lake mask
[ ~, ~, T_S_LAKE_FLa] = mf_load('1996-2008_FLake_out02_timmean.nc', 'T_S_LAKE', nc);


% load 2D model output - nighttime/daytime daily means
[lat_mod, lon_mod, TOT_PREC_FLa_n] = mf_load('1996-2008_FLake_out03_TOT_PREC_night_2209_daysum.nc', 'TOT_PREC', nc);
[      ~,       ~, TOT_PREC_FLa_d] = mf_load('1996-2008_FLake_out03_TOT_PREC_day_daysum.nc'       , 'TOT_PREC', nc);


% convert precipitation units from mm/9h (or mm/6h) to mm/h
TOT_PREC_FLa_d = TOT_PREC_FLa_d  ./ 6;
TOT_PREC_FLa_n = TOT_PREC_FLa_n  ./ 9;


end


% --------------------------------------------------------------------
% Load TRMM observational data - present-day
% --------------------------------------------------------------------


if flags.conc == 1

    
% load and structure TRMM precipitation observations
[~, ~, TOT_PREC_TRMM_d] = mf_load('TRMM_3hourly_day_daysum.nc'       , 'pcp', nc);
[~, ~, TOT_PREC_TRMM_n] = mf_load('TRMM_3hourly_night_0009_daysum.nc', 'pcp', nc);


% convert units from mm/9h (or mm/6h) to mm/h
TOT_PREC_TRMM_n = TOT_PREC_TRMM_n ./ 9;
TOT_PREC_TRMM_d = TOT_PREC_TRMM_d ./ 6;


end



