function [synthetic_table, perceived_table, error_table, cTrue, rTrue] = errorAnalysis(c, r, cTrue, rTrue)

if size(c, 1) ~= size(cTrue, 1)
    removeElements1 = [];
    elementsMissing = 0;
    epsilonEnv = 0.8;
    for i = 1:size(c)
        for j = i+elementsMissing:size(cTrue)
            if abs(c(i, 2) - cTrue(j, 2)) < epsilonEnv
                break
            else
                %i, j
                %j-elementsMissing
                removeElements1 = [removeElements1, j];
                elementsMissing = elementsMissing + 1;
                continue
            end
        end
    end
    cTrue(removeElements1, :) = [];
    rTrue(removeElements1, :) = [];
end

if size(c, 1) ~= size(cTrue, 1)
    removeElements2 = size(c, 1)+1:size(cTrue, 1);
    cTrue(removeElements2, :) = [];
    rTrue(removeElements2, :) = [];
end
size(cTrue)

diaTrue = 2 .* rTrue;
dia = 2 .* r;

synthetic_environment = [cTrue(:, 1), cTrue(:, 2), diaTrue];
perceived_environment = [c(:, 1), c(:, 2), dia];
error_environment = synthetic_environment - perceived_environment;
error_environmentAbs = abs(synthetic_environment - perceived_environment);

% descriptive statistics of synthetic environment
% min, max, mean, median, mode, standard deviation, variance
    
synthetic_environment_min = min(synthetic_environment,[],1); % min(A,[],2) - 1 for Column and 2 for Row
synthetic_environment_max = max(synthetic_environment,[],1);
synthetic_environment_mean = mean(synthetic_environment); % mean(A,2) - 2 for row
synthetic_environment_median = median(synthetic_environment);
synthetic_environment_mode = mode(synthetic_environment);
synthetic_environment_sd = std(synthetic_environment);
synthetic_environment_var = var(synthetic_environment);

% descriptive statistics of perceived environment
% min, max, mean, median, mode, standard deviation, variance
perceived_environment_min = min(perceived_environment,[],1); % min(A,[],2) - 1 for Column and 2 for Row
perceived_environment_max = max(perceived_environment,[],1);
perceived_environment_mean = mean(perceived_environment); % mean(A,2) - 2 for row
perceived_environment_median = median(perceived_environment);
perceived_environment_mode = mode(perceived_environment);
perceived_environment_sd = std(perceived_environment);
perceived_environment_var = var(perceived_environment);

% descriptive statistics of error between synthetic and perceived environment
% min, max, mean, median, mode, standard deviation, variance
error_environment_min = min(error_environmentAbs,[],1); % min(A,[],2) - 1 for Column and 2 for Row
error_environment_max = max(error_environmentAbs,[],1);
error_environment_mean = mean(error_environmentAbs); % mean(A,2) - 2 for row
error_environment_median = median(error_environmentAbs);
error_environment_mode = mode(error_environmentAbs);
error_environment_sd = std(error_environment);
error_environment_var = var(error_environment);

% plot histogram of error
figure('Name','X Co-ordinate Error Histogram')
histogram(error_environment(:, 1));
    
figure('Name','Y Co-ordinate Error Histogram')
histogram(error_environment(:, 2));
    
figure('Name','Diameter Error Histogram')
histogram(error_environment(:, 3));

setd = [synthetic_environment_min; synthetic_environment_max; synthetic_environment_mean;...
                synthetic_environment_median; synthetic_environment_mode; synthetic_environment_sd; synthetic_environment_var];

petd = [perceived_environment_min; perceived_environment_max; perceived_environment_mean;...
                perceived_environment_median; perceived_environment_mode; perceived_environment_sd; perceived_environment_var];

eetd = [error_environment_min; error_environment_max; error_environment_mean;...
                error_environment_median; error_environment_mode; error_environment_sd; error_environment_var];

% synthetic_table = table([setd(:,1)], [setd(:,2)], [setd(:,3)],...
%                                 'VariableNames', {'X_Coordinate','Y_Coordinate','Diameter'},...
%                                 'RowNames',{'Min';'Max';'Mean';'Median';'Mode';'Standard Deviation';'Variance'});
synthetic_table = table([setd(:,3)],...
                                'VariableNames', {'Diameter'},...
                                'RowNames',{'Min';'Max';'Mean';'Median';'Mode';'Standard Deviation';'Variance'});

perceived_table = table([petd(:,3)],...
                                'VariableNames', {'Diameter'},...
                                'RowNames',{'Min';'Max';'Mean';'Median';'Mode';'Standard Deviation';'Variance'});

error_table = table([eetd(:,1)],[eetd(:,2)],[eetd(:,3)],...
                        'VariableNames', {'X_Coordinate','Y_Coordinate','Diameter'},...
                        'RowNames',{'Min';'Max';'Mean';'Median';'Mode';'Standard Deviation';'Variance'});

disp('Ground Truth')                    
disp(synthetic_table)
disp('Estimated Values')
disp(perceived_table)
disp('Error Table')
disp(error_table)
end