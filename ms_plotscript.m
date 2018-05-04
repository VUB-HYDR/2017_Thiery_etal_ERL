
% --------------------------------------------------------------------
% visualisation subroutine
% note: preferably run "main"
% --------------------------------------------------------------------


% clean up
clc;
close all;


% flags for paper plots
flags.plot_fig1   = 1; % 0: do not plot figure 1 of paper
                       % 1: plot figure 1 of paper
flags.plot_fig2   = 0; % 0: do not plot figure 2 of paper
                       % 1: plot figure 2 of paper
flags.plot_fig3   = 0; % 0: do not plot figure 3 of paper
                       % 1: plot figure 3 of paper
flags.plot_fig4   = 0; % 0: do not plot figure 4 of paper
                       % 1: plot figure 4 of paper
flags.plot_sfig1  = 0; % 0: do not plot supplementary figure 1 of paper
                       % 1: plot supplementary figure 1 of paper
flags.plot_sfig2  = 0; % 0: do not plot supplementary figure 2 of paper
                       % 1: plot supplementary figure 2 of paper
flags.plot_sfig3  = 0; % 0: do not plot supplementary figure 3 of paper
                       % 1: plot supplementary figure 3 of paper
flags.plot_sfig4  = 0; % 0: do not plot supplementary figure 4 of paper
                       % 1: plot supplementary figure 4 of paper
flags.plot_sfig5  = 0; % 0: do not plot supplementary figure 4 of paper
                       % 1: plot supplementary figure 4 of paper


% flags for other plots               
flags.plot_3Dsens = 0; % 0: do not plot 3D sensitivity
                       % 1: plot 3D sensitivity
flags.plot_time   = 0; % 0: do not plot time series
                       % 1: plot time series
flags.plot_movie  = 0; % 0: do not plot OT movie
                       % 1: plot OT movie
flags.plot_boats  = 0; % 0: do not plot comparison to boating accidents
                       % 1: plot comparison to boating accidents

         

% --------------------------------------------------------------------
% initialisation
% --------------------------------------------------------------------


% set colorscale axes
caxes.OT   = [0      10000];
caxes.OThs = [0      1500 ];
caxes.PRhs = [0         1 ];
caxes.perc = [0      100  ];
caxes.corr = [0.10   0.25 ];
caxes.tune = [0.85   0.93 ];


% set colormaps
colormaps.OT   =        mf_colormap_cpt('YlGnBu_09'        , 9 );
colormaps.OThs =        mf_colormap_cpt('YlGnBu_09'        , 9 );
colormaps.PRhs =        mf_colormap_cpt('YlGnBu_08'        , 8 );
colormaps.perc =        mf_colormap_cpt('precip_diff_12lev', 12);
colormaps.corr =        mf_colormap_cpt('dense'            , 15);
colormaps.tune = flipud(mf_colormap_cpt('speed'            , 30));
if flags.tune == 1
colormaps.AUC  = flipud(mf_colormap_cpt('apple-green'      , length(threshold_corr)));
end


% customize OT colormap
colormaps.OT(10,:) = colormaps.OT(9,:) ./ 2; % make an even darker blue


% customize perc colormap
colormaps.perc(9:14,:) = colormaps.perc(7:12,:);
colormaps.perc(7:8,:)  = [1 1 1; 1 1 1];


% customize corr colormap
colormaps.corr(1,:) = [1 1 1];


% line colors
colors = mf_colors;

                               
% define axes color                               
axcolor = [0.3 0.3 0.3]; % 70% contrast (so 0.3) is advised


% initialise alphabet letters
alphabet = ('a':'z')';


% initialise precipitation name parameters
legend_OT = ({'CTL','CORD','OBS'});



% --------------------------------------------------------------------
% paper figure 1
% --------------------------------------------------------------------


if flags.plot_fig1 == 1
   
        
% plot daytime
mf_plot_ea(lon_reg, lat_reg, OT_d_timsum, [], caxes.OT, colormaps.OT, res_reg, 0, 2, 'a', 'daytime OTp', 'OT pixel counts'); hold on;
export_fig figures/used/figure_01a -transparent % save .png at standard resolution
% export_fig figures/used/figure_01a_highres -m10 -transparent % save .png at high resolution


% plot nighttime 
mf_plot_ea(lon_reg, lat_reg, OT_n_timsum, [], caxes.OT, colormaps.OT, res_reg, 0, 2, 'b', 'nighttime OTp', 'OT pixel counts'); hold on;
annotation('textbox', [0.45 0.78 0 0], 'String', 'Uganda'  , 'Fontweight', 'Bold', 'Fontsize', 11, 'Color', [0.6 0.6 0.6], 'EdgeColor', 'none', 'ver', 'bottom', 'hor', 'left');
annotation('textbox', [0.62 0.70 0 0], 'String', 'Kenya'   , 'Fontweight', 'Bold', 'Fontsize', 11, 'Color', [0.6 0.6 0.6], 'EdgeColor', 'none', 'ver', 'bottom', 'hor', 'left');
annotation('textbox', [0.45 0.45 0 0], 'String', 'Tanzania', 'Fontweight', 'Bold', 'Fontsize', 11, 'Color', [0.6 0.6 0.6], 'EdgeColor', 'none', 'ver', 'bottom', 'hor', 'left');
export_fig figures/used/figure_01b -transparent % save .png at standard resolution
% export_fig figures/used/figure_01b_highres -m10 -transparent % save .png at high resolution


% plot percentages of OTs during day and night 
hcb = mf_plot_ea(lon_reg, lat_reg, OT_n_perc, [], caxes.perc, colormaps.perc, res_reg, 0, 2, 'c', 'diurnal cycle', ' '); hold on;
set(hcb,'XTick',[0 50 100], 'XTicklabel', {'100% day', 'mixed', '100% night'}, 'Fontweight', 'Bold', 'Fontsize', 12)
m_plot([lon_min_Vict lon_max_Vict lon_max_Vict lon_min_Vict lon_min_Vict], ...
       [lat_min_Vict lat_min_Vict lat_max_Vict lat_max_Vict lat_min_Vict], 'Color', colors(17,:), 'LineWidth',2.5);
export_fig figures/used/figure_01c -transparent % save .png at standard resolution
% export_fig figures/used/figure_01c_highres -m10 -transparent % save .png at high resolution



% compute spearman rank correlation between land pixels and total number of lake OTs
[OT_d_corr] = mf_3Dcorr(OT_d, OT_n_lp_shift);

% plot correlation map 
mf_plot_ea(lon_reg, lat_reg, OT_d_corr, [], caxes.corr, colormaps.corr, res_reg, 0, 2, 'd', 'correlation', 'Rank correlation'); hold on;

% select indices of pixels above threshold
iscorr = OT_d_corr > 0.20; % for plotting purposes only

% plot polygons around regions with OT_d_corr above threshold
iscorr3         = imresize(iscorr, 3, 'nearest');
lat_reg3        = imresize(lat_reg         , 3, 'bilinear');
lon_reg3        = imresize(lon_reg         , 3, 'bilinear');
predictor_bound = bwboundaries(iscorr3, 4);

% loop over polygons
for i=1:length(predictor_bound)
    
    % extract x/y indices of polygon
    indx = predictor_bound{i}(:,1);
    indy = predictor_bound{i}(:,2);
    
    % prepare for loop
    lon_bound = NaN(length(indx),1);
    lat_bound = NaN(length(indy),1);
    
    % get lat/lon indices of polygon
    for j=1:length(indx)
    lon_bound(j) = lon_reg3(indx(j), indy(j));
    lat_bound(j) = lat_reg3(indx(j), indy(j));
    end
    
    % plot polygon    
    m_plot(lon_bound, lat_bound - res_reg,'y-'); hold on; % no idea why I have to do "lat-res_reg" 
    
end
export_fig figures/used/figure_01d -transparent % save .png at standard resolution
% export_fig figures/used/figure_01d_highres -m10 -transparent % save .png at high resolution


% initialise grid parameters for Africa map
lat_min_Afr = -37;
lat_max_Afr = 39;
lon_min_Afr = -20;
lon_max_Afr = 55;


% plot inset
figure;
m_proj('Mercator','long',[lon_min_Afr-0.2 lon_max_Afr+0.2],'lat',[lat_min_Afr-0.2 lat_max_Afr+0.2]);
m_grid('xtick',[],'ytick',[],'box','off','tickdir','in', 'linestyle', 'none');hold on;
m_coast('color', axcolor, 'linewidth', 3);
bounds_lon     = [25  25  41 41 25]; % from mf_plot_ea
bounds_lat     = [ 6 -10 -10  6  6]; 
bounds_lon_Afr = [lon_min_Afr lon_min_Afr lon_max_Afr lon_max_Afr lon_min_Afr];
bounds_lat_Afr = [lat_max_Afr lat_min_Afr lat_min_Afr lat_max_Afr lat_max_Afr]; 
m_line(bounds_lon    , bounds_lat    , 'linewi', 3, 'color', 'r');
m_line(bounds_lon_Afr, bounds_lat_Afr, 'linewi', 8, 'color', axcolor);
export_fig figures/used/figure_01inset -transparent % save .png at standard resolution


