train = readtable('train.csv','Format','%f%f%f%q%C%f%f%f%q%f%q%C');
test = readtable('test.csv','Format','%f%f%q%C%f%f%f%q%f%q%C');

train = cleanTitanic(train);
test = cleanTitanic(test);

[bf, bfScore] = trainTitanicClassifier(train);
disp(bfScore)
% one of the benefits of Random Forest is its feature importance metric

PassengerId = test.PassengerId;             % extract Passenger Ids
Survived = bf.predictFcn(test);             % generate response variable
submission = table(PassengerId, Survived);   % combine them into a table
writetable(submission,'submission.csv')     % write to a CSV file