
% --------------------------------------------------------------------
% Proff of concept: perform logistic regression on selected variables
% note: preferably run "main"
% --------------------------------------------------------------------



% note
% - shortest lead time and longest aggregation time gives best result!!! so
% perhaps consider longer aggregation times and shorter lead times?


% flags
flags.loadtuning = 1; % 0: compute 'tuning'
                      % 1: load 'tuning'
flags.countries  = 2; % 0: tune for whole lake only
                      % 1: tune for countries only
                      % 2: tune for whole lake and countries 

                

% --------------------------------------------------------------------
% initialisations
% --------------------------------------------------------------------


% define threshold above which pixels are selected to be a predictor
threshold_corr = 0.10 : 0.05 : 0.30;


% define lead times (time between forecast issue time and beginning of forecast validity period)
% NOTE THAT LEAD TIME IS COMPUTED RELATIVE TO END OF HOUR IN CODE, SO ACTUAL LEAD TIME IS ONE HOUR LESS !!!!!
% lead_time = 1 : 1 : 12; % shorter lead times lead to higher skill!!
lead_time = 4 : 1 : 12;


% define number of hours over which to aggregate
aggregation_time = 2 : 1 : 14;



% --------------------------------------------------------------------
% manipulations, whole lake
% --------------------------------------------------------------------


if flags.countries == 0 || flags.countries == 2

    if     flags.loadtuning == 1; % load 'tuning'


        load('mw_tuning.mat');


    elseif flags.loadtuning == 0; % compute 'tuning'


        % call tuning subroutine
        [LOGR_OT_tuned AUC_tuned rho_tuned] = mf_tuning(OT_hoursum, OT_n_lp_shift, date_vec_OT, hours_night, threshold_OT, lead_time, aggregation_time, threshold_corr, lat_reg, lon_reg);


        % save data
        save('mw_tuning.mat', 'LOGR_OT_tuned', 'AUC_tuned', 'rho_tuned', '-v7.3');


    end

end



% --------------------------------------------------------------------
% manipulations, individual countries
% --------------------------------------------------------------------


