function h = plot_circle(x,y,r,c)
for i = 1:length(r)
    th = 0:pi/50:2*pi;
    xunit = r(i) * cos(th) + x(i);
    yunit = r(i) * sin(th) + y(i);
    h = plot(xunit, yunit,c)%'DisplayName',plotType);
    hold on

end