% % plot daytime
% mf_plot_ea(lon_reg, lat_reg, OT_d_timsum, [], caxes.OT, colormaps.OT, res_reg, 0, 2, ' ', 'daytime storms', 'Overshooting Top pixel counts'); hold on;
% export_fig figures/used/figure_01a_Twitter  % save .png at standard resolution
% 
% 
% % plot nighttime 
% mf_plot_ea(lon_reg, lat_reg, OT_n_timsum, [], caxes.OT, colormaps.OT, res_reg, 0, 2, ' ', 'nighttime storms', 'Overshooting Top pixel counts'); hold on;
% annotation('textbox', [0.45 0.78 0 0], 'String', 'Uganda'  , 'Fontweight', 'Bold', 'Fontsize', 11, 'Color', [0.6 0.6 0.6], 'EdgeColor', 'none', 'ver', 'bottom', 'hor', 'left');
% annotation('textbox', [0.62 0.70 0 0], 'String', 'Kenya'   , 'Fontweight', 'Bold', 'Fontsize', 11, 'Color', [0.6 0.6 0.6], 'EdgeColor', 'none', 'ver', 'bottom', 'hor', 'left');
% annotation('textbox', [0.45 0.45 0 0], 'String', 'Tanzania', 'Fontweight', 'Bold', 'Fontsize', 11, 'Color', [0.6 0.6 0.6], 'EdgeColor', 'none', 'ver', 'bottom', 'hor', 'left');
% export_fig figures/used/figure_01b_Twitter  % save .png at standard resolution


end



% --------------------------------------------------------------------
% paper figure 2
% Hint: use "figure('OuterPosition',[400 300 450 400]);" for a single panel ROC curve plot
% --------------------------------------------------------------------



if flags.plot_fig2 == 1

    
% create image
subtightplot = @(m,n,p) mf_subtightplot (m, n, p, [0.05 0.06], [0.15 0.07], [0.10 0.05]);
figure('OuterPosition',[10 100 1500 400]);
set(gcf, 'color', 'w');
set(gca,'color','w');


