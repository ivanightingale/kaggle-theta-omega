clear all;

train = readtable('train.csv','Format','%f%f%f%q%C%f%f%f%q%f%q%C');
test = readtable('test.csv','Format','%f%f%q%C%f%f%f%q%f%q%C');

train = cleanTitanic(train);
train.Survived = categorical(train.Survived);
test = cleanTitanic(test);

[gaussian, gaussianScore] = trainTitanicSVM(train);
disp(gaussianScore)

Survived = gaussian.predictFcn(test);
PassengerId = test.PassengerId;
submission = table(PassengerId, Survived);
writetable(submission,'submission.csv');