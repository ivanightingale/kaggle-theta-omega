train = readtable('train.csv','Format','%f%f%f%q%C%f%f%f%q%f%q%C');
test = readtable('test.csv','Format','%f%f%q%C%f%f%f%q%f%q%C');

train = cleanTitanic(train);
test = cleanTitanic(test);

Y_train = train.Survived;                   % slice response variable
X_train = train(:,3 : end);                 % select predictor variables
vars = X_train.Properties.VariableNames;    % get variable names
X_train = table2array(X_train);             % convert to a numeric matrix
X_test = table2array(test(:,2 : end));      % convert to a numeric matrix
categoricalPredictors = {'Pclass', 'Sex', 'Embarked', 'AgeGroup', 'FareRange'};
rng(1);                                     % for reproducibility
c = cvpartition(Y_train,'holdout', 0.30);   % 30%-holdout cross validation

% generate a Random Forest model from the partitioned data
rf = TreeBagger(200, X_train(training(c),:), Y_train(training(c)),...
    'PredictorNames', vars, 'Method','classification',...
    'CategoricalPredictors', categoricalPredictors, 'oobvarimp', 'on');

% compute the out-of-bag accuracy
oobAccuracy = 1 - oobError(rf, 'mode', 'ensemble');

% one of the benefits of Random Forest is its feature importance metric
[~,order] = sort(rf.OOBPermutedVarDeltaError);  % sort the metrics
figure
barh(rf.OOBPermutedVarDeltaError(order))        % horizontal bar chart
title('Feature Importance Metric')
ax = gca; ax.YTickLabel = vars(order);          % variable names as labels

[Yfit, Yscore, Ycost] = predict(rf, X_train(test(c, :),:));       % use holdout data
%cfm = confusionmat(Y_train(test(c)), str2double(Yfit)); % confusion matrix
%cvAccuracy = sum(cfm(logical(eye(2))))/length(Yfit);    % compute accuracy

PassengerId = test.PassengerId;             % extract Passenger Ids
Survived = predict(rf, X_test);             % generate response variable
Survived = str2double(Survived);            % convert to double
submission = table(PassengerId, Survived);   % combine them into a table
writetable(submission,'submission.csv')     % write to a CSV file