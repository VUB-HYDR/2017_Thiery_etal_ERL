
% --------------------------------------------------------------------
% subroutine to perform manipulations on loaded variables
% note: preferably run "main"
% --------------------------------------------------------------------



% --------------------------------------------------------------------
% initialisation
% --------------------------------------------------------------------


% initialise bin characteristics
nbins = 100;



% --------------------------------------------------------------------
% manipulations: OT data
% --------------------------------------------------------------------


% get number of days
ndays = size(OT_hoursum{1}, 3);


% create OT day/night time series
OT_n           = zeros(size(OT_hoursum{1}));
OT_d           = zeros(size(OT_hoursum{1}));
hours_night_AM = hours_night(hours_night < 12);
hours_night_PM = hours_night(hours_night > 12);
for i=hours_night_AM; OT_n = OT_n +           OT_hoursum{i};           end
for i=hours_night_PM; OT_n = OT_n + circshift(OT_hoursum{i}, [0 0 1]); end % shift 1 down because PM hours should be summed to next night
for i=hours_day;      OT_d = OT_d +           OT_hoursum{i};           end


% get daytime dayly total/mean over-lake/over-land values
[~, OT_n_lp] = mf_fieldsum(OT_n, isvict);
[~, OT_d_gp] = mf_fieldsum(OT_d, issurr);
[~, OT_d_lp] = mf_fieldsum(OT_d, isvict);


% shift OT array by 1 day to get the time lag you need for the causal relationship
OT_n_lp_shift        = circshift(OT_n_lp, -1);
OT_n_lp_shift(end,:) = NaN;


% compute thresholds as XXth percentile
threshold_OT = prctile(OT_n_lp_shift, perc_severe);    % [#OT/day]



% --------------------------------------------------------------------
% diagnostics: OT data
% --------------------------------------------------------------------


% prepare files for plotting
OT_n_timsum = nansum(OT_yhoursum(:,:,hours_night),3);
OT_d_timsum = nansum(OT_yhoursum(:,:,hours_day),3);


% get percentage of OTs occuring at night 
OT_n_perc = OT_n_timsum ./ nansum(OT_yhoursum,3) .* 100;


