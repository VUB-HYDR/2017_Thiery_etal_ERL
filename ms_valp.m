
% --------------------------------------------------------------------
% Compute values used in the paper
% note: preferably run "main"
% --------------------------------------------------------------------


% clean up
clc;



% --------------------------------------------------------------------
% Methods: Proof of concept
% --------------------------------------------------------------------


if flags.conc == 1

% get 99th percentiles
threshold_OT_rounded   = round(threshold_OT         )
threshold_TRMM_rounded = round(threshold_TRMM .* 100) ./ 100
threshold_FLa_rounded  = round(threshold_FLa  .* 100) ./ 100

end



% --------------------------------------------------------------------
% Results: Proof of concept
% --------------------------------------------------------------------


if flags.conc == 1

% subset for overlapping years
OT_n_lp_0508            = OT_n_lp           (find(date_vec_OT  (:,1) == 2005, 1, 'first'):find(date_vec_OT  (:,1) == 2008, 1, 'last'));
OT_n_lp_0513            = OT_n_lp           (find(date_vec_OT  (:,1) == 2005, 1, 'first'):find(date_vec_OT  (:,1) == 2013, 1, 'last'));
TOT_PREC_TRMM_n_lp_0513 = TOT_PREC_TRMM_n_lp(find(date_vec_TRMM(:,1) == 2005, 1, 'first'):find(date_vec_TRMM(:,1) == 2013, 1, 'last'));
TOT_PREC_FLa_n_lp_0508  = TOT_PREC_FLa_n_lp (find(date_vec_FLa (:,1) == 2005, 1, 'first'):find(date_vec_FLa (:,1) == 2008, 1, 'last'));
TOT_PREC_TRMM_n_lp_0508 = TOT_PREC_TRMM_n_lp(find(date_vec_TRMM(:,1) == 2005, 1, 'first'):find(date_vec_TRMM(:,1) == 2008, 1, 'last'));
date_vec_0508           = date_vec_OT       (find(date_vec_OT  (:,1) == 2005, 1, 'first'):find(date_vec_OT  (:,1) == 2008, 1, 'last'),:);


% Get correlation between OTs and precip
[corr_spearman_OT_FLa , corr_spearman_OT_FLa_pval ] = corr(OT_n_lp_0508, TOT_PREC_FLa_n_lp_0508 , 'type','spearman', 'rows', 'pairwise');
[corr_spearman_OT_TRMM, corr_spearman_OT_TRMM_pval] = corr(OT_n_lp_0513, TOT_PREC_TRMM_n_lp_0513, 'type','spearman', 'rows', 'pairwise');
corr_spearman_OT_FLa  = round(corr_spearman_OT_FLa  .* 100) ./ 100;
corr_spearman_OT_TRMM = round(corr_spearman_OT_TRMM .* 100) ./ 100;


% case study: 16 May 2006
ind_0508 = 501; % 16/05/2006
ind_OT   = find(datenum(date_vec_OT)   == datenum(date_vec_0508(ind_0508,:))); % corresponding index in full time series
ind_TRMM = find(datenum(date_vec_TRMM) == datenum(date_vec_0508(ind_0508,:))); % corresponding index in full time series
ind_FLa  = find(datenum(date_vec_FLa)  == datenum(date_vec_0508(ind_0508,:))); % corresponding index in full time series

% what was measured that night?
OT_20060516   = OT_n_lp(ind_OT)
TRMM_20060516 = TOT_PREC_TRMM_n_lp(ind_TRMM)
FLa_20060516  = TOT_PREC_FLa_n_lp(ind_FLa)

% was it an extreme event?
OT_20060516_ext   = LOGR_OT.extr(ind_OT - 1)
TRMM_20060516_ext = LOGR_TRMM.extr(ind_TRMM - 1)
FLa_20060516_ext  = LOGR_FLa.extr(ind_FLa - 1)

% was it warned?
OT_20060516_warn   = LOGR_OT.warnings_opt(ind_OT - 1)
TRMM_20060516_warn = LOGR_TRMM.warnings_opt(ind_TRMM - 1)
FLa_20060516_warn  = LOGR_FLa.warnings_opt(ind_FLa - 1)


end



% --------------------------------------------------------------------
% Results: Tuning
% --------------------------------------------------------------------


if flags.tune == 1


% number of extremes actually occurring
extremes  = OT_n_lp_shift > threshold_OT;    
nextremes = length(find(extremes==1))


% number of extremes captured by the optimal point (computed in two ways)
nhits = nextremes .* LOGR_OT_best.H_opt


