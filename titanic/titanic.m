function prediction = titanic(train, test)
    train(:, 4) = replaceWithMean(train(:, 4));

    b = regress( train(:, 1), [ ones(size(train, 1), 1), train(:, 2 : end) ] );

    test(:, 4) = replaceWithMean(test(:, 4));
    test(:, 7) = replaceWithMean(test(:, 7));

    prediction = b(1, :) + test(:, 2 : end) * b(2 : end, :);
    prediction = [test(:, 1), round(prediction)];

%     header = {'PassengerId', 'Survived'};
%     textHeader = strjoin(header, ',');
%     fid = fopen('results.csv','w'); 
%     fprintf(fid,'%s\n',textHeader);
%     fclose(fid);
%     dlmwrite('results.csv',prediction,'-append');

end
