function intersect = circleOverlap(c, r)

intersect = zeros(size(c, 1));

for i = 1:size(c, 1)-1
    for j = i+1:size(c, 1)
        x01 = c(i, 1); y01 = c(i, 2);
        x02 = c(j, 1); y02 = c(j, 2);

        x1 = x01 + r(i) * cos(0:0.01:2*pi);
        y1 = y01 + r(i) * sin(0:0.01:2*pi);

        x2 = x02 + r(j) * cos(0:0.01:2*pi);
        y2 = y02 + r(j) * sin(0:0.01:2*pi);

        [inC, onC] = inpolygon(x2, y2, x1, y1);

        if any(inC==1) || any(onC==1)
            intersect(i, j) = true;
            intersect(j, i) = true;
        end
    end
end
end