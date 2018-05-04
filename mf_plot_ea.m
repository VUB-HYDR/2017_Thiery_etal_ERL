

% --------------------------------------------------------------------
% function to plot domain data
% --------------------------------------------------------------------


function [hcb] = mf_plot_ea(lon, lat, var, var_sign, caxis_dom, colormap_dom, res, flag_sp, flag_cb, panel, experiment, cbcaption)


% note
% flag_cb = 0; no colorbar
%           1: standard colorbar
%           2: thin colorbar southoutside


flag_save = 0; % 0: load full coasts (full resolution shorelines as lines)
               % 1: save full coasts (coarse resolution shorelines as lines)

               

% --------------------------------------------------------------------
% initialisation
% --------------------------------------------------------------------


% Set grid characteristics - East Africa
% lat_min = -10.2; % see Bedka animations (-10.2 to avoid labels overlapping)
lat_min = -10.0; % see Bedka animations (-10.2 to avoid labels overlapping)
lat_max =   5.8;
lon_min =  25;
lon_max =  41;



% --------------------------------------------------------------------
% manipulations
% --------------------------------------------------------------------


% get land mask
if     flag_save == 0; load('mw_lm_ea');                                                                        % load land mask
elseif flag_save == 1; 
    M  = m_shaperead('ne_110m_ocean');                                                                          % load country borders
    IN = inpolygon(lon,lat,M.ncst{2}(:,1),M.ncst{2}(:,2));                                                      % get land mask
    save('mw_lm_ea','IN');                                                                                      % save land mask
end


% if no significance mask is given, assume all pixels significant
if isempty(var_sign)
    var_sign = ones(size(var));
end


% apply land mask (ocean pixels set to NaN)
var(IN)      = NaN;
var_sign(IN) = NaN;


% retain only insignificant values
var_insign                = NaN(size(var_sign));
var_insign(var_sign == 0) = 1;


% prepare for hatching out
lon_insign = lon .* var_insign;
lat_insign = lat .* var_insign;
lon_insign = lon_insign(~isnan(lon_insign));
lat_insign = lat_insign(~isnan(lat_insign));
lon_insign = [lon_insign' - res/2; lon_insign' + res/2]; % plotting these gives diagonal over the pixel
lat_insign = [lat_insign' - res/2; lat_insign' + res/2];



% --------------------------------------------------------------------
% Visualisation
% --------------------------------------------------------------------


% design figure
if flag_sp == 0
figure;                                                                                                         % no subplot
set(gcf, 'color', 'w');
set(gca,'color','w');
end


% Initialise grid and projection
m_proj('Mercator','long',[lon_min lon_max],'lat',[lat_min lat_max]);                             % generate lambert projection
m_grid('box','on','tickdir','in','color',[0, 0, 0], 'Fontweight', 'Bold','FontSize', 11, 'linewidth',1.5,'linestyle','none','xtick',[25 30 35 40],'ytick',[-10 -5 0 5 10 15]); hold on; % draw grid with normal box


% plot data
g = m_pcolor(lon - res/2,lat + res/2,var);                                                                      % with shading flat will draw a panel between the (i,j),(i+1,j),(i+1,j+1),(i,j+1) coordinates of the lon/lat matrices with a color corresponding to the data value at (i,j).
set(g, 'edgecolor', 'none');                                                                                    % remove black grid around pixels 
set(gca, 'Fontsize', 14, 'Fontweight', 'Bold');                                                                 % set axes properties
caxis(caxis_dom);                                                                                               % set colorscale axes
colormap(colormap_dom); mf_freezeColors;                                                                        % select colormap and freeze it


% plot color bar
if flag_cb == 1
    hcb = colorbar('Fontsize', 14, 'Fontweight', 'Bold'); hold on;     
    cbfreeze; mf_freezeColors;
elseif flag_cb == 2
    hcb  = colorbar('location', 'SouthOutside', 'Fontsize', 14, 'Fontweight', 'Bold', 'TickLength', [0 0]); hold on;     
    y1   = get(gca,'position');
    y    = get(hcb,'Position');
    y(4) = 0.03;
    set(hcb,'Position',y)
    set(gca,'position',y1)
    mf_freezeColors;
end
hold on;


% plot statistical significance mask
m_plot(lon_insign,lat_insign, '-', 'color', [0.5 0.5 0.5], 'linewidth', 1); hold on;                               % hatch over insignificant areas


% plot country borders 
M = m_shaperead('ne_10m_admin_0_countries');                                                                       % load country borders
for k=1:length(M.ncst) 
  m_line(M.ncst{k}(:,1),M.ncst{k}(:,2), 'color', [0.6 0.6 0.6]); hold on;                                          % plot country borders
end
hold on;
if     flag_save == 0; m_usercoast('mw_fc_ea','color','k'); hold on;                                               % load and draw coarse resolution shorelines as lines
elseif flag_save == 1; m_gshhs('lc','color','k'); hold on; m_gshhs('fc','save','mw_fc_ea');                        % draw and save coarse resolution shorelines as lines
end


% add text
m_text(lon_min+0.02, lat_max-0.01, panel,'ver','bottom','hor','left', 'Fontweight', 'Bold', 'Fontsize', 14); hold on;
m_text(lon_max-0.02, lat_max-0.01, experiment,'ver','bottom','hor','right', 'Fontweight', 'Bold', 'Fontsize', 13); hold on;
if flag_cb == 1
    m_text(240,0,cbcaption,'ver','bottom','hor','center', 'Fontweight', 'Bold', 'Fontsize', 12,'rotation',-90); hold off;
elseif flag_cb == 2
    m_text((lon_min+lon_max)/2,lat_min-5.5,cbcaption,'ver','bottom','hor','center', 'Fontweight', 'Bold', 'Fontsize', 12); hold off;
end


end
