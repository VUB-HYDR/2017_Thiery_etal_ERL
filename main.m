
% --------------------------------------------------------------------
% main script to postprocess and visualise OT data
% --------------------------------------------------------------------


% notes: changes compared to orignal logreg in CCLM_future:
% - All times are in UTC here, but EAT (=UTC+3) in the paper (even though time zone borders crosses domain)! Works well with the choice of our nighttime hours! (say 21:00 UTC in text but take 22:00 UTC as starting point in code because it accumulates to the next hour!)
% - all land masks now consider lake pixels outside of Lake victoria as 'land'
% - Aggregation time cannot extend back into the previous day!!!


tic


% clean up
clc;
clear;
close all;


% flags
flags.conc = 0; % 0: do not compute 'Proof of concept'
                % 1: compute 'Proof of concept'
flags.tune = 1; % 0: do not compute 'tuning'
                % 1: compute 'tuning'
flags.veri = 0; % 0: do not compute forecast verification
                % 1: compute forecast verification
flags.valp = 0; % 0: do not compute values used in the paper
                % 1: compute values used in the paper
flags.plot = 1; % 0: do not plot
                % 1: plot



% --------------------------------------------------------------------
% initialisation
% --------------------------------------------------------------------


% add matlab scripts directory to path
addpath(genpath('C:\Users\u0079068\Documents\Research\matlab_scripts'));


% add directory containing nc files to path
addpath(genpath('C:\Users\u0079068\Documents\Research\EWS_Victoria\ncfiles'));


% define hours considered as "day" and "night"
% hours_night = 1:9;         % consistent with CCLM_future
hours_night = [22:24 1:9]; % final estimate based on OT diurnal cycle
hours_day   = 10:15;


% define percentile above which events are considered 'severe'
perc_severe = 99;


% initialise model parameters
res_reg = 0.20; % predefined regular grid


% initialise time parameters - CCLM² and TRMM
time_begin_FLa  = [1999, 1, 1, 0,0,0];
time_end_FLa    = [2008,12,31,23,0,0];
time_begin_TRMM = [1998, 1, 1, 0,0,0];
time_end_TRMM   = [2013,12,31,23,0,0];


% initialise Lake Victoria boundaries
lat_min_Vict       = -4.01; % used to cut out surrounding land rectangle
lat_max_Vict       = 2.01;
lon_min_Vict       = 29.98;
lon_max_Vict       = 35.95;
lat_min_Vict_small = -3.1;  % used to cut out Lake Victoria & remove other lakes within surrounding land rectangle
lat_max_Vict_small = 0.6;
lon_min_Vict_small = 31.4;
lon_max_Vict_small = 35;


% define number of grid points to be cropped on each side
nc = 10;



% --------------------------------------------------------------------
% load data
% --------------------------------------------------------------------


ms_load



% --------------------------------------------------------------------
% manipulations: general
% --------------------------------------------------------------------


ms_manip



% --------------------------------------------------------------------
% Proof of concept
% --------------------------------------------------------------------


if flags.conc == 1
   ms_concept
end



% --------------------------------------------------------------------
% Tuning
% --------------------------------------------------------------------


if flags.tune == 1
   ms_tuning
end



% --------------------------------------------------------------------
% Verification
% --------------------------------------------------------------------


if flags.tune == 1 && flags.veri == 1
   ms_verification
end



% --------------------------------------------------------------------
% get values used in the paper
% --------------------------------------------------------------------


if flags.valp == 1
   ms_valp
end



% --------------------------------------------------------------------
% visualise output
% --------------------------------------------------------------------


if flags.plot == 1
   ms_plotscript
end




toc
