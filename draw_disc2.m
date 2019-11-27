function draw_disc2(x, y, radii)
global bitmap2;

for i = 1:length(x)
    xc = x(i);
    yc = y(i);
    radius = radii(i);
    for ii = round(xc-(radius)):round(xc+(radius))
        for jj = round(yc-(radius)):round(yc+(radius))
            tempR = sqrt((double(ii) - double(xc)).^2 + (double(jj) - double(yc)).^2);
            if(tempR <= double(int16(radius)))
                bitmap2(ii,jj)=1;
            end
        end
    end
end

end

