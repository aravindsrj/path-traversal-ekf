file = 'reportOutput.txt';
global bitmap2;

Row = 5000; Col = 5000; %numbers of rows and columns of bitmap
bitmap2 = zeros(Row, Col); %initialize as empty
[c, r, numberOfRows] = readReportOutput(file);

% These values can be changed
Xmax = 50;
Ymax = 50;

[I, J] = XYtoIJ(c(:,1), c(:,2), Xmax, Ymax, Row, Col);
r2 = r./(Xmax/Col);
draw_disc2(I, J, r2);

imagesc([0 Xmax],[0 Ymax], bitmap2)
set(gca,'YDir','normal');
axis square
title('Bitmap from File')
