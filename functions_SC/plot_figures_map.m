%%  Set plotting
function [] = plot_figures_PWD(XL,XH)
set(gca,'CLim',[XL  XH]);
setm(gca, 'MLabelParallel', 'south', 'MLabelLocation', [-180 -90 0 90 180], 'MLabelRound', -1, 'PLabelLocation', [-90 0 90], 'PLabelRound', -1);
% Manually add custom labels
xticks([-150/180*pi, 0, 150/180*pi]);
xticklabels({'-180°', '0°',  '180°'});
yticks([-38/90*pi, 0, 38/90*pi]);
yticklabels({'90°', '0°',  '-90°'});

xlabel('$\phi\,$','Interp','Latex');  
ylabel('$\theta\,$','Interp','Latex'); 
colorbar
set(gca,'FontSize',13);
set(gcf,'Units','centimeters','Position',[10 10 20 7]);
n = 256; % Number of colors in the colormap
customColormap = [linspace(0, 1, n)' linspace(0, 1, n)' linspace(0, 1, n)']; % Black to white
customColormap = [customColormap; [linspace(1, 0.8, n)', linspace(1, 0, n)', linspace(1, 0, n)']]; % White to dark red
colormap(customColormap);%
end