% plot ROC curve - OT
subtightplot(1,3,1)
plot([0 1],[0 1], 'linewidth', 1.5, 'color', axcolor); hold on;
z(2,1) = plot(LOGR_OT.F    , LOGR_OT.H    , 'color', colors(16,:), 'linewidth', 2); hold on; % actual forecast
z(3,1) = plot(LOGR_OT.F_opt, LOGR_OT.H_opt, 'ok','MarkerEdgeColor', axcolor,'MarkerFaceColor', axcolor, 'markersize',7); hold on;
z(1,1) = plot(LOGR_OT_pers.F, LOGR_OT_pers.H, '--', 'color', colors(13,:), 'linewidth', 2); hold on; % persistence forecast
xlabel('False Alarm Rate', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Hit Rate'        , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
legend(z, ['AUC = ' num2str(LOGR_OT_pers.AUC,'%.2f')], ['AUC = ' num2str(LOGR_OT.AUC,'%.2f')], ...
    ['\theta = ' num2str(LOGR_OT.T_opt,'%.4f') 10 'H = ' num2str(LOGR_OT.H_opt,'%.2f') 10 'F = ' num2str(LOGR_OT.F_opt,'%.2f') 10 'OR = ' num2str(LOGR_OT.OR_opt,'%.0f')],4);
set(legend,'YColor','w','XColor','w', 'Fontweight', 'Bold', 'Fontsize', 10, 'TextColor', axcolor);
text(0.41, 0.83, ['Initial' 10 'configuration'], 'ver','bottom','hor','left','Fontsize', 10, 'Fontweight', 'Bold', 'color', colors(16,:))
text(0.44, 0.59, ['Persistence' 10 'forecast' ], 'ver','bottom','hor','left','Fontsize', 10, 'Fontweight', 'Bold', 'color', colors(13,:))
grid on;
text(0.01,1,'a','ver','bottom','hor','left','Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor)
text(0.99,1,'Satellite OTp','ver','bottom','hor','right','Fontsize', 11, 'Fontweight', 'Bold', 'color', axcolor)

    
% plot ROC curve - TRMM
subtightplot(1,3,2)
plot([0 1],[0 1], 'linewidth', 1.5, 'color', axcolor); hold on;
z(2,1) = plot(LOGR_TRMM.F    , LOGR_TRMM.H    , 'color', colors(16,:), 'linewidth', 2); hold on; % actual forecast
z(3,1) = plot(LOGR_TRMM.F_opt, LOGR_TRMM.H_opt, 'ok','MarkerEdgeColor', axcolor,'MarkerFaceColor', axcolor, 'markersize',7); hold on;
z(1,1) = plot(LOGR_TRMM_pers.F, LOGR_TRMM_pers.H, '--', 'color', colors(13,:), 'linewidth', 2); hold on; % persistence forecast
xlabel('False Alarm Rate', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Hit Rate'        , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
legend(z, ['AUC = ' num2str(LOGR_TRMM_pers.AUC,'%.2f')], ['AUC = ' num2str(LOGR_TRMM.AUC,'%.2f')], ...
    ['\theta = ' num2str(LOGR_TRMM.T_opt,'%.4f') 10 'H = ' num2str(LOGR_TRMM.H_opt,'%.2f') 10 'F = ' num2str(LOGR_TRMM.F_opt,'%.2f') 10 'OR = ' num2str(LOGR_TRMM.OR_opt,'%.0f')],4);
set(legend,'YColor','w','XColor','w', 'Fontweight', 'Bold', 'Fontsize', 10, 'TextColor', axcolor);
grid on;
text(0.01,1,'b','ver','bottom','hor','left','Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor)
text(0.99,1,'Satellite precipitation','ver','bottom','hor','right','Fontsize', 11, 'Fontweight', 'Bold', 'color', axcolor)


% plot ROC curve - CCLM
subtightplot(1,3,3)
plot([0 1],[0 1], 'linewidth', 1.5, 'color', axcolor); hold on;
z(2,1) = plot(LOGR_FLa.F    , LOGR_FLa.H    , 'color', colors(16,:), 'linewidth', 2); hold on; % actual forecast
z(3,1) = plot(LOGR_FLa.F_opt, LOGR_FLa.H_opt, 'ok', 'MarkerEdgeColor', axcolor,'MarkerFaceColor', axcolor, 'markersize',7); hold on;
z(1,1) = plot(LOGR_FLa_pers.F, LOGR_FLa_pers.H, '--', 'color', colors(13,:), 'linewidth', 2); hold on; % persistence forecast
xlabel('False Alarm Rate', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Hit Rate'        , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
legend(z, ['AUC = ' num2str(LOGR_FLa_pers.AUC,'%.2f')], ['AUC = ' num2str(LOGR_FLa.AUC,'%.2f')], ...
    ['\theta = ' num2str(LOGR_FLa.T_opt,'%.4f') 10 'H = ' num2str(LOGR_FLa.H_opt,'%.2f') 10 'F = ' num2str(LOGR_FLa.F_opt,'%.2f') 10 'OR = ' num2str(LOGR_FLa.OR_opt,'%.0f')],4);
set(legend,'YColor','w','XColor','w', 'Fontweight', 'Bold', 'Fontsize', 10, 'TextColor', axcolor);
grid on;
text(0.01,1,'c','ver','bottom','hor','left','Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor)
text(0.99,1,'Precipitation from downscaled reanalysis','ver','bottom','hor','right','Fontsize', 11, 'Fontweight', 'Bold', 'color', axcolor)


% save figure
export_fig figures/figure_02 -transparent;
% export_fig text/figures_paper/figure_02 -transparent -pdf;


end



% --------------------------------------------------------------------
% paper figure 3
% --------------------------------------------------------------------



if flags.plot_fig3 == 1


    
% initialise figure options
axlim_sens1      = [2.95    11 0.799 0.951]; % axes limits of panel a
axlim_sens2      = [2       14 0.799 0.951]; % axes limits of panel b
axlim_logreg     = [0    40000 0     1    ]; % axes limits of logreg panel
% axlim_logreg   = [0     4000 0     1    ]; % axes limits of logreg panel
figscale_logreg  = 1.9;                      % vertical scaling of logreg panel
figscale_boxplot = 0.2;                      % vertical scaling of boxplot panel
figshift_boxplot = 0.09;                     % vertical shift of boxplot panel
boxplot_y        = [0.2 0.8];                % y-axis location of boxplots


% locations where to plot text labels    
loc_labels_a = [10.0   0.87 ; ...   % 0.10
                 9.0   0.86 ; ...   % 0.15
                 7.8   0.85 ; ...   % 0.20
                 6.2   0.84 ; ...   % 0.25
                 4.2   0.83    ];   % 0.30
loc_labels_b = [ 2.2   0.899; ...   % 0.10
                 2.2   0.86 ; ...   % 0.15
                 3.6   0.88 ; ...   % 0.20
                 4.8   0.87 ; ...   % 0.25
                 6.2   0.835   ];   % 0.30


% create image
figure('OuterPosition',[100 50 1000 680]);
set(gcf, 'color', 'w');
set(gca,'color','w');


% get dummy axes positions for a classic 2 x 2 subplot structure
subplot(2,2,1); axpos.dummya = get(gca,'position'); % panel a
subplot(2,2,2); axpos.dummyb = get(gca,'position'); % panel b
subplot(2,2,3); axpos.dummyc = get(gca,'position'); % panel c
subplot(2,2,4); axpos.dummyd = get(gca,'position'); % panel d
    
             
% plot sensitivity - lead time
subplot(4,2,[1 3])
for i=1:length(threshold_corr)
    plot(lead_time - 1, squeeze(AUC_tuned(:, indy_max, i)), 'color', colormaps.AUC(i,:), 'linewidth', 2.5); hold on;
    text(loc_labels_a(i,1), loc_labels_a(i,2), num2str(threshold_corr(i),'%.2f'), 'ver', 'bottom', 'hor', 'left', 'Fontsize', 10, 'Fontweight', 'Bold', 'color', colormaps.AUC(i,:))
end
plot(lead_time(indx_max) - 1, AUC_tuned(indx_max, indy_max, indz_max), 'ok','MarkerEdgeColor', colors(11,:),'MarkerFaceColor', colors(11,:), 'markersize',7); hold on;
annotation('textarrow', [0.18 0.14], [0.905 0.885],'String',' Best model', 'Fontsize', 11, 'Fontweight', 'Bold', 'color', colors(11,:))
xlabel('Lead time (h)', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('AUC'          , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'position', axpos.dummya, 'XTick', 3:2:11, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
axis(axlim_sens1);
% axis([1 12 0.50 1]);
text(-0.15, 1.03, 'a', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')


% plot sensitivity - aggregation time
subplot(4,2,[2 4])
for i=1:length(threshold_corr)
    plot(aggregation_time, squeeze(AUC_tuned(indx_max, :, i)), 'color', colormaps.AUC(i,:), 'linewidth', 2.5); hold on;
    text(loc_labels_b(i,1), loc_labels_b(i,2), num2str(threshold_corr(i),'%.2f'), 'ver', 'bottom', 'hor', 'left', 'Fontsize', 10, 'Fontweight', 'Bold', 'color', colormaps.AUC(i,:))
end
plot(aggregation_time(indy_max), AUC_tuned(indx_max, indy_max, indz_max), 'ok','MarkerEdgeColor', colors(11,:),'MarkerFaceColor', colors(11,:), 'markersize',7); hold on;
annotation('textarrow', [0.87 0.9], [0.905 0.885],'String',' Best model', 'Fontsize', 11, 'Fontweight', 'Bold', 'color', colors(11,:))
xlabel('Aggregation time (h)', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
ylabel('AUC'                 , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'position', axpos.dummyb, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
axis(axlim_sens2);
% axis([2 14 0.799 1]);
text(-0.15, 1.03, 'b', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')


% prepare data for boxplots
boxplotdata                        = [LOGR_OT_best.predictor LOGR_OT_best.predictor];
boxplotdata( LOGR_OT_best.extr, 1) = NaN;                                          % non-extremes in column 1
boxplotdata(~LOGR_OT_best.extr, 2) = NaN;                                          % extremes in column 2


% plot box plots
subplot(4,2,5)
axpos.boxplot    = get(gca,'position');                                            % remove ticklabels so that originals appear
axpos.boxplot(2) = axpos.boxplot(2) +  figshift_boxplot;
axpos.boxplot(4) = axpos.boxplot(4) .* figscale_boxplot;
boxplot(boxplotdata, 'PlotStyle', 'compact', 'colors', [colors(24,:); colors(22,:)], 'symbol', 'k.', 'positions', boxplot_y, 'orientation', 'horizontal'); hold on; % plot boxplots
set(gca,'ytickmode','auto','yticklabelmode','auto');                               % remove ticklabels so that originals appear
h = findobj(gca,'tag','Outliers'); set(h,'Visible','off');                         % remove outliers
axis(axlim_logreg);
set(gca, 'position', axpos.boxplot, 'Fontsize', 12, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
axis off


% plot logistic regression curve
subplot(4,2,7)
axpos.logreg    = get(gca,'position');                                             % remove ticklabels so that originals appear
axpos.logreg(4) = axpos.logreg(4) .* figscale_logreg;
% plot(LOGR_OT_best.predictor(~LOGR_OT_best.extr), axlim_logreg(1) + 0.01, 'v', 'MarkerEdgeColor', colors(24,:),'MarkerFaceColor', colors(24,:), 'markersize', 5); hold on;
% plot(LOGR_OT_best.predictor( LOGR_OT_best.extr), axlim_logreg(4) - 0.01, '^', 'MarkerEdgeColor', colors(22,:),'MarkerFaceColor', colors(22,:), 'markersize', 5); hold on;
xvals = axlim_logreg(1):1:axlim_logreg(2);
[yvals, dyvals_lo, dyvals_hi] = glmval(LOGR_OT_best.b_all, xvals', 'logit', LOGR_OT_best.b_all_stats); % get uncertainty range
fill([xvals, fliplr(xvals)], [yvals' - dyvals_lo', fliplr(yvals' + dyvals_hi')], [0.8 0.8 0.8], 'EdgeColor', 'none'); hold on; % plot filled area
plot(xvals, yvals, 'linewidth', 1.5, 'color', axcolor); hold on;                                                               % plot regression line
axis(axlim_logreg);
set(gca, 'position', axpos.logreg, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
xlabel('Afternoon land OTp', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Probability'      , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
text(axlim_logreg(2),1,'Best model','ver','bottom','hor','right','Fontsize', 11, 'Fontweight', 'Bold', 'color', colors(11,:))
text(-0.15, 1.15, 'c', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')


% plot ROC curve - OT
subplot(4,2,[6 8])
zz(1,1) = plot(LOGR_OT_best.F    , LOGR_OT_best.H    ,       'color', colors(16,:), 'linewidth', 2); hold on; % actual forecast
zz(2,1) = plot(LOGR_OT_best.F_opt, LOGR_OT_best.H_opt, 'ok','MarkerEdgeColor', axcolor,'MarkerFaceColor', axcolor, 'markersize',7); hold on;
plot([0 1],[0 1], 'linewidth', 1.5, 'color', axcolor); hold off;
xlabel('False Alarm Rate', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Hit Rate'        , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'position', axpos.dummyd, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
legend(zz,['AUC = ' num2str(LOGR_OT_best.AUC,'%.2f')], ...
    ['\theta = ' num2str(LOGR_OT_best.T_opt,'%.4f') 10 'H = ' num2str(LOGR_OT_best.H_opt,'%.2f') 10 'F = ' num2str(LOGR_OT_best.F_opt,'%.2f') 10 'OR = ' num2str(LOGR_OT_best.OR_opt,'%.0f')],4);
set(legend,'YColor','w','XColor','w', 'Fontweight', 'Bold', 'Fontsize', 11, 'TextColor', axcolor);
grid on;
text(-0.15, 1.03, 'd', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')
text(0.99,1,'Best model','ver','bottom','hor','right','Fontsize', 11, 'Fontweight', 'Bold', 'color', colors(11,:))


% save figure
export_fig figures/figure_03 -transparent;
% export_fig text/figures_paper/figure_03 -transparent -pdf;



end



% --------------------------------------------------------------------
% paper figure 4
% --------------------------------------------------------------------



if flags.plot_fig4 == 1


% define threshold for stippling line
% threshold = 70; % [%]
threshold1 = 30; % [%]
threshold2 = 50; % [%]
threshold3 = 70; % [%]


% create image
subtightplot = @(m,n,p) mf_subtightplot (m, n, p, [0.05 0.10], [0.15 0.07], [0.10 0.05]);
figure('OuterPosition',[100 100 1100 400]);
set(gcf, 'color', 'w');
set(gca,'color','w');


% plot fraction
subtightplot(1,2,1)
z(3,1) = plot(1:nbins - 1, OT_n_lp_shift_frac   , 'linewidth', 2, 'color', axcolor     ); hold on;
z(1,1) = plot(1:nbins - 1, false_alarms_opt_frac, 'linewidth', 2, 'color', colors(17,:)); hold on;
z(2,1) = plot(1:nbins - 1, false_alarms_H05_frac, 'linewidth', 2, 'color', colors(16,:)); hold on;
axis([1 100 0 7]);
xlabel('Nighttime OTp percentile'     , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Fraction of false alarms (%)', 'Fontsize', 11, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'Fontsize', 11, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor, 'xtick', [1 10:10:100]);
legend(z, 'Optimal point', 'H=0.5', 'No relation', 2)
set(legend,'YColor','w','XColor','w', 'Fontweight', 'Bold', 'Fontsize', 10, 'TextColor', axcolor);
text(1.5,7,'a','ver','bottom','hor','left','Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor)

   
% plot cumulative fraction
subtightplot(1,2,2)
z(3,1) = plot(1:nbins, OT_n_lp_shift_cumfrac   , 'linewidth', 2, 'color', axcolor     ); hold on;
z(1,1) = plot(1:nbins, false_alarms_opt_cumfrac, 'linewidth', 2, 'color', colors(17,:)); hold on;
z(2,1) = plot(1:nbins, false_alarms_H05_cumfrac, 'linewidth', 2, 'color', colors(16,:)); hold on;
plot([1 find(false_alarms_H05_cumfrac >= threshold3, 1, 'first') find(false_alarms_H05_cumfrac >= threshold3, 1, 'first')], [threshold3 threshold3 0], ':', 'linewidth', 2, 'color', colors(19,:)); hold on;
plot([1 find(false_alarms_opt_cumfrac >= threshold3, 1, 'first') find(false_alarms_opt_cumfrac >= threshold3, 1, 'first')], [threshold3 threshold3 0], ':', 'linewidth', 2, 'color', colors(20,:)); hold on;
plot(find(false_alarms_H05_cumfrac >= threshold1, 1, 'first'), threshold1, 'ok','MarkerEdgeColor', colors(16,:), 'MarkerFaceColor', colors(16,:)); hold on;
plot(find(false_alarms_opt_cumfrac >= threshold1, 1, 'first'), threshold1, 'ok','MarkerEdgeColor', colors(17,:), 'MarkerFaceColor', colors(17,:)); hold on;
plot(find(false_alarms_H05_cumfrac >= threshold2, 1, 'first'), threshold2, 'ok','MarkerEdgeColor', colors(16,:), 'MarkerFaceColor', colors(16,:)); hold on;
plot(find(false_alarms_opt_cumfrac >= threshold2, 1, 'first'), threshold2, 'ok','MarkerEdgeColor', colors(17,:), 'MarkerFaceColor', colors(17,:)); hold on;
plot(find(false_alarms_H05_cumfrac >= threshold3, 1, 'first'), threshold3, 'ok','MarkerEdgeColor', colors(16,:), 'MarkerFaceColor', colors(16,:)); hold on;
plot(find(false_alarms_opt_cumfrac >= threshold3, 1, 'first'), threshold3, 'ok','MarkerEdgeColor', colors(17,:), 'MarkerFaceColor', colors(17,:)); hold on;
axis([1 100 0 100]);
xlabel('Nighttime OTp percentile'     , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Cumulative fraction of false alarms (%)', 'Fontsize', 11, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'Fontsize', 11, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor, 'xtick', [1 10:10:100], 'ytick', [0:10:100]);
legend(z, 'Optimal point', 'H=0.5', 'No relation', 2)
set(legend,'YColor','w','XColor','w', 'Fontweight', 'Bold', 'Fontsize', 10, 'TextColor', axcolor);
text(1.5,100,'b','ver','bottom','hor','left','Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor)


% save figure
export_fig figures/figure_04 -transparent;
% export_fig text/figures_paper/figure_04 -pdf;


end



% --------------------------------------------------------------------
% paper supplementary figure 1
% !!! use circshift +3 to convert UTC to EAT !!!
% --------------------------------------------------------------------



if flags.plot_sfig1 == 1

    
% compute spatial avereges needed for this figure    
[~, OT_yhoursum_lp    ] = mf_fieldmean(OT_yhoursum, isvict    );
[~, OT_yhoursum_lp_Uga] = mf_fieldmean(OT_yhoursum, isvict_Uga);
[~, OT_yhoursum_lp_Ken] = mf_fieldmean(OT_yhoursum, isvict_Ken);
[~, OT_yhoursum_lp_Tan] = mf_fieldmean(OT_yhoursum, isvict_Tan);
[~, OT_yhoursum_gp    ] = mf_fieldmean(OT_yhoursum, issurr    );


% create image
figure('OuterPosition',[10 100 1100 410]);
set(gcf, 'color', 'w');
set(gca,'color','w');
    
             
% plot dirunal cycle - whole lake
subplot(1,2,1)
plot(1:24, circshift(OT_yhoursum_lp, +3), '-', 'color', colors(24,:), 'linewidth', 2.5); hold on;
plot(1:24, circshift(OT_yhoursum_gp, +3), '-', 'color', colors(23,:), 'linewidth', 2.5); hold on;
% plot([1 24],[320 320],'k'); hold on;
axis([1 24 0 1400]);
legend('Lake Victoria','Surrounding land', 1);
set(legend,'YColor','w','XColor','w', 'Fontweight', 'Bold', 'Fontsize', 11, 'TextColor', axcolor);
xlabel('EAT'   , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('OTp count', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor, 'xtick', 0:4:24);
mf_XMinorTick(4, axcolor)
text(-0.15, 1.03, 'a', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')


% plot dirunal cycle - lake sectors
subplot(1,2,2)
plot(1:24, circshift(OT_yhoursum_lp_Uga, +3), ':', 'color', colors(24,:), 'linewidth', 2.5); hold on;
plot(1:24, circshift(OT_yhoursum_lp_Ken, +3), '--', 'color', colors(24,:), 'linewidth', 2.5); hold on;
plot(1:24, circshift(OT_yhoursum_lp_Tan, +3), '-' , 'color', colors(24,:), 'linewidth', 2.5); hold on;
% plot([1 24],[320 320],'k'); hold on;
axis([1 24 0 1450]);
legend('Sector Uganda',' Sector Kenya','Sector Tanzania', 2);
set(legend,'YColor','w','XColor','w', 'Fontweight', 'Bold', 'Fontsize', 11, 'TextColor', axcolor);
xlabel('EAT'   , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('OTp count', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor, 'xtick', 0:4:24);
mf_XMinorTick(4, axcolor)
text(-0.15, 1.03, 'b', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')


% save figure
export_fig figures/supp_figure_01 -transparent;
% export_fig text/figures_paper/supp_figure_01 -transparent -pdf;
   

end


% --------------------------------------------------------------------
% paper supplementary figure 2
% --------------------------------------------------------------------



if flags.plot_sfig2 == 1

    
% create image
subtightplot = @(m,n,p) mf_subtightplot (m, n, p, [0.05 0.06], [0.15 0.07], [0.10 0.05]);
figure('OuterPosition',[10 100 1500 400]);
set(gcf, 'color', 'w');
set(gca,'color','w');


% plot ROC curve - OT
subtightplot(1,3,1)
plot([0 1],[0 1], 'linewidth', 1.5, 'color', axcolor); hold on;
z(2,1) = plot(LOGR_OT_lp.F    , LOGR_OT_lp.H    , 'color', colors(16,:), 'linewidth', 2); hold on; % actual forecast
z(3,1) = plot(LOGR_OT_lp.F_opt, LOGR_OT_lp.H_opt, 'ok','MarkerEdgeColor', axcolor,'MarkerFaceColor', axcolor, 'markersize',7); hold on;
z(1,1) = plot(LOGR_OT_pers.F, LOGR_OT_pers.H, '--', 'color', colors(13,:), 'linewidth', 2); hold on; % persistence forecast
xlabel('False Alarm Rate', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Hit Rate'        , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
legend(z, ['AUC = ' num2str(LOGR_OT_pers.AUC,'%.2f')], ['AUC = ' num2str(LOGR_OT_lp.AUC,'%.2f')], ...
    ['\theta = ' num2str(LOGR_OT_lp.T_opt,'%.4f') 10 'H = ' num2str(LOGR_OT_lp.H_opt,'%.2f') 10 'F = ' num2str(LOGR_OT_lp.F_opt,'%.2f') 10 'OR = ' num2str(LOGR_OT_lp.OR_opt,'%.0f')],4);
set(legend,'YColor','w','XColor','w', 'Fontweight', 'Bold', 'Fontsize', 10, 'TextColor', axcolor);
text(0.21, 0.73, ['Persistence' 10 'forecast,' 10 'afternoon'], 'ver','bottom','hor','left','Fontsize', 10, 'Fontweight', 'Bold', 'color', colors(16,:))
text(0.44, 0.53, ['Persistence' 10 'forecast,' 10 'night'], 'ver','bottom','hor','left','Fontsize', 10, 'Fontweight', 'Bold', 'color', colors(13,:))
grid on;
text(0.01,1,'a','ver','bottom','hor','left','Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor)
text(0.99,1,'Satellite OTp','ver','bottom','hor','right','Fontsize', 11, 'Fontweight', 'Bold', 'color', axcolor)

    
% plot ROC curve - TRMM
subtightplot(1,3,2)
plot([0 1],[0 1], 'linewidth', 1.5, 'color', axcolor); hold on;
z(2,1) = plot(LOGR_TRMM_lp.F    , LOGR_TRMM_lp.H    , 'color', colors(16,:), 'linewidth', 2); hold on; % actual forecast
z(3,1) = plot(LOGR_TRMM_lp.F_opt, LOGR_TRMM_lp.H_opt, 'ok','MarkerEdgeColor', axcolor,'MarkerFaceColor', axcolor, 'markersize',7); hold on;
z(1,1) = plot(LOGR_TRMM_pers.F, LOGR_TRMM_pers.H, '--', 'color', colors(13,:), 'linewidth', 2); hold on; % persistence forecast
xlabel('False Alarm Rate', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Hit Rate'        , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
legend(z, ['AUC = ' num2str(LOGR_TRMM_pers.AUC,'%.2f')], ['AUC = ' num2str(LOGR_TRMM_lp.AUC,'%.2f')], ...
    ['\theta = ' num2str(LOGR_TRMM_lp.T_opt,'%.4f') 10 'H = ' num2str(LOGR_TRMM_lp.H_opt,'%.2f') 10 'F = ' num2str(LOGR_TRMM_lp.F_opt,'%.2f') 10 'OR = ' num2str(LOGR_TRMM_lp.OR_opt,'%.0f')],4);
set(legend,'YColor','w','XColor','w', 'Fontweight', 'Bold', 'Fontsize', 10, 'TextColor', axcolor);
grid on;
text(0.01,1,'b','ver','bottom','hor','left','Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor)
text(0.99,1,'Satellite precipitation','ver','bottom','hor','right','Fontsize', 11, 'Fontweight', 'Bold', 'color', axcolor)


% plot ROC curve - CCLM
subtightplot(1,3,3)
plot([0 1],[0 1], 'linewidth', 1.5, 'color', axcolor); hold on;
z(2,1) = plot(LOGR_FLa_lp.F    , LOGR_FLa_lp.H    , 'color', colors(16,:), 'linewidth', 2); hold on; % actual forecast
z(3,1) = plot(LOGR_FLa_lp.F_opt, LOGR_FLa_lp.H_opt, 'ok', 'MarkerEdgeColor', axcolor,'MarkerFaceColor', axcolor, 'markersize',7); hold on;
z(1,1) = plot(LOGR_FLa_pers.F, LOGR_FLa_pers.H, '--', 'color', colors(13,:), 'linewidth', 2); hold on; % persistence forecast
xlabel('False Alarm Rate', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Hit Rate'        , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
legend(z, ['AUC = ' num2str(LOGR_FLa_pers.AUC,'%.2f')], ['AUC = ' num2str(LOGR_FLa_lp.AUC,'%.2f')], ...
    ['\theta = ' num2str(LOGR_FLa_lp.T_opt,'%.4f') 10 'H = ' num2str(LOGR_FLa_lp.H_opt,'%.2f') 10 'F = ' num2str(LOGR_FLa_lp.F_opt,'%.2f') 10 'OR = ' num2str(LOGR_FLa_lp.OR_opt,'%.0f')],4);
set(legend,'YColor','w','XColor','w', 'Fontweight', 'Bold', 'Fontsize', 10, 'TextColor', axcolor);
grid on;
text(0.01,1,'c','ver','bottom','hor','left','Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor)
text(0.99,1,'Precipitation from downscaled reanalysis','ver','bottom','hor','right','Fontsize', 11, 'Fontweight', 'Bold', 'color', axcolor)


% save figure
export_fig figures/supp_figure_02 -transparent;
% export_fig text/figures_paper/supp_figure_02 -transparent -pdf;


end



% --------------------------------------------------------------------
% paper supplementary figure 3
% --------------------------------------------------------------------



if flags.plot_sfig3 == 1


% initialise figure options
axlim_sens1      = [2.95    11 0.4   0.951]; % axes limits of panel a
axlim_sens2      = [2       14 0.4   0.951]; % axes limits of panel b
axlim_logreg     = [0    20000 0     1    ]; % axes limits of logreg panel
figscale_logreg  = 1.9;                      % vertical scaling of logreg panel
figscale_boxplot = 0.2;                      % vertical scaling of boxplot panel
figshift_boxplot = 0.09;                     % vertical shift of boxplot panel
boxplot_y        = [0.2 0.8];                % y-axis location of boxplots


% locations where to plot text labels    
loc_labels_a = [10.0   0.87 ; ...   % 0.10
                 8.1   0.80 ; ...   % 0.15
                 6.2   0.73 ; ...   % 0.20
                 4.2   0.68 ; ...   % 0.25
                -1.0   0.0     ];   % 0.30
loc_labels_b = [ 2.2   0.84 ; ...   % 0.10
                 2.8   0.76 ; ...   % 0.15
                 3.6   0.68 ; ...   % 0.20
                 4.8   0.54 ; ...   % 0.25
                 3.0   0.0     ];   % 0.30


% create image
figure('OuterPosition',[100 50 1000 680]);
set(gcf, 'color', 'w');
set(gca,'color','w');


% get dummy axes positions for a classic 2 x 2 subplot structure
subplot(2,2,1); axpos.dummya = get(gca,'position'); % panel a
subplot(2,2,2); axpos.dummyb = get(gca,'position'); % panel b
subplot(2,2,3); axpos.dummyc = get(gca,'position'); % panel c
subplot(2,2,4); axpos.dummyd = get(gca,'position'); % panel d
    
             
% plot sensitivity - lead time
subplot(4,2,[1 3])
for i=1:length(threshold_corr)
    plot(lead_time - 1, squeeze(AUC_tuned_Uga(:, indy_max_Uga, i)), 'color', colormaps.AUC(i,:), 'linewidth', 2.5); hold on;
    text(loc_labels_a(i,1), loc_labels_a(i,2), num2str(threshold_corr(i),'%.2f'), 'ver', 'bottom', 'hor', 'left', 'Fontsize', 10, 'Fontweight', 'Bold', 'color', colormaps.AUC(i,:))
end
plot(lead_time(indx_max_Uga) - 1, AUC_tuned_Uga(indx_max_Uga, indy_max_Uga, indz_max_Uga), 'ok','MarkerEdgeColor', colors(11,:),'MarkerFaceColor', colors(11,:), 'markersize',7); hold on;
annotation('textarrow', [0.31 0.27], [0.905 0.885],'String',' Best model', 'Fontsize', 11, 'Fontweight', 'Bold', 'color', colors(11,:))
xlabel('Lead time (h)', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('AUC'          , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'position', axpos.dummya, 'XTick', 3:2:11, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
axis(axlim_sens1);
text(-0.15, 1.03, 'a', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')


% plot sensitivity - aggregation time
subplot(4,2,[2 4])
for i=1:length(threshold_corr)
    plot(aggregation_time, squeeze(AUC_tuned_Uga(indx_max_Uga, :, i)), 'color', colormaps.AUC(i,:), 'linewidth', 2.5); hold on;
    text(loc_labels_b(i,1), loc_labels_b(i,2), num2str(threshold_corr(i),'%.2f'), 'ver', 'bottom', 'hor', 'left', 'Fontsize', 10, 'Fontweight', 'Bold', 'color', colormaps.AUC(i,:))
end
plot(aggregation_time(indy_max_Uga), AUC_tuned_Uga(indx_max_Uga, indy_max_Uga, indz_max_Uga), 'ok','MarkerEdgeColor', colors(11,:),'MarkerFaceColor', colors(11,:), 'markersize',7); hold on;
annotation('textarrow', [0.87 0.9], [0.905 0.885],'String',' Best model', 'Fontsize', 11, 'Fontweight', 'Bold', 'color', colors(11,:))
xlabel('Aggregation time (h)', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
ylabel('AUC'                 , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'position', axpos.dummyb, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
axis(axlim_sens2);
text(-0.15, 1.03, 'b', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')


% prepare data for boxplots
boxplotdata_Uga                            = [LOGR_OT_best_Uga.predictor LOGR_OT_best_Uga.predictor];
boxplotdata_Uga( LOGR_OT_best_Uga.extr, 1) = NaN;                                  % non-extremes in column 1
boxplotdata_Uga(~LOGR_OT_best_Uga.extr, 2) = NaN;                                  % extremes in column 2


% plot box plots
subplot(4,2,5)
axpos.boxplot    = get(gca,'position');                                            % remove ticklabels so that originals appear
axpos.boxplot(2) = axpos.boxplot(2) +  figshift_boxplot;
axpos.boxplot(4) = axpos.boxplot(4) .* figscale_boxplot;
boxplot(boxplotdata_Uga, 'PlotStyle', 'compact', 'colors', [colors(24,:); colors(22,:)], 'symbol','k.','positions', boxplot_y, 'orientation', 'horizontal'); hold on; % plot boxplots
set(gca,'ytickmode','auto','yticklabelmode','auto');                               % remove ticklabels so that originals appear
h = findobj(gca,'tag','Outliers'); set(h,'Visible','off');                         % remove outliers
axis(axlim_logreg);
set(gca, 'position', axpos.boxplot, 'Fontsize', 12, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
axis off


% plot logistic regression curve
subplot(4,2,7)
axpos.logreg    = get(gca,'position');                                                                                         % remove ticklabels so that originals appear
axpos.logreg(4) = axpos.logreg(4) .* figscale_logreg;
xvals = axlim_logreg(1):1:axlim_logreg(2);
[yvals, dyvals_lo, dyvals_hi] = glmval(LOGR_OT_best_Uga.b_all, xvals', 'logit', LOGR_OT_best_Uga.b_all_stats);                 % get uncertainty range
fill([xvals, fliplr(xvals)], [yvals' - dyvals_lo', fliplr(yvals' + dyvals_hi')], [0.8 0.8 0.8], 'EdgeColor', 'none'); hold on; % plot filled area
plot(xvals, yvals, 'linewidth', 1.5, 'color', axcolor); hold on;                                                               % plot regression line
axis(axlim_logreg);
set(gca, 'position', axpos.logreg, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
xlabel('Afternoon land OTp', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Probability'      , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
text(axlim_logreg(2),1,'Best model','ver','bottom','hor','right','Fontsize', 11, 'Fontweight', 'Bold', 'color', colors(11,:))
text(-0.15, 1.15, 'c', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')


% plot ROC curve - OT
subplot(4,2,[6 8])
zz(1,1) = plot(LOGR_OT_best_Uga.F    , LOGR_OT_best_Uga.H    ,       'color', colors(16,:), 'linewidth', 2); hold on; % actual forecast
zz(2,1) = plot(LOGR_OT_best_Uga.F_opt, LOGR_OT_best_Uga.H_opt, 'ok','MarkerEdgeColor', axcolor,'MarkerFaceColor', axcolor, 'markersize',7); hold on;
plot([0 1],[0 1], 'linewidth', 1.5, 'color', axcolor); hold off;
xlabel('False Alarm Rate', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Hit Rate'        , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'position', axpos.dummyd, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
legend(zz,['AUC = ' num2str(LOGR_OT_best_Uga.AUC,'%.2f')], ...
    ['\theta = ' num2str(LOGR_OT_best_Uga.T_opt,'%.4f') 10 'H = ' num2str(LOGR_OT_best_Uga.H_opt,'%.2f') 10 'F = ' num2str(LOGR_OT_best_Uga.F_opt,'%.2f') 10 'OR = ' num2str(LOGR_OT_best_Uga.OR_opt,'%.0f')],4);
set(legend,'YColor','w','XColor','w', 'Fontweight', 'Bold', 'Fontsize', 11, 'TextColor', axcolor);
grid on;
text(-0.15, 1.03, 'd', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')
text(0.99,1,'Best model','ver','bottom','hor','right','Fontsize', 11, 'Fontweight', 'Bold', 'color', colors(11,:))


% save figure
export_fig figures/supp_figure_03 -transparent;
% export_fig text/figures_paper/supp_figure_03 -transparent -pdf;

    

end



% --------------------------------------------------------------------
% paper supplementary figure 4
% --------------------------------------------------------------------



if flags.plot_sfig4 == 1


    
% initialise figure options
axlim_sens1      = [2.95    11 0.4   0.951]; % axes limits of panel a
axlim_sens2      = [2       14 0.4   0.951]; % axes limits of panel b
axlim_logreg     = [0     8000 0     1    ]; % axes limits of logreg panel
figscale_logreg  = 1.9;                      % vertical scaling of logreg panel
figscale_boxplot = 0.2;                      % vertical scaling of boxplot panel
figshift_boxplot = 0.09;                     % vertical shift of boxplot panel
boxplot_y        = [0.2 0.8];                % y-axis location of boxplots


% locations where to plot text labels    
loc_labels_a = [10.0   0.77 ; ...   % 0.10
                 8.1   0.68 ; ...   % 0.15
                 6.2   0.63 ; ...   % 0.20
                -1.0   0.0  ; ...   % 0.25
                -1.0   0.0     ];   % 0.30
loc_labels_b = [ 2.2   0.74 ; ...   % 0.10
                 5.8   0.66 ; ...   % 0.15
                 8.8   0.58 ; ...   % 0.20
                 3.0   0.0  ; ...   % 0.25
                 3.0   0.0     ];   % 0.30


% create image
figure('OuterPosition',[100 50 1000 680]);
set(gcf, 'color', 'w');
set(gca,'color','w');


% get dummy axes positions for a classic 2 x 2 subplot structure
subplot(2,2,1); axpos.dummya = get(gca,'position'); % panel a
subplot(2,2,2); axpos.dummyb = get(gca,'position'); % panel b
subplot(2,2,3); axpos.dummyc = get(gca,'position'); % panel c
subplot(2,2,4); axpos.dummyd = get(gca,'position'); % panel d
    
             
% plot sensitivity - lead time
subplot(4,2,[1 3])
for i=1:length(threshold_corr)
    plot(lead_time - 1, squeeze(AUC_tuned_Ken(:, indy_max_Ken, i)), 'color', colormaps.AUC(i,:), 'linewidth', 2.5); hold on;
    text(loc_labels_a(i,1), loc_labels_a(i,2), num2str(threshold_corr(i),'%.2f'), 'ver', 'bottom', 'hor', 'left', 'Fontsize', 10, 'Fontweight', 'Bold', 'color', colormaps.AUC(i,:))
end
plot(lead_time(indx_max_Ken) - 1, AUC_tuned_Ken(indx_max_Ken, indy_max_Ken, indz_max_Ken), 'ok','MarkerEdgeColor', colors(11,:),'MarkerFaceColor', colors(11,:), 'markersize',7); hold on;
annotation('textarrow', [0.18 0.14], [0.865 0.845],'String',' Best model', 'Fontsize', 11, 'Fontweight', 'Bold', 'color', colors(11,:))
xlabel('Lead time (h)', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('AUC'          , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'position', axpos.dummya, 'XTick', 3:2:11, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
axis(axlim_sens1);
text(-0.15, 1.03, 'a', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')


% plot sensitivity - aggregation time
subplot(4,2,[2 4])
for i=1:length(threshold_corr)
    plot(aggregation_time, squeeze(AUC_tuned_Ken(indx_max_Ken, :, i)), 'color', colormaps.AUC(i,:), 'linewidth', 2.5); hold on;
    text(loc_labels_b(i,1), loc_labels_b(i,2), num2str(threshold_corr(i),'%.2f'), 'ver', 'bottom', 'hor', 'left', 'Fontsize', 10, 'Fontweight', 'Bold', 'color', colormaps.AUC(i,:))
end
plot(aggregation_time(indy_max_Ken), AUC_tuned_Ken(indx_max_Ken, indy_max_Ken, indz_max_Ken), 'ok','MarkerEdgeColor', colors(11,:),'MarkerFaceColor', colors(11,:), 'markersize',7); hold on;
annotation('textarrow', [0.75 0.78], [0.865 0.845],'String',' Best model', 'Fontsize', 11, 'Fontweight', 'Bold', 'color', colors(11,:))
xlabel('Aggregation time (h)', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
ylabel('AUC'                 , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'position', axpos.dummyb, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
axis(axlim_sens2);
text(-0.15, 1.03, 'b', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')


% prepare data for boxplots
boxplotdata_Ken                            = [LOGR_OT_best_Ken.predictor LOGR_OT_best_Ken.predictor];
boxplotdata_Ken( LOGR_OT_best_Ken.extr, 1) = NaN;                                  % non-extremes in column 1
boxplotdata_Ken(~LOGR_OT_best_Ken.extr, 2) = NaN;                                  % extremes in column 2


% plot box plots
subplot(4,2,5)
axpos.boxplot    = get(gca,'position');                                            % remove ticklabels so that originals appear
axpos.boxplot(2) = axpos.boxplot(2) +  figshift_boxplot;
axpos.boxplot(4) = axpos.boxplot(4) .* figscale_boxplot;
boxplot(boxplotdata_Ken, 'PlotStyle', 'compact', 'colors', [colors(24,:); colors(22,:)], 'symbol','k.','positions', boxplot_y, 'orientation', 'horizontal'); hold on; % plot boxplots
set(gca,'ytickmode','auto','yticklabelmode','auto');                               % remove ticklabels so that originals appear
h = findobj(gca,'tag','Outliers'); set(h,'Visible','off');                         % remove outliers
axis(axlim_logreg);
set(gca, 'position', axpos.boxplot, 'Fontsize', 12, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
axis off


% plot logistic regression curve
subplot(4,2,7)
axpos.logreg    = get(gca,'position');                                                                                         % remove ticklabels so that originals appear
axpos.logreg(4) = axpos.logreg(4) .* figscale_logreg;
xvals = axlim_logreg(1):1:axlim_logreg(2);
[yvals, dyvals_lo, dyvals_hi] = glmval(LOGR_OT_best_Ken.b_all, xvals', 'logit', LOGR_OT_best_Ken.b_all_stats);                 % get uncertainty range
fill([xvals, fliplr(xvals)], [yvals' - dyvals_lo', fliplr(yvals' + dyvals_hi')], [0.8 0.8 0.8], 'EdgeColor', 'none'); hold on; % plot filled area
plot(xvals, yvals, 'linewidth', 1.5, 'color', axcolor); hold on;                                                               % plot regression line
axis(axlim_logreg);
set(gca, 'position', axpos.logreg, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
xlabel('Afternoon land OTp', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Probability'      , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
text(axlim_logreg(2),1,'Best model','ver','bottom','hor','right','Fontsize', 11, 'Fontweight', 'Bold', 'color', colors(11,:))
text(-0.15, 1.15, 'c', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')


% plot ROC curve - OT
subplot(4,2,[6 8])
zz(1,1) = plot(LOGR_OT_best_Ken.F    , LOGR_OT_best_Ken.H    ,       'color', colors(16,:), 'linewidth', 2); hold on; % actual forecast
zz(2,1) = plot(LOGR_OT_best_Ken.F_opt, LOGR_OT_best_Ken.H_opt, 'ok','MarkerEdgeColor', axcolor,'MarkerFaceColor', axcolor, 'markersize',7); hold on;
plot([0 1],[0 1], 'linewidth', 1.5, 'color', axcolor); hold off;
xlabel('False Alarm Rate', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Hit Rate'        , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'position', axpos.dummyd, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
legend(zz,['AUC = ' num2str(LOGR_OT_best_Ken.AUC,'%.2f')], ...
    ['\theta = ' num2str(LOGR_OT_best_Ken.T_opt,'%.4f') 10 'H = ' num2str(LOGR_OT_best_Ken.H_opt,'%.2f') 10 'F = ' num2str(LOGR_OT_best_Ken.F_opt,'%.2f') 10 'OR = ' num2str(LOGR_OT_best_Ken.OR_opt,'%.0f')],4);
set(legend,'YColor','w','XColor','w', 'Fontweight', 'Bold', 'Fontsize', 11, 'TextColor', axcolor);
grid on;
text(-0.15, 1.03, 'd', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')
text(0.99,1,'Best model','ver','bottom','hor','right','Fontsize', 11, 'Fontweight', 'Bold', 'color', colors(11,:))


% save figure
export_fig figures/supp_figure_04 -transparent;
% export_fig text/figures_paper/supp_figure_04 -transparent -pdf;

    

end



% --------------------------------------------------------------------
% paper supplementary figure 5
% --------------------------------------------------------------------



if flags.plot_sfig5 == 1


    
% initialise figure options
axlim_sens1      = [2.95    11 0.4   0.971]; % axes limits of panel a
axlim_sens2      = [2       14 0.4   0.971]; % axes limits of panel b
axlim_logreg     = [0    50000 0     1    ]; % axes limits of logreg panel
figscale_logreg  = 1.9;                      % vertical scaling of logreg panel
figscale_boxplot = 0.2;                      % vertical scaling of boxplot panel
figshift_boxplot = 0.09;                     % vertical shift of boxplot panel
boxplot_y        = [0.2 0.8];                % y-axis location of boxplots


% locations where to plot text labels    
loc_labels_a = [10.0   0.90 ; ...   % 0.10
                 8.1   0.86 ; ...   % 0.15
                 6.2   0.77 ; ...   % 0.20
                 5.2   0.70 ; ...   % 0.25
                 4.2   0.62    ];   % 0.30
loc_labels_b = [ 2.2   0.86 ; ...   % 0.10
                 2.8   0.79 ; ...   % 0.15
                 3.6   0.69 ; ...   % 0.20
                 4.5   0.62 ; ...   % 0.25
                 5.8   0.48    ];   % 0.30


% create image
figure('OuterPosition',[100 50 1000 680]);
set(gcf, 'color', 'w');
set(gca,'color','w');


% get dummy axes positions for a classic 2 x 2 subplot structure
subplot(2,2,1); axpos.dummya = get(gca,'position'); % panel a
subplot(2,2,2); axpos.dummyb = get(gca,'position'); % panel b
subplot(2,2,3); axpos.dummyc = get(gca,'position'); % panel c
subplot(2,2,4); axpos.dummyd = get(gca,'position'); % panel d
    
             
% plot sensitivity - lead time
subplot(4,2,[1 3])
for i=1:length(threshold_corr)
    plot(lead_time - 1, squeeze(AUC_tuned_Tan(:, indy_max_Tan, i)), 'color', colormaps.AUC(i,:), 'linewidth', 2.5); hold on;
    text(loc_labels_a(i,1), loc_labels_a(i,2), num2str(threshold_corr(i),'%.2f'), 'ver', 'bottom', 'hor', 'left', 'Fontsize', 10, 'Fontweight', 'Bold', 'color', colormaps.AUC(i,:))
end
plot(lead_time(indx_max_Tan) - 1, AUC_tuned_Tan(indx_max_Tan, indy_max_Tan, indz_max_Tan), 'ok','MarkerEdgeColor', colors(11,:),'MarkerFaceColor', colors(11,:), 'markersize',7); hold on;
annotation('textarrow', [0.325 0.305], [0.900 0.895],'String',' Best model', 'Fontsize', 11, 'Fontweight', 'Bold', 'color', colors(11,:))
xlabel('Lead time (h)', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('AUC'          , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'position', axpos.dummya, 'XTick', 3:2:11, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
axis(axlim_sens1);
text(-0.15, 1.03, 'a', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')


% plot sensitivity - aggregation time
subplot(4,2,[2 4])
for i=1:length(threshold_corr)
    plot(aggregation_time, squeeze(AUC_tuned_Tan(indx_max_Tan, :, i)), 'color', colormaps.AUC(i,:), 'linewidth', 2.5); hold on;
    text(loc_labels_b(i,1), loc_labels_b(i,2), num2str(threshold_corr(i),'%.2f'), 'ver', 'bottom', 'hor', 'left', 'Fontsize', 10, 'Fontweight', 'Bold', 'color', colormaps.AUC(i,:))
end
plot(aggregation_time(indy_max_Tan), AUC_tuned_Tan(indx_max_Tan, indy_max_Tan, indz_max_Tan), 'ok','MarkerEdgeColor', colors(11,:),'MarkerFaceColor', colors(11,:), 'markersize',7); hold on;
annotation('textarrow', [0.87 0.9], [0.905 0.890],'String',' Best model', 'Fontsize', 11, 'Fontweight', 'Bold', 'color', colors(11,:))
xlabel('Aggregation time (h)', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
ylabel('AUC'                 , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'position', axpos.dummyb, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
axis(axlim_sens2);
text(-0.15, 1.03, 'b', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')


% prepare data for boxplots
boxplotdata_Tan                            = [LOGR_OT_best_Tan.predictor LOGR_OT_best_Tan.predictor];
boxplotdata_Tan( LOGR_OT_best_Tan.extr, 1) = NaN;                                  % non-extremes in column 1
boxplotdata_Tan(~LOGR_OT_best_Tan.extr, 2) = NaN;                                  % extremes in column 2


% plot box plots
subplot(4,2,5)
axpos.boxplot    = get(gca,'position');                                            % remove ticklabels so that originals appear
axpos.boxplot(2) = axpos.boxplot(2) +  figshift_boxplot;
axpos.boxplot(4) = axpos.boxplot(4) .* figscale_boxplot;
boxplot(boxplotdata_Tan, 'PlotStyle', 'compact', 'colors', [colors(24,:); colors(22,:)], 'symbol','k.','positions', boxplot_y, 'orientation', 'horizontal'); hold on; % plot boxplots
set(gca,'ytickmode','auto','yticklabelmode','auto');                               % remove ticklabels so that originals appear
h = findobj(gca,'tag','Outliers'); set(h,'Visible','off');                         % remove outliers
axis(axlim_logreg);
set(gca, 'position', axpos.boxplot, 'Fontsize', 12, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
axis off


% plot logistic regression curve
subplot(4,2,7)
axpos.logreg    = get(gca,'position');                                                                                         % remove ticklabels so that originals appear
axpos.logreg(4) = axpos.logreg(4) .* figscale_logreg;
xvals = axlim_logreg(1):1:axlim_logreg(2);
[yvals, dyvals_lo, dyvals_hi] = glmval(LOGR_OT_best_Tan.b_all, xvals', 'logit', LOGR_OT_best_Tan.b_all_stats);                 % get uncertainty range
fill([xvals, fliplr(xvals)], [yvals' - dyvals_lo', fliplr(yvals' + dyvals_hi')], [0.8 0.8 0.8], 'EdgeColor', 'none'); hold on; % plot filled area
plot(xvals, yvals, 'linewidth', 1.5, 'color', axcolor); hold on;                                                               % plot regression line
axis(axlim_logreg);
set(gca, 'position', axpos.logreg, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
xlabel('Afternoon land OTp', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Probability'      , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
text(axlim_logreg(2),1,'Best model','ver','bottom','hor','right','Fontsize', 11, 'Fontweight', 'Bold', 'color', colors(11,:))
text(-0.15, 1.15, 'c', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')


% plot ROC curve - OT
subplot(4,2,[6 8])
zz(1,1) = plot(LOGR_OT_best_Tan.F    , LOGR_OT_best_Tan.H    ,       'color', colors(16,:), 'linewidth', 2); hold on; % actual forecast
zz(2,1) = plot(LOGR_OT_best_Tan.F_opt, LOGR_OT_best_Tan.H_opt, 'ok','MarkerEdgeColor', axcolor,'MarkerFaceColor', axcolor, 'markersize',7); hold on;
plot([0 1],[0 1], 'linewidth', 1.5, 'color', axcolor); hold off;
xlabel('False Alarm Rate', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Hit Rate'        , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'position', axpos.dummyd, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
legend(zz,['AUC = ' num2str(LOGR_OT_best_Tan.AUC,'%.2f')], ...
    ['\theta = ' num2str(LOGR_OT_best_Tan.T_opt,'%.4f') 10 'H = ' num2str(LOGR_OT_best_Tan.H_opt,'%.2f') 10 'F = ' num2str(LOGR_OT_best_Tan.F_opt,'%.2f') 10 'OR = ' num2str(LOGR_OT_best_Tan.OR_opt,'%.0f')],4);
set(legend,'YColor','w','XColor','w', 'Fontweight', 'Bold', 'Fontsize', 11, 'TextColor', axcolor);
grid on;
text(-0.15, 1.03, 'd', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')
text(0.99,1,'Best model','ver','bottom','hor','right','Fontsize', 11, 'Fontweight', 'Bold', 'color', colors(11,:))


% save figure
export_fig figures/supp_figure_05 -transparent;
% export_fig text/figures_paper/supp_figure_05 -transparent -pdf;

    

end



% --------------------------------------------------------------------
% 3D sensitivity
% --------------------------------------------------------------------



if flags.plot_3Dsens == 1


% create image
figure('OuterPosition',[10 100 1500 400]);
set(gcf, 'color', 'w');
set(gca,'color','w');


% generate 3D scatter plot of tuning results
subplot(1,3,1,'position', [0.05 0.01 0.2 0.3])
scatter3(lead_time_mesh(:), aggregation_time_mesh(:), threshold_corr_mesh(:), [], AUC_tuned(:), 'filled')
% scatter3(lead_time_mesh(:), aggregation_time_mesh(:), threshold_corr_mesh(:), [], rho_tuned(:), 'filled')
hcb        = colorbar('location', 'SouthOutside', 'Fontsize', 14, 'Fontweight', 'Bold', 'TickLength', [0 0]); hold on;     
gca_pos    = get(gca,'position');
hcb_pos    = get(hcb,'Position');
gca_pos(2) = 0.25;
gca_pos(4) = 0.70;
hcb_pos(2) = 0.07;
hcb_pos(4) = 0.03;
set(hcb,'Position', hcb_pos)
set(gca,'position', gca_pos)
caxis(caxes.tune)
colormap(colormaps.tune);
axis([3 13 1 15 0.08 0.32]) 
view(-135, 10)
xlabel('Lead time'       , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('aggregation time', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
zlabel('r_c_r_i_t'       , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
set(gca, 'Fontsize', 12, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor, 'Zcolor', axcolor);
text(-0.2, 0.95, 'a', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')
box on


% set logreg plots axes limits
axlim_logreg = [0 10000 0 0.03];

% prepare data fro boxplots
boxplotdata                        = [LOGR_OT_best.predictor LOGR_OT_best.predictor];
boxplotdata( LOGR_OT_best.extr, 1) = NaN; % non-extremes in column 1
boxplotdata(~LOGR_OT_best.extr, 2) = NaN; % extremes in column 2
boxplot_y                          = [0.003 0.028];


% plot logistic regression curve
subplot(1,3,2,'position', [0.32 0.15 0.29 0.75])
plot(LOGR_OT_best.predictor(~LOGR_OT_best.extr), axlim_logreg(1) + 0.0005, 'v', 'MarkerEdgeColor', colors(24,:),'MarkerFaceColor', colors(24,:), 'markersize', 5); hold on;
plot(LOGR_OT_best.predictor( LOGR_OT_best.extr), axlim_logreg(4) - 0.0005, '^', 'MarkerEdgeColor', colors(22,:),'MarkerFaceColor', colors(22,:), 'markersize', 5); hold on;
xvals = axlim_logreg(1):1:axlim_logreg(2);
[yvals, dyvals_lo, dyvals_hi] = glmval(LOGR_OT_best.b_all, xvals', 'logit', LOGR_OT_best.b_all_stats); % get uncertainty range
fill([xvals, fliplr(xvals)], [yvals' - dyvals_lo', fliplr(yvals' + dyvals_hi')], [0.8 0.8 0.8], 'EdgeColor', 'none'); hold on; % plot filled area
plot(xvals, yvals, 'linewidth', 1.5, 'color', axcolor); hold on;                                                               % plot regression line
boxplot(boxplotdata, 'PlotStyle', 'compact', 'colors', [colors(24,:); colors(22,:)], 'symbol','k.','positions', boxplot_y, 'orientation', 'horizontal'); hold on; % plot boxplots
set(gca,'ytickmode','auto','yticklabelmode','auto');                               % remove ticklabels so that originals appear
h = findobj(gca,'tag','Outliers'); set(h,'Visible','off');                         % remove outliers
axis(axlim_logreg);
xlabel('Afternoon land OT', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Probability'      , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
text(-0.2, 1.02, 'b', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')


% plot ROC curve - OT
subplot(1,3,3,'position', [0.68 0.15 0.28 0.75])
z(1,1) = plot(LOGR_OT_best.X     , LOGR_OT_best.Y     ,       'color', colors(16,:), 'linewidth', 2); hold on; % actual forecast
z(2,1) = plot(LOGR_OT_best.X(LOGR_OT_best.ind_opt), LOGR_OT_best.Y(LOGR_OT_best.ind_opt), 'ok','MarkerEdgeColor', axcolor,'MarkerFaceColor', axcolor, 'markersize',7); hold on;
plot([0 1],[0 1], 'linewidth', 1.5, 'color', axcolor); hold off;
xlabel('False Alarm Rate', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor); 
ylabel('Hit Rate'        , 'Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor);
set(gca, 'Fontsize', 12, 'Fontweight', 'Bold','Xcolor', axcolor,'Ycolor', axcolor);
legend(z,['AUC = ' num2str(LOGR_OT_best.AUC,'%.2f')], ...
    ['\theta = ' num2str(LOGR_OT_best.T(LOGR_OT_best.ind_opt),'%.4f') 10 'H = ' num2str(LOGR_OT_best.Y(LOGR_OT_best.ind_opt),'%.2f') 10 'F = ' num2str(LOGR_OT_best.X(LOGR_OT_best.ind_opt),'%.2f') 10 'OR = ' num2str(LOGR_OT_best.OR_opt,'%.0f')],4);
set(legend,'YColor','w','XColor','w', 'Fontweight', 'Bold', 'Fontsize', 11, 'TextColor', axcolor);
grid on;
text(-0.15, 1.03, 'c', 'ver', 'bottom', 'hor', 'left', 'Fontsize', 15, 'Fontweight', 'Bold', 'color', axcolor, 'units', 'normalized')
text(0.99,1,'OT','ver','bottom','hor','right','Fontsize', 12, 'Fontweight', 'Bold', 'color', axcolor)
    

% save figure
export_fig figures/figure_03_1by3 -transparent;
    

end


% --------------------------------------------------------------------
% time series
% --------------------------------------------------------------------



if flags.plot_time == 1


% yearticks
ticks      = NaN (date_vec_OT(end,1)-date_vec_OT(1,1)+2, 1);
ticklabels = cell(date_vec_OT(end,1)-date_vec_OT(1,1)+2, 1);
k          = 1;
for i=date_vec_OT(1,1):date_vec_OT(end,1)
  for j=1:12
    ticks(k)      = date_num_OT(find(date_vec_OT(:,1)==i & date_vec_OT(:,2)==j,1,'first')); 
    ticklabels(k) = {strcat('1-',num2str(j),'-',num2str(i))};
    k             = k + 1;
  end
end
ticks(k)      = date_num_OT(ndays);
ticklabels(k) = {strcat('1-1-',num2str(date_vec_OT(end,1) + 1))};


% set x-axs limits
xlims = [datenum([2006 8 1]) datenum([2007 3 1])];


% % get indices of events you want to plot
% ind.hits            = find( LOGR_OT_best.warnings_opt &  LOGR_OT_best.extr & date_num_OT > xlims(1) & date_num_OT < xlims(2));
% ind.false_alarms    = find( LOGR_OT_best.warnings_opt & ~LOGR_OT_best.extr & date_num_OT > xlims(1) & date_num_OT < xlims(2));
% ind.miss            = find(~LOGR_OT_best.warnings_opt &  LOGR_OT_best.extr & date_num_OT > xlims(1) & date_num_OT < xlims(2));
% ind.accidents_shift = find(~isnan(accidents_shift(:,4))                & date_num_OT > xlims(1) & date_num_OT < xlims(2));


% set bar width
barwidth = 0.4;


% plot data
figure('OuterPosition',[10 200 1350 410]);
set(gcf, 'color', 'w');
plot(xlims, [threshold_OT threshold_OT], '--', 'color', [0.9 0.9 0.9]); hold on;
bar(date_num_OT, OT_n_lp_shift, barwidth, 'EdgeColor', 'none','facecolor',colors(17,:)); hold on;
e(1) = plot(date_num_OT(ind.false_alarms   ), ones(size(ind.false_alarms)   ) .* 3700, 'v', 'markersize', 6, 'markeredgecolor', 'y', 'markerfacecolor', 'y'); hold on;
e(2) = plot(date_num_OT(ind.hits           ), ones(size(ind.hits)           ) .* 3700, 'v', 'markersize', 6, 'markeredgecolor', colors(16,:), 'markerfacecolor', colors(16,:)); hold on;
e(3) = plot(date_num_OT(ind.miss           ), ones(size(ind.miss)           ) .* 3700, 'v', 'markersize', 6, 'markeredgecolor', colors(8,:), 'markerfacecolor', colors(8,:)); hold on;
e(4) = plot(date_num_OT(ind.accidents_shift), ones(size(ind.accidents_shift)) .* 3500, '^', 'markersize', 6, 'markeredgecolor', 'k', 'markerfacecolor', 'k'); hold off;
set(e,'clipping','off')
axis([xlims(1) xlims(2) 0 3600]);
ylabel('nighttime OT pixels', 'Fontsize', 13, 'Fontweight', 'Bold'); 
set(gca,'XTick',ticks,'XTicklabel',ticklabels)
% mf_xticklabel_rotate(ticks,5,ticklabels,'interpreter','none','Fontsize', 11, 'Fontweight', 'Bold'); %#ok<NBRAK>
set(gca,'Xcolor', axcolor,'Ycolor', axcolor, 'Fontsize', 12, 'Fontweight', 'Bold')
legend(e, 'False alarm', 'Storm hit', 'Storm miss', 'Reported incident', 2);
set(legend, 'Box', 'off', 'color', 'none', 'Fontweight', 'Bold', 'Fontsize', 10,'textcolor', axcolor);


% save figure
export_fig figures/time_series -transparent;
export_fig figures/time_series -transparent -pdf;


    

end



% --------------------------------------------------------------------
% plot movie
% --------------------------------------------------------------------


if flags.plot_movie == 1

    
% load data    
[lat_mod, lon_mod, TOT_PREC_FLa_hs] = mf_load('1996-2008_FLake_out03_yhourmean_TOT_PREC.nc', 'TOT_PREC', nc);


for i=1:24
    
    
%     % create figure
%     figure('OuterPosition',[100   238   576.*1.8   512]);
%     set(gcf, 'color', 'w');
%     set(gca,'color','w');
%     
%     % plot hourly mean
%     subplot(1,2,1)
%     mf_plot_ea(lon_reg, lat_reg, OT_yhoursum(:,:,i), [], caxes.OThs, colormaps.OThs, res_reg, 1, 2, 'Observations', [num2str(i-1) ' - ' num2str(i) ' UTC'], 'OT pixel counts'); hold on;
% 
% 
%     % plot hourly mean
%     subplot(1,2,2)
%     mf_plot_ea(lon_mod, lat_mod, TOT_PREC_FLa_hs(:,:,i), [], caxes.PRhs, colormaps.PRhs, res_reg, 1, 2, 'Climate model', [num2str(i-1) ' - ' num2str(i) ' UTC'], 'Precipitation [mm h^-^1]'); hold on;
%     
%     % save figure
%     export_fig(sprintf('figures/movie/comparison_%s.png', alphabet(i)));



    % plot hourly mean
    mf_plot_agl(lon_mod, lat_mod, TOT_PREC_FLa_hs(:,:,i), [], caxes.PRhs, colormaps.PRhs, res_reg, 0, 2, 'Climate model', [num2str(i-1) ' - ' num2str(i) ' UTC'], 'Precipitation [mm h^-^1]'); hold on;
    
    % save figure
    export_fig(sprintf('figures/movie/TOT_PREC_%s.png', alphabet(i)));


end


end



% --------------------------------------------------------------------
% boating accident data figure
% --------------------------------------------------------------------



if flags.plot_boats == 1


% set axes limits
xlims = [0 100.5];
ylims = [0 2680];


% set bar width
barwidth = 0.8;


% define scale factor for plotting probabilities
scale = 30000;


% plot data
figure('OuterPosition',[400 200 600 410]);
set(gcf, 'color', 'w');
h = plot(xlims, [threshold_OT threshold_OT], '--', 'color', [0.6 0.6 0.6]); hold on;
b = bar(1:nbins, binmedian_OT_n_lp_shift, barwidth, 'EdgeColor', 'none','facecolor', colors(17,:)); hold on;
for i=1:length(accidents_whichbin_unique)
    e = plot(accidents_whichbin_unique(i), repmat(binmedian_OT_n_lp_shift(accidents_whichbin_unique(i)), [accidents_whichbin_counts(i) 1]) + [90:90:90*accidents_whichbin_counts(i)]', 'v', 'markersize', 6, 'markeredgecolor', 'k', 'markerfacecolor', 'k'); hold on; %#ok<SAGROW>
end
set(e,'clipping','off')
mf_plotuncertainty(1:nbins, binmedian_p_LOYOCV .* scale, (binQ75_p_LOYOCV-binmedian_p_LOYOCV) .* scale, (binmedian_p_LOYOCV-binQ25_p_LOYOCV) .* scale, colors(4,:), colors(13,:), '-', 1, 1.5)
axis([xlims(1) xlims(2) ylims(1) ylims(2)]);
ylabel('nighttime OT pixels', 'Fontsize', 12, 'Fontweight', 'Bold', 'color', colors(17,:)); 
xlabel('nighttime OT bin', 'Fontsize', 12, 'Fontweight', 'Bold'); 
set(gca,'Xcolor', axcolor,'Ycolor', axcolor, 'Fontsize', 12, 'Fontweight', 'Bold')
legend(e(1), 'Reported incident', 2);
set(legend, 'Box', 'off', 'color', 'none', 'Fontweight', 'Bold', 'Fontsize', 10,'textcolor', axcolor);
text(109,1300,{'predicted extreme probability'},'ver','bottom','hor','center', 'Fontweight', 'Bold', 'Fontsize', 12, 'color', colors(4,:), 'rotation',-90); hold on;

% Create second Y axes on the right (https://nl.mathworks.com/matlabcentral/answers/98907-how-can-i-add-a-second-y-axis-with-a-different-scale-in-a-plot-in-matlab-7-9-r2009b)
hpos = get(gca, 'position');
a2   = axes('YAxisLocation', 'Right');
set(a2, 'color', 'none', 'XTick', [], 'position', hpos, 'YLim', ylims ./ scale)
set(a2, 'Xcolor', axcolor,'Ycolor', axcolor, 'Fontsize', 12, 'Fontweight', 'Bold')

% save figure
export_fig figures/boating_accidents -m8 -transparent;

    
    
end