if flags.countries == 1 || flags.countries == 2


    % initialise total number of 'nighttime' hours
    nhours_night = 6;


    % load country borders
    countries = m_shaperead('ne_10m_admin_0_countries');                                                                      % load country borders


    % get index of country border polygon (google: find-index-of-cells-containing-my-string)
    ind_Uga = find(not(cellfun('isempty', strfind(countries.NAME, 'Uganda'  ))));
    ind_Ken = find(not(cellfun('isempty', strfind(countries.NAME, 'Kenya'   ))));
    ind_Tan = find(not(cellfun('isempty', strfind(countries.NAME, 'Tanzania'))));


    % get lake pixels within every country
    isvict_Uga = isvict & inpolygon(lon_reg, lat_reg, countries.ncst{ind_Uga}(:,1), countries.ncst{ind_Uga}(:,2));
    isvict_Ken = isvict & inpolygon(lon_reg, lat_reg, countries.ncst{ind_Ken}(:,1), countries.ncst{ind_Ken}(:,2));
    isvict_Tan = isvict & inpolygon(lon_reg, lat_reg, countries.ncst{ind_Tan}(:,1), countries.ncst{ind_Tan}(:,2));
    
    
    % compute spatial averages
    [~, OT_yhoursum_lp_Uga] = mf_fieldmean(OT_yhoursum, isvict_Uga);
    [~, OT_yhoursum_lp_Ken] = mf_fieldmean(OT_yhoursum, isvict_Ken);
    [~, OT_yhoursum_lp_Tan] = mf_fieldmean(OT_yhoursum, isvict_Tan);


    % get nighttime ours corresponding to peak storm activity
    [hours_night_Uga] = mf_hoursnight(OT_yhoursum_lp_Uga, nhours_night);
    [hours_night_Ken] = mf_hoursnight(OT_yhoursum_lp_Ken, nhours_night);
    [hours_night_Tan] = mf_hoursnight(OT_yhoursum_lp_Tan, nhours_night);
    

    % create OT day/night time series
    OT_n_Uga           = zeros(size(OT_hoursum{1}));
    OT_n_Ken           = zeros(size(OT_hoursum{1}));
    OT_n_Tan           = zeros(size(OT_hoursum{1}));
    hours_night_AM_Uga = hours_night_Uga(hours_night_Uga < 12);
    hours_night_AM_Ken = hours_night_Ken(hours_night_Ken < 12);
    hours_night_AM_Tan = hours_night_Tan(hours_night_Tan < 12);
    hours_night_PM_Uga = hours_night_Uga(hours_night_Uga > 12);
    hours_night_PM_Ken = hours_night_Ken(hours_night_Ken > 12);
    hours_night_PM_Tan = hours_night_Tan(hours_night_Tan > 12);
    for i=hours_night_AM_Uga; OT_n_Uga = OT_n_Uga +           OT_hoursum{i};           end
    for i=hours_night_AM_Ken; OT_n_Ken = OT_n_Ken +           OT_hoursum{i};           end
    for i=hours_night_AM_Tan; OT_n_Tan = OT_n_Tan +           OT_hoursum{i};           end
    for i=hours_night_PM_Uga; OT_n_Uga = OT_n_Uga + circshift(OT_hoursum{i}, [0 0 1]); end % shift 1 down because PM hours should be summed to next night
    for i=hours_night_PM_Ken; OT_n_Ken = OT_n_Ken + circshift(OT_hoursum{i}, [0 0 1]); end % shift 1 down because PM hours should be summed to next night
    for i=hours_night_PM_Uga; OT_n_Tan = OT_n_Tan + circshift(OT_hoursum{i}, [0 0 1]); end % shift 1 down because PM hours should be summed to next night


    % get daytime dayly total/mean over-lake/over-land values
    [~, OT_n_lp_Uga] = mf_fieldsum(OT_n_Uga, isvict_Uga);
    [~, OT_n_lp_Ken] = mf_fieldsum(OT_n_Ken, isvict_Ken);
    [~, OT_n_lp_Tan] = mf_fieldsum(OT_n_Tan, isvict_Tan);


    % shift OT array by 1 day to get the time lag you need for the causal relationship
    OT_n_lp_shift_Uga        = circshift(OT_n_lp_Uga, -1);
    OT_n_lp_shift_Ken        = circshift(OT_n_lp_Ken, -1);
    OT_n_lp_shift_Tan        = circshift(OT_n_lp_Tan, -1);
    OT_n_lp_shift_Uga(end,:) = NaN;
    OT_n_lp_shift_Ken(end,:) = NaN;
    OT_n_lp_shift_Tan(end,:) = NaN;


    % compute thresholds as XXth percentile
    threshold_OT_Uga = prctile(OT_n_lp_shift_Uga, perc_severe);    % [#OT/day]
    threshold_OT_Ken = prctile(OT_n_lp_shift_Ken, perc_severe);    % [#OT/day]
    threshold_OT_Tan = prctile(OT_n_lp_shift_Tan, perc_severe);    % [#OT/day]

    
    if     flags.loadtuning == 1; % load 'tuning'


        load('mw_tuning_countries.mat');


    elseif flags.loadtuning == 0; % compute 'tuning'


        % call tuning subroutine
        [LOGR_OT_tuned_Uga AUC_tuned_Uga rho_tuned_Uga] = mf_tuning(OT_hoursum, OT_n_lp_shift_Uga, date_vec_OT, hours_night_Uga, threshold_OT_Uga, lead_time, aggregation_time, threshold_corr, lat_reg, lon_reg);
        [LOGR_OT_tuned_Ken AUC_tuned_Ken rho_tuned_Ken] = mf_tuning(OT_hoursum, OT_n_lp_shift_Ken, date_vec_OT, hours_night_Ken, threshold_OT_Ken, lead_time, aggregation_time, threshold_corr, lat_reg, lon_reg);
        [LOGR_OT_tuned_Tan AUC_tuned_Tan rho_tuned_Tan] = mf_tuning(OT_hoursum, OT_n_lp_shift_Tan, date_vec_OT, hours_night_Tan, threshold_OT_Tan, lead_time, aggregation_time, threshold_corr, lat_reg, lon_reg);


        % save data
        save('mw_tuning_countries.mat', 'LOGR_OT_tuned_Uga', 'AUC_tuned_Uga', 'rho_tuned_Uga', ...
                                        'LOGR_OT_tuned_Ken', 'AUC_tuned_Ken', 'rho_tuned_Ken', ...
                                        'LOGR_OT_tuned_Tan', 'AUC_tuned_Tan', 'rho_tuned_Tan', '-v7.3');


    end

    
end



% --------------------------------------------------------------------
% Diagnostics
% --------------------------------------------------------------------



if flags.countries == 0 || flags.countries == 2

    % get info of best model (i.e maximum AUC) - Lake Victoria
    AUC_max                        = nanmax(nanmax(nanmax(AUC_tuned)));
    [indx_max, indy_max, indz_max] = ind2sub(size(AUC_tuned), find(AUC_tuned == AUC_max, 1, 'first'));
    LOGR_OT_best                   = LOGR_OT_tuned(indx_max, indy_max, indz_max);
    lead_time_best                 = lead_time       (indx_max);
    aggregation_time_best          = aggregation_time(indy_max);
    threshold_corr_best            = threshold_corr  (indz_max);
    rho_max                        = nanmax(nanmax(nanmax(rho_tuned)));


    % which part of the distribution is captured by the false alarms?
    % to answer this question, first bin all OT_n_lp_shift data
    bin_all                       = ceil(nbins * tiedrank(OT_n_lp_shift) / length(OT_n_lp_shift) );
    false_alarms_opt_whichbin     = bin_all(LOGR_OT_best.false_alarms_opt);
    false_alarms_H05_whichbin     = bin_all(LOGR_OT_best.false_alarms_H05);


    % Now count false alarm occurrences within each bin
    % 100 edges, for 100 intervals: [1,2[; [2,3[; [3,4[; ... ; [99,100[; [100]
    % note: last interval = 0 per definition, because then it's a hit instead of a false alarm
    binedges                   = (1:100)';  
    false_alarms_opt_bincounts = histc(false_alarms_opt_whichbin, binedges);
    false_alarms_H05_bincounts = histc(false_alarms_H05_whichbin, binedges);
    OT_n_lp_shift_bincounts    = histc(bin_all                  , binedges);
    
    
    % hack: smear out over first 30 bins
    nostorms = 1:30;
    false_alarms_opt_bincounts(nostorms) = nansum( false_alarms_opt_bincounts(nostorms) ./ length(nostorms) );
    false_alarms_H05_bincounts(nostorms) = nansum( false_alarms_H05_bincounts(nostorms) ./ length(nostorms) );
    OT_n_lp_shift_bincounts   (nostorms) = nansum( OT_n_lp_shift_bincounts   (nostorms) ./ length(nostorms) );
        
    
    % get fraction of all false alarms within each bin 
    false_alarms_opt_frac = false_alarms_opt_bincounts(1:nbins-1) ./ length(false_alarms_opt_whichbin) .* 100;
    false_alarms_H05_frac = false_alarms_H05_bincounts(1:nbins-1) ./ length(false_alarms_H05_whichbin) .* 100;
    OT_n_lp_shift_frac    = OT_n_lp_shift_bincounts(1:nbins-1)    ./ length(bin_all)                   .* 100;
    
    
    % apply Savitzky-Golay filtering on fraction
    order                 = 2;
    framelen              = 27;
    false_alarms_opt_frac = sgolayfilt(false_alarms_opt_frac, order, framelen);
    false_alarms_H05_frac = sgolayfilt(false_alarms_H05_frac, order, framelen);
    OT_n_lp_shift_frac    = sgolayfilt(OT_n_lp_shift_frac   , order, framelen);

    
    % get cumulative fraction - no smoothing needed
    false_alarms_opt_cumfrac = cumsum(false_alarms_opt_bincounts) ./ length(false_alarms_opt_whichbin) .* 100;
    false_alarms_H05_cumfrac = cumsum(false_alarms_H05_bincounts) ./ length(false_alarms_H05_whichbin) .* 100;
    OT_n_lp_shift_cumfrac    = cumsum(OT_n_lp_shift_bincounts)    ./ length(bin_all)                   .* 100;

    
end


if flags.countries == 1 || flags.countries == 2

    
    % get info of best model (i.e maximum AUC) - Uganda
    AUC_max_Uga                                = nanmax(nanmax(nanmax(AUC_tuned_Uga)));
    [indx_max_Uga, indy_max_Uga, indz_max_Uga] = ind2sub(size(AUC_tuned_Uga), find(AUC_tuned_Uga == AUC_max_Uga, 1, 'first'));
    LOGR_OT_best_Uga                           = LOGR_OT_tuned_Uga(indx_max_Uga, indy_max_Uga, indz_max_Uga);
    lead_time_best_Uga                         = lead_time       (indx_max_Uga);
    aggregation_time_best_Uga                  = aggregation_time(indy_max_Uga);
    threshold_corr_best_Uga                    = threshold_corr  (indz_max_Uga);
    rho_max_Uga                                = nanmax(nanmax(nanmax(rho_tuned_Uga)));
    
    
    % get info of best model (i.e maximum AUC) - Kenya
    AUC_max_Ken                                = nanmax(nanmax(nanmax(AUC_tuned_Ken)));
    [indx_max_Ken, indy_max_Ken, indz_max_Ken] = ind2sub(size(AUC_tuned_Ken), find(AUC_tuned_Ken == AUC_max_Ken, 1, 'first'));
    LOGR_OT_best_Ken                           = LOGR_OT_tuned_Ken(indx_max_Ken, indy_max_Ken, indz_max_Ken);
    lead_time_best_Ken                         = lead_time       (indx_max_Ken);
    aggregation_time_best_Ken                  = aggregation_time(indy_max_Ken);
    threshold_corr_best_Ken                    = threshold_corr  (indz_max_Ken);
    rho_max_Ken                                = nanmax(nanmax(nanmax(rho_tuned_Ken)));
    
    
    % get info of best model (i.e maximum AUC) - Tanzania
    AUC_max_Tan                                = nanmax(nanmax(nanmax(AUC_tuned_Tan)));
    [indx_max_Tan, indy_max_Tan, indz_max_Tan] = ind2sub(size(AUC_tuned_Tan), find(AUC_tuned_Tan == AUC_max_Tan, 1, 'first'));
    LOGR_OT_best_Tan                           = LOGR_OT_tuned_Tan(indx_max_Tan, indy_max_Tan, indz_max_Tan);
    lead_time_best_Tan                         = lead_time       (indx_max_Tan);
    aggregation_time_best_Tan                  = aggregation_time(indy_max_Tan);
    threshold_corr_best_Tan                    = threshold_corr  (indz_max_Tan);
    rho_max_Tan                                = nanmax(nanmax(nanmax(rho_tuned_Tan)));
    
    
end


% prepare for plotting
[aggregation_time_mesh, lead_time_mesh, threshold_corr_mesh] = meshgrid(aggregation_time, lead_time, threshold_corr);

