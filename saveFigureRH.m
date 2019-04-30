function saveFigureRH(app,filetag,x,RH,RH_err)
    h = figure;
    h.Visible = 'off';
    y       = RH;
    y_err   = RH_err;
    errorbar(x,y,y_err,'o-');
%     lgndName1 = app.RVAxes.Legend.String{1};
%     lgd = legend(lgndName1);
%     lgd.Box = app.RVAxes.Legend.Box;
%     lgd.Location = app.RVAxes.Legend.Location;
    h.CurrentAxes.YLabel.String = app.RHTAxes.YLabel.String;
    h.CurrentAxes.YLabel.FontSize = app.RHTAxes.YLabel.FontSize;
    h.CurrentAxes.YLabel.FontWeight = 'Bold';
    h.CurrentAxes.XLabel.String = app.RHTAxes.XLabel.String;
    h.CurrentAxes.XLabel.FontSize = app.RHTAxes.XLabel.FontSize;
    h.CurrentAxes.XLabel.FontWeight = 'Bold';
    h.CurrentAxes.Title.String = app.RHTAxes.Title.String;
    h.CurrentAxes.Title.FontSize = app.RHTAxes.Title.FontSize;
    h.CurrentAxes.YLim = [0 100];
%     saveas(h,filetag,'png')
    export_fig(h,strcat(filetag,'-RH.png'),'-png','-native');
%     print(strcat(filetag,'.png'),'-dpng','-r300');
    savefig(h,strcat(filetag,'-RH'));
    delete(h)