% which part of the distribution is captured by the false alarms?
threshold1                           = 30;
threshold2                           = 50;
threshold3                           = 70;
false_alarms_opt_percabovethreshold1 = find(false_alarms_opt_cumfrac >= (100 - threshold1), 1, 'first')
false_alarms_opt_percabovethreshold2 = find(false_alarms_opt_cumfrac >= (100 - threshold2), 1, 'first')
false_alarms_opt_percabovethreshold3 = find(false_alarms_opt_cumfrac >= (100 - threshold3), 1, 'first')
false_alarms_H05_percabovethreshold1 = find(false_alarms_H05_cumfrac >= (100 - threshold1), 1, 'first')
false_alarms_H05_percabovethreshold2 = find(false_alarms_H05_cumfrac >= (100 - threshold2), 1, 'first')
false_alarms_H05_percabovethreshold3 = find(false_alarms_H05_cumfrac >= (100 - threshold3), 1, 'first')



end


% --------------------------------------------------------------------
% Results: Verification
% --------------------------------------------------------------------


if flags.veri == 1


% stats about acciddent data
naccidents = length(accidents_orig)
ndeaths    = sum(accidents_orig(:,5))
   

% extreme nights corresponding to accidents
accidents_during_extremenight  = date_vec_OT(find(LOGR_OT_best.extr & ~isnan(accidents_shift(:,4))) + 1, :) % +1 to correct for shifting
naccidents_during_extremenight = length(find(LOGR_OT_best.extr & ~isnan(accidents_shift(:,4))))


% warnings corresponding to accidents
accidents_warned  = date_vec_OT(find(LOGR_OT_best.warnings_opt & ~isnan(accidents_shift(:,4))) + 1, :) % +1 to correct for shifting
naccidents_warned = length(find(LOGR_OT_best.warnings_opt & ~isnan(accidents_shift(:,4))) )


% get table for supplementary information
table_accidents = accidents_orig;
for i=1:naccidents
    
    % get index in continuous array
    ind.accidents_orig = find(date_num_OT >= date_num_acc(i) - 1, 1, 'first');
    
    % get binary info if it is a storm night or not
    table_accidents(i,7) = storm_nights_shift(ind.accidents_orig);
    
    % get binary info if it is a storm night or not
    table_accidents(i,8) = round(LOGR_OT_best.p_LOYOCV(ind.accidents_orig) .* 10000) ./ 10000;
   
end


end



% --------------------------------------------------------------------
% Discussion
% --------------------------------------------------------------------





% --------------------------------------------------------------------
% Tables
% --------------------------------------------------------------------


