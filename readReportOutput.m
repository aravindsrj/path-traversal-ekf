function [c, r, numberOfRows] = readReportOutput(file)
%Description
%
% Syntax: [c, r] = readReportOutput(file)
%
% Long description
%fileName = [file, '.txt'];

fileID = fopen(file, 'r');

formatSpec = 'Number of Rows: %d';
formatSpec1 = '%s %s (%f32, %f32) %s %s %f32 %c';

content = textscan(fileID, formatSpec);
content1 = textscan(fileID, formatSpec1, 'CommentStyle', '-> ');

c = [content1{1, 3}, content1{1, 4}];
r = content1{1, 7};
numberOfRows = content{1};

fclose(fileID);
end