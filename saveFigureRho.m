function saveFigureRho(app,filetag,x,rho,rho_err)
    h = figure;
    h.Visible = 'off';
    y       = rho;
    y_err   = rho_err;
    errorbar(x,y,y_err,'o-');
%     lgndName1 = app.RVAxes.Legend.String{1};
%     lgd = legend(lgndName1);
%     lgd.Box = app.RVAxes.Legend.Box;
%     lgd.Location = app.RVAxes.Legend.Location;
    h.CurrentAxes.YLabel.String = app.RVAxes.YLabel.String;
    h.CurrentAxes.YLabel.FontSize = app.RVAxes.YLabel.FontSize;
    h.CurrentAxes.YLabel.FontWeight = 'Bold';
    h.CurrentAxes.XLabel.String = app.RVAxes.XLabel.String;
    h.CurrentAxes.XLabel.FontSize = app.RVAxes.XLabel.FontSize;
    h.CurrentAxes.XLabel.FontWeight = 'Bold';
    h.CurrentAxes.Title.String = app.RVAxes.Title.String;
    h.CurrentAxes.Title.FontSize = app.RVAxes.Title.FontSize;
%     h.CurrentAxes.XLim = [0 max(x)];
%     h.CurrentAxes.XLim = [0 max(y)+1];
%     saveas(h,filetag,'png')
    export_fig(h,strcat(filetag,'.png'),'-png','-native');
%     print(strcat(filetag,'.png'),'-dpng','-r300');
    savefig(h,filetag)
    delete(h)