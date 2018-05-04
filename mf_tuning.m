

% --------------------------------------------------------------------
% function to perform logistic regression and compute ROC curve
% --------------------------------------------------------------------


function [LOGR_OT_tuned, AUC_tuned, rho_tuned] = mf_tuning(OT_hoursum, OT_n_lp_shift, date_vec_OT, hours_night, threshold_OT, lead_time, aggregation_time, threshold_corr, lat, lon)


               

% --------------------------------------------------------------------
% initialisation
% --------------------------------------------------------------------



% --------------------------------------------------------------------
% manipulations
% --------------------------------------------------------------------


% prepare for loop
ni = length(lead_time);
nj = length(aggregation_time);
nk = length(threshold_corr);


% loop over forecast lead time
for i=1:length(lead_time)

    % loop over aggregation time
    for j=1:length(aggregation_time)
        

        % get daytime hours
        hours_day_tuned = hours_night(1)-lead_time(i)-aggregation_time(j) : 1 : hours_night(1)-lead_time(i);
        if hours_day_tuned(end) < 0                 % this means all daytime hours are negative
            hours_day_tuned = hours_day_tuned + 24;
        end


        % security: do not allow for negative hours
        % to do: allow aggregation time to extend back into the previous day!!!
        hours_day_tuned = ( removerows(hours_day_tuned', 'ind', find(hours_day_tuned <= 0)) )';


        % create OT day/night time series
        OT_d_tuned = zeros(size(OT_hoursum{1}));
        for m=hours_day_tuned
            OT_d_tuned = OT_d_tuned + OT_hoursum{m};
        end


        % compute spearman rank correlation between land pixels and total number of lake OTs
        [OT_d_corr_tuned] = mf_3Dcorr(OT_d_tuned, OT_n_lp_shift);

        
        % loop over correlation threshold
        for k=1:length(threshold_corr)


            % display progress
            progress = ((i-1)*nj*nk + (j-1)*nk + k) ./ (ni*nj*nk) .* 100  %#ok<NOPRT,NASGU>


            % select indices of pixels above threshold
            iscorr_tuned = OT_d_corr_tuned > threshold_corr(k);


            % get daytime daytime total OTs over highly correlated regions
            [~, OT_d_gp_tuned] = mf_fieldsum(OT_d_tuned, iscorr_tuned);


            % Apply logistic regression and compute ROC curve
            [LOGR_OT_tuned(i,j,k), AUC_tuned(i,j,k), rho_tuned(i,j,k)] = mf_logreg(OT_d_gp_tuned, OT_n_lp_shift, date_vec_OT, threshold_OT, iscorr_tuned, hours_day_tuned, lat, lon); %#ok<AGROW,*SAGROW>

            
        end

    end

end




end
