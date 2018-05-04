

% --------------------------------------------------------------------
% function to perform logistic regression and compute ROC curve
% --------------------------------------------------------------------


function [hours_night] = mf_hoursnight(OT_yhoursum_lp, nhours_night)


               
% --------------------------------------------------------------------
% manipulations
% --------------------------------------------------------------------


% get sum over e.g. 12 consecutive hours
for i=1:nhours_night
    dummy(:,i) = circshift(OT_yhoursum_lp, (i-1) * -1); %#ok<AGROW>
end
dummy = sum(dummy, 2);


% get hour with largest 
indmax = find(dummy == max(dummy));


% get corrsponding indices
hours_night = indmax: indmax + nhours_night - 1;


% correct indices > 24
hours_night(hours_night > 24) = hours_night(hours_night > 24) - 24;


end
