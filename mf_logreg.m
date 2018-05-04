

% --------------------------------------------------------------------
% function to perform logistic regression and compute ROC curve
% --------------------------------------------------------------------


function [LOGR AUC rho] = mf_logreg(predictor, predictant, date_vec, threshold, iscorr, hours_day, lat, lon)


               

% --------------------------------------------------------------------
% initialisation
% --------------------------------------------------------------------



% --------------------------------------------------------------------
% manipulations
% --------------------------------------------------------------------


% construct binary time series from input predictant time series
% should be "extremes" only
extr = predictant > threshold;


% flag point if predictor contains only zeros
if isempty(find(predictor, 1))
    ispredictor = 0;
else
    ispredictor = 1;
end


% given previous check, we can suppres this warning
warning('off', 'stats:glmfit:IllConditioned')


% perform logistic regression on ALL data - get 95% confidence interval
[b_all, ~, b_all_stats] = glmfit(predictor, extr, 'binomial'); % perform logistic regression 
[p_all]                 = glmval(b_all, predictor, 'logit');   % get probabilities


% perform logistic regression using leave one YEAR out cross validation (LOYOCV)
p_LOYOCV = NaN(size(predictor));
for i=date_vec(1,1):date_vec(end,1)   % loop over years
    
    % get indices
    isyear    = date_vec(:,1) == i;
    
    % perform logistic regression on all data except that year
    b         = glmfit(predictor(~isyear), extr(~isyear), 'binomial'); 
    
    % get probabilities for that year
    p_LOYOCV(isyear) = glmval(b, predictor(isyear), 'logit');       
    
end


% same as extr vector, but now as cell array and with words 
% (required input for perfcurve function)
cases         = cell(length(extr),1);
cases(:,1)    = {'normal'};
cases(extr,1) = {'extreme'};


% generate ROC curve 
% False alarm rate (F) on x-axis
% Hit rate (H) on y-axis
[F, H, T, AUC] = perfcurve(cases, p_LOYOCV, 'extreme');


% compute diagnostics - optimal point
[opt, ind_opt] = nanmax(H - F);
H_opt          = H(ind_opt);
F_opt          = F(ind_opt);
T_opt          = T(ind_opt);


% compute diagnostics - False alarms rates (F) and Thresholds (T) associated with fixed Hit rates (H)
F_H05 = F(find(H >= 0.5, 1, 'first'));
F_H09 = F(find(H >= 0.9, 1, 'first')); 
F_H10 = F(find(H >= 1.0, 1, 'first'));
T_H05 = T(find(H >= 0.5, 1, 'first')); 


% compute diagnostics - warnings associated with optimal point and H05
warnings_opt = p_LOYOCV >= T_opt;
warnings_H05 = p_LOYOCV >= T_H05;


% compute diagnostics - false alarms associated with optimal point and H05
false_alarms_opt = warnings_opt & ~extr;
false_alarms_H05 = warnings_H05 & ~extr;


% compute diagnostics - Odds Ratio (for optimal point)
%           X - 2x2 data matrix composed like this: 
%...........................................extrnight..normnight
%                                              ___________
%Warning                                      |  A  |  B  |
%                                             |_____|_____|
%No warning                                   |  C  |  D  |
%                                             |_____|_____|
% Then: Odds Ratio = (A * D) / (C * B)
% nwarnings = length(find( warnings_opt ));
% nextr     = length(find( extr         ));
A      = length(find( warnings_opt &  extr)); % true positives
B      = length(find( warnings_opt & ~extr)); % false positives
C      = length(find(~warnings_opt &  extr)); % false negatives
D      = length(find(~warnings_opt & ~extr)); % true negatives
OR_opt = (A * D) / (C * B);


% compute diagnostics - positive predictive value (ppv) and negative predictive value (npv)
ppv_opt = A / (A + B); % ppv = tp/(tp+fp)
npv_opt = D / (D + C); % npv = tn/(tn+fn)


% compute diagnostics - rank correlation
rho = corr(predictor, predictant, 'type', 'spearman', 'rows', 'pairwise');


% prepare output structure
LOGR.predictor        = predictor;
LOGR.extr             = extr;
LOGR.ispredictor      = ispredictor;
LOGR.b_all            = b_all;
LOGR.b_all_stats      = b_all_stats;
LOGR.p_all            = p_all;
LOGR.p_LOYOCV         = p_LOYOCV;
LOGR.F                = F;
LOGR.H                = H;
LOGR.T                = T;
LOGR.AUC              = AUC;
LOGR.opt              = opt;
LOGR.ind_opt          = ind_opt;
LOGR.H_opt            = H_opt;
LOGR.F_opt            = F_opt;
LOGR.T_opt            = T_opt;
LOGR.warnings_opt     = warnings_opt;
LOGR.warnings_H05     = warnings_H05;
LOGR.false_alarms_opt = false_alarms_opt;
LOGR.false_alarms_H05 = false_alarms_H05;
LOGR.OR_opt           = OR_opt;
LOGR.F_His05          = F_H05;
LOGR.F_His09          = F_H09;
LOGR.F_His10          = F_H10;
LOGR.T_His05          = T_H05;
LOGR.ppv_opt          = ppv_opt;
LOGR.npv_opt          = npv_opt;
LOGR.rho              = rho;
LOGR.iscorr           = iscorr;
LOGR.lat              = lat;
LOGR.lon              = lon;
LOGR.hours_day        = hours_day;


end
