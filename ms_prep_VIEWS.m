
% --------------------------------------------------------------------
% Proff of concept: perform logistic regression on selected variables
% note: preferably run "main"
% --------------------------------------------------------------------



% --------------------------------------------------------------------
% manipulations: creat
% --------------------------------------------------------------------


% get daytime hours
hours_day_tuned = hours_night(1)-lead_time_best - aggregation_time_best : 1 : hours_night(1)-lead_time_best;
if hours_day_tuned(end) < 0                 % this means all daytime hours are negative
    hours_day_tuned = hours_day_tuned + 24;
end


% security: do not allow for negative hours
% to do: allow aggregation time to extend back into the previous day!!!
hours_day_tuned = ( removerows(hours_day_tuned', 'ind', find(hours_day_tuned <= 0)) )';


% create OT day/night time series
OT_d_best = zeros(size(OT_hoursum{1}));
for m=hours_day_tuned;
    OT_d_best = OT_d_best + OT_hoursum{m};
end


% select two days as example
OT_d_best_20050311 = OT_d_best(:,:,70); % calm day
OT_d_best_20050314 = OT_d_best(:,:,73); % extreme day, forecasted


% now save them
OT_d = OT_d_best_20050311;
save('VIEWS/OT_d_best_20050311.mat', 'OT_d');

OT_d = OT_d_best_20050314;
save('VIEWS/OT_d_best_20050314.mat', 'OT_d');


% also save LOGR models
save('VIEWS/OT_models_best.mat', 'LOGR_OT_best', 'LOGR_OT_best_Uga', 'LOGR_OT_best_Ken', 'LOGR_OT_best_Tan');


