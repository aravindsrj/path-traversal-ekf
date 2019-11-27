function [c, r] = circleModification(c, r, intersect, rowWidth)

removeCircleList = 0;

for i = 1:size(intersect, 1)
    for j = 1:size(intersect, 1)
        if intersect(i, j) == 1
            % do something

            cx1 = c(i, 1);
            cx2 = c(j, 1);
            centerSeparation1 = abs(round(cx1 / rowWidth) + (cx1 / rowWidth));
            centerSeparation2 = abs(round(cx2 / rowWidth) + (cx2 / rowWidth));

            if centerSeparation1 < centerSeparation2
                removeCircleList = [removeCircleList, j]; % remove second center
            elseif centerSeparation1 > centerSeparation2
                removeCircleList = [removeCircleList, i]; % remove first center
            elseif centerSeparation1 == centerSeparation2
                removeCircleList = [removeCircleList, j]; % remove second center
            end
        end
    end
end
c(removeCircleList(2:end), :) = [];
r(removeCircleList(2:end), :) = [];

end