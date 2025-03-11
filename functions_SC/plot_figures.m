%%  Set plotting
function [] = plot_figures(XL,XH,YL,YH)
set(gca,'XLim',[XL,XH]);
set(gca,'YLim',[YL,YH]);
set(gca,'FontSize',13);
set(gcf,'Units','centimeters','Position',[10 10 12 7]);
box on
end
