
% --------------------------------------------------------------------
% Proff of concept: perform logistic regression on selected variables
% note: preferably run "main"
% --------------------------------------------------------------------



% --------------------------------------------------------------------
% manipulations: preprocessing
% --------------------------------------------------------------------


% create date vectors
date_vec_FLa  = datevec(datenum(time_begin_FLa ):1:datenum(time_end_FLa ));
date_vec_TRMM = datevec(datenum(time_begin_TRMM):1:datenum(time_end_TRMM));


% Create Lake Victoria mask - CCLM grid
isvict_mod                               = ~isnan(T_S_LAKE_FLa);
isvict_mod(lon_mod < lon_min_Vict_small) = 0; 
isvict_mod(lon_mod > lon_max_Vict_small) = 0;
isvict_mod(lat_mod < lat_min_Vict_small) = 0;
isvict_mod(lat_mod > lat_max_Vict_small) = 0;


% Create surrounding land mask - CCLM grid
issurr_mod                         = ~isvict_mod; % replace by "isnan(T_S_LAKE_FLa)" if you want to exclude Lake Albert etc.
issurr_mod(lon_mod < lon_min_Vict) = 0; 
issurr_mod(lon_mod > lon_max_Vict) = 0;
issurr_mod(lat_mod < lat_min_Vict) = 0;
issurr_mod(lat_mod > lat_max_Vict) = 0;


% get daytime dayly total/mean over-lake/over-land values
[~, TOT_PREC_TRMM_n_lp] = mf_fieldmean(TOT_PREC_TRMM_n, isvict_mod);
[~, TOT_PREC_TRMM_d_gp] = mf_fieldmean(TOT_PREC_TRMM_d, issurr_mod);
[~, TOT_PREC_TRMM_d_lp] = mf_fieldmean(TOT_PREC_TRMM_d, isvict_mod);
[~, TOT_PREC_FLa_n_lp ] = mf_fieldmean(TOT_PREC_FLa_n , isvict_mod);
[~, TOT_PREC_FLa_d_gp ] = mf_fieldmean(TOT_PREC_FLa_d , issurr_mod);
[~, TOT_PREC_FLa_d_lp ] = mf_fieldmean(TOT_PREC_FLa_d , isvict_mod);


% clean up
clear TOT_PREC_FLa_n TOT_PREC_FLa_d TOT_PREC_TRMM_n TOT_PREC_TRMM_d
      

% shift TOT_PREC array by 1 day to get the time lag you need for the causal relationship
TOT_PREC_TRMM_n_lp_shift      = circshift(TOT_PREC_TRMM_n_lp, -1);
TOT_PREC_FLa_n_lp_shift       = circshift(TOT_PREC_FLa_n_lp , -1);
TOT_PREC_TRMM_n_lp_shift(end) = NaN;
TOT_PREC_FLa_n_lp_shift(end)  = NaN;



% --------------------------------------------------------------------
% manipulations: regression
% --------------------------------------------------------------------


% compute thresholds as XXth percentile
threshold_TRMM = prctile(TOT_PREC_TRMM_n_lp, perc_severe);    % [mm/h]
threshold_FLa  = prctile(TOT_PREC_FLa_n_lp , perc_severe);    % [mm/h]


% Apply logistic regression and compute ROC curve
LOGR_OT   = mf_logreg(OT_d_gp           , OT_n_lp_shift           , date_vec_OT  , threshold_OT  , [], hours_day, lat_mod, lon_mod);
LOGR_TRMM = mf_logreg(TOT_PREC_TRMM_d_gp, TOT_PREC_TRMM_n_lp_shift, date_vec_TRMM, threshold_TRMM, [], hours_day, lat_mod, lon_mod);
LOGR_FLa  = mf_logreg(TOT_PREC_FLa_d_gp , TOT_PREC_FLa_n_lp_shift , date_vec_FLa , threshold_FLa , [], hours_day, lat_mod, lon_mod);


% Apply logistic regression and compute ROC curve - persistence forecast
%  note that the 'normal' time series is predicting the 'shifted' time  series (I checked and it seems ok)
LOGR_OT_pers   = mf_logreg(OT_n_lp_shift           , OT_n_lp           , date_vec_OT  , threshold_OT  , [], hours_day, lat_mod, lon_mod);
LOGR_TRMM_pers = mf_logreg(TOT_PREC_TRMM_n_lp_shift, TOT_PREC_TRMM_n_lp, date_vec_TRMM, threshold_TRMM, [], hours_day, lat_mod, lon_mod);
LOGR_FLa_pers  = mf_logreg(TOT_PREC_FLa_n_lp_shift , TOT_PREC_FLa_n_lp , date_vec_FLa , threshold_FLa , [], hours_day, lat_mod, lon_mod);


% Apply logistic regression and compute ROC curve
LOGR_OT_lp   = mf_logreg(OT_d_lp           , OT_n_lp_shift           , date_vec_OT  , threshold_OT  , [], hours_day, lat_reg, lon_reg);
LOGR_TRMM_lp = mf_logreg(TOT_PREC_TRMM_d_lp, TOT_PREC_TRMM_n_lp_shift, date_vec_TRMM, threshold_TRMM, [], hours_day, lat_mod, lon_mod);
LOGR_FLa_lp  = mf_logreg(TOT_PREC_FLa_d_lp , TOT_PREC_FLa_n_lp_shift , date_vec_FLa , threshold_FLa , [], hours_day, lat_mod, lon_mod);