if flags.tune == 1
    
    
% compute daytime hours
hours_day_best     = hours_night    (1) - lead_time_best     - aggregation_time_best     : 1 : hours_night    (1) - lead_time_best    ;
hours_day_best_Uga = hours_night_Uga(1) - lead_time_best_Uga - aggregation_time_best_Uga : 1 : hours_night_Uga(1) - lead_time_best_Uga;
hours_day_best_Ken = hours_night_Ken(1) - lead_time_best_Ken - aggregation_time_best_Ken : 1 : hours_night_Ken(1) - lead_time_best_Ken;
hours_day_best_Tan = hours_night_Tan(1) - lead_time_best_Tan - aggregation_time_best_Tan : 1 : hours_night_Tan(1) - lead_time_best_Tan;
if hours_day_best(end)     < 0; hours_day_best     = hours_day_best     + 24; end
if hours_day_best_Uga(end) < 0; hours_day_best_Uga = hours_day_best_Uga + 24; end
if hours_day_best_Ken(end) < 0; hours_day_best_Ken = hours_day_best_Ken + 24; end
if hours_day_best_Tan(end) < 0; hours_day_best_Tan = hours_day_best_Tan + 24; end
hours_day_best     = ( removerows(hours_day_best'    , 'ind', find(hours_day_best     <= 0)) )';
hours_day_best_Uga = ( removerows(hours_day_best_Uga', 'ind', find(hours_day_best_Uga <= 0)) )';
hours_day_best_Ken = ( removerows(hours_day_best_Ken', 'ind', find(hours_day_best_Ken <= 0)) )';
hours_day_best_Tan = ( removerows(hours_day_best_Tan', 'ind', find(hours_day_best_Tan <= 0)) )';


% table 1: regression parameters
table_logreg       = NaN(16+2,4); % +2 because hours_night and hours_day require two rows
table_logreg( 1,:) = [LOGR_OT_best.b_all(1) LOGR_OT_best_Uga.b_all(1) LOGR_OT_best_Ken.b_all(1) LOGR_OT_best_Tan.b_all(1)]; % Model parameters
table_logreg( 2,:) = [LOGR_OT_best.b_all(2) LOGR_OT_best_Uga.b_all(2) LOGR_OT_best_Ken.b_all(2) LOGR_OT_best_Tan.b_all(2)];
table_logreg( 3,:) = [hours_night(1)        hours_night_Uga(1)        hours_night_Ken(1)        hours_night_Tan(1)       ];
table_logreg( 4,:) = [hours_night(end)      hours_night_Uga(end)      hours_night_Ken(end)      hours_night_Tan(end)     ];

table_logreg( 5,:) = [hours_day_best(1)     hours_day_best_Uga(1)     hours_day_best_Ken(1)     hours_day_best_Tan(1)         ];
table_logreg( 6,:) = [hours_day_best(end)   hours_day_best_Uga(end)   hours_day_best_Ken(end)   hours_day_best_Tan(end)       ];

table_logreg( 7,:) = [lead_time_best        lead_time_best_Uga        lead_time_best_Ken        lead_time_best_Tan       ];
table_logreg( 8,:) = [aggregation_time_best aggregation_time_best_Uga aggregation_time_best_Ken aggregation_time_best_Tan];
table_logreg( 9,:) = [threshold_corr_best   threshold_corr_best_Uga   threshold_corr_best_Ken   threshold_corr_best_Tan  ];
table_logreg(10,:) = [AUC_max               AUC_max_Uga               AUC_max_Ken               AUC_max_Tan              ]; % Model skill
table_logreg(11,:) = [LOGR_OT_best.OR_opt   LOGR_OT_best_Uga.OR_opt   LOGR_OT_best_Ken.OR_opt   LOGR_OT_best_Tan.OR_opt  ];
table_logreg(12,:) = [LOGR_OT_best.H_opt    LOGR_OT_best_Uga.H_opt    LOGR_OT_best_Ken.H_opt    LOGR_OT_best_Tan.H_opt   ];
table_logreg(13,:) = [LOGR_OT_best.F_opt    LOGR_OT_best_Uga.F_opt    LOGR_OT_best_Ken.F_opt    LOGR_OT_best_Tan.F_opt   ];
table_logreg(14,:) = [LOGR_OT_best.F_His05  LOGR_OT_best_Uga.F_His05  LOGR_OT_best_Ken.F_His05  LOGR_OT_best_Tan.F_His05 ];
table_logreg(15,:) = [LOGR_OT_best.F_His09  LOGR_OT_best_Uga.F_His09  LOGR_OT_best_Ken.F_His09  LOGR_OT_best_Tan.F_His09 ];
table_logreg(16,:) = [LOGR_OT_best.F_His10  LOGR_OT_best_Uga.F_His10  LOGR_OT_best_Ken.F_His10  LOGR_OT_best_Tan.F_His10 ];
table_logreg(17,:) = [LOGR_OT_best.ppv_opt  LOGR_OT_best_Uga.ppv_opt  LOGR_OT_best_Ken.ppv_opt  LOGR_OT_best_Tan.ppv_opt ];
table_logreg(18,:) = [LOGR_OT_best.npv_opt  LOGR_OT_best_Uga.npv_opt  LOGR_OT_best_Ken.npv_opt  LOGR_OT_best_Tan.npv_opt ];


% account for fact that OT data sums over the LAST hour 
table_logreg(3,:) = table_logreg(3,:) - 1;
table_logreg(5,:) = table_logreg(5,:) - 1;
table_logreg(7,:) = table_logreg(7,:) - 1; % ALSO ADAPT LEAD TIME BECAUSE IT IS COMPUTED RELATIVE TO END OF HOUR IN CODE !!!!!


% convert UTC to EAT 
table_logreg(3,:) = table_logreg(3,:) + 3;
table_logreg(4,:) = table_logreg(4,:) + 3;
table_logreg(5,:) = table_logreg(5,:) + 3;
table_logreg(6,:) = table_logreg(6,:) + 3;


% round
table_logreg([1 2]       ,:) = round( table_logreg([1 2]       ,:) .* 100000 ) ./ 100000;
table_logreg([9:10 12:18],:) = round( table_logreg([9:10 12:18],:) .*    100 ) ./    100;
table_logreg(11          ,:) = round( table_logreg(11          ,:)           );


end


