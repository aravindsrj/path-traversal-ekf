function [cNew, rNew] = reportOutput(c, r, rowWidth, robotStart, optType)

if optType == 1
    file = fopen('reportOutput.txt', 'w');
else
    file = fopen('reportGroundTruth.txt', 'w');
end
fieldStartX = robotStart(1)-rowWidth/2;
numberOfTrees = size(c, 1);

rowData = zeros(numberOfTrees, 1);

for i = 1:numberOfTrees
    cx = c(i, 1) - fieldStartX;
    row = round(cx / rowWidth) + 1;
    rowData(i) = row;
end

[rowDataSorted, circleIndex] = sort(rowData);

cNew = c(circleIndex, :);
rNew = r(circleIndex);

for i = 1:numberOfTrees-1
    for j = i+1:numberOfTrees
        if rowDataSorted(i) == rowDataSorted(j)
            if cNew(i, 2) > cNew(j, 2)
                placeholder = cNew(i, :);
                cNew(i, :) = cNew(j, :);
                cNew(j, :) = placeholder;
            else
                continue
            end
        else
            break
        end
    end
end

formatspec = 'Number of Rows: %d\n';
fprintf(file, formatspec, max(rowDataSorted));

rowNumberPrinted = 0;
treeNumber = 1;

for i = 1:numberOfTrees
    if rowNumberPrinted ~= rowDataSorted(i)
        newRow = true;
        rowNumberPrinted = rowDataSorted(i);
        A1 = rowNumberPrinted;
        formatspec1 = '\n-> %d\n';
        if rowNumberPrinted == 1
            formatspec1 = '-> %d\n';
        end
        fprintf(file, formatspec1, A1);
    end

    if newRow == true
        treeNumber = 1;
    end

    A2 = [treeNumber, cNew(i, 1), cNew(i, 2), rNew(i, 1)*2];
    formatspec2 = '%d, Center: (%.4f, %.4f) m, Diameter: %.4f m\n';

    if treeNumber < 10
        formatspec2 = '0%d, Center: (%.4f, %.4f) m, Diameter: %.4f m\n';
    end

    fprintf(file, formatspec2, A2);
    newRow = false;
    treeNumber = treeNumber + 1;
end
fclose(file);
end