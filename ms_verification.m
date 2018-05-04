
% --------------------------------------------------------------------
% Evaluate logistic regression model based on boating accident data
% --------------------------------------------------------------------


% notes: 
% - input data is in EAT (but no conversion is required with the current dataset)
% - if there is no hour given, assume it occured at 8:00 EAT during the
% mentioned date
% - country numbers:
% 1: Uganda    ==> accidents matrix column 5
% 2: Kenya     ==> accidents matrix column 6
% 3: Tanzania  ==> accidents matrix column 7
                


% --------------------------------------------------------------------
% initialisations
% --------------------------------------------------------------------


% load data
accidents_orig = xlsread('accidents_data.xlsx');



% --------------------------------------------------------------------
% manipulations
% --------------------------------------------------------------------


% sort in chronological orde
accidents_orig                         = sortrows(accidents_orig, [1 2 3 4 5]);
accidents_orig(accidents_orig == -999) = NaN;


% get som time information
date_num_OT  = datenum(date_vec_OT);
date_num_acc = datenum(accidents_orig(:,1:3));


% solve AM/PM issue
accidents_orig(isnan(accidents_orig(:,4)),4) = 8;                                 % Assume accidents without hour mentioned to occur at 8:00 EAT (so AM)
ind.PMaccidents                              = find(accidents_orig(:,4) > 12);    % Find accidents reported during the evening hours
date_num_acc(ind.PMaccidents)                = date_num_acc(ind.PMaccidents) + 1; % Transfer accidents reported during the evening hours to the next day


% prepare for loop
accidents        = date_vec_OT(:,1:3);
accidents(:,4:7) = 0;


% loop over all accidents to get continuous time series
for i=1:length(accidents_orig)
    
    % get index in continuous array
    ind.accidents = find(date_num_OT >= date_num_acc(i), 1, 'first');
    
    % assign event in continuous array - whole lake
    accidents(ind.accidents, 4) = accidents(ind.accidents, 4) + accidents_orig(i, 5);
    
    % assign event in continuous array - per country
    accidents(ind.accidents, 4 + accidents_orig(i, 6)) = accidents(ind.accidents, 4 + accidents_orig(i, 6)) + accidents_orig(i, 5);
    
end


% set times with no accidents to NaN
accidents(accidents == 0) = NaN;


% for comparison with the 'afternoon' predictions, shift 'morning accidents' 1 day back in time (plotting pruposes)
accidents_shift(:,1:3)   = accidents(:,1:3);
accidents_shift(:,4:7)   = circshift(accidents(:,4:7), -1);
accidents_shift(end,4:7) = NaN;


% get indices of events you want to analyse
ind.hits            = find( LOGR_OT_best.warnings_opt &  LOGR_OT_best.extr);
ind.false_alarms    = find( LOGR_OT_best.warnings_opt & ~LOGR_OT_best.extr);
ind.miss            = find(~LOGR_OT_best.warnings_opt &  LOGR_OT_best.extr);
ind.accidents_shift = find(~isnan(accidents_shift(:,4))               );



% --------------------------------------------------------------------
% prepare for plotting
% --------------------------------------------------------------------


% get storm nights, defined as nights with OTs detected
storm_nights_shift = OT_n_lp_shift > 0;


% get TOT_PREC bins (use "tabulate(bin)" for some bin information)
bin = ceil(nbins * tiedrank(OT_n_lp_shift(storm_nights_shift)) / length(find(OT_n_lp_shift(storm_nights_shift))) );


% bin other variables to TOT_PREC - also use quantiles
[ ~, binmedian_OT_n_lp_shift, ~, binQ25_OT_n_lp_shift, binQ75_OT_n_lp_shift] = mf_bin(OT_n_lp_shift        (storm_nights_shift), bin, nbins);
[ ~, binmedian_p_LOYOCV     , ~, binQ25_p_LOYOCV     , binQ75_p_LOYOCV     ] = mf_bin(LOGR_OT_best.p_LOYOCV(storm_nights_shift), bin, nbins);


% apply Savitzky-Golay filtering
order              = 2;
framelen           = 9;
binmedian_p_LOYOCV = sgolayfilt(binmedian_p_LOYOCV, order, framelen);
binQ25_p_LOYOCV    = sgolayfilt(binQ25_p_LOYOCV   , order, framelen);
binQ75_p_LOYOCV    = sgolayfilt(binQ75_p_LOYOCV   , order, framelen);


% find out to which bin the accidents belong
accidents_whichbin        = bin(~isnan(accidents_shift(storm_nights_shift,4)));
accidents_whichbin_unique = unique(accidents_whichbin);
accidents_whichbin_counts = histc(accidents_whichbin, accidents_whichbin_unique);



