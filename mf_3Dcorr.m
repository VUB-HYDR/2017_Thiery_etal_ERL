

% --------------------------------------------------------------------
% function to compute correlation between 
% --------------------------------------------------------------------


function [c] = mf_3Dcorr(a,v)


              
% --------------------------------------------------------------------
% manipulations
% --------------------------------------------------------------------


% reshape 3D array to 2D matrix with dimensions lat*lon and time
as = reshape(a, size(a,1)*size(a,2), size(a,3));


% compute correlation (without using for loop)
cs = corr(as', v, 'type', 'spearman', 'rows', 'pairwise');


% reshape correlations back to a lat-by-lon matrix
c  = reshape(cs,size(a,1),size(a,2));


end
