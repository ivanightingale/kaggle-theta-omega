function tbl = cleanTitanic(tbl)

    tbl.Fare(tbl.Fare == 0) = NaN;      % treat 0 fare as NaN

    tbl.Sex = double(tbl.Sex);

    tbl.Age(isnan(tbl.Age)) = nanmean(tbl.Age);  % replace NaN with the average
    % categorize age groups
    tbl.AgeGroup = double(discretize(tbl.Age, [0:10:20, 65, 80], 'categorical',{'child','teen','adult','senior'}));

    tbl.Embarked(isundefined(tbl.Embarked)) = mode(tbl.Embarked);
    tbl.Embarked = double(tbl.Embarked);

    fare = grpstats(tbl(:,{'Pclass','Fare','Embarked'}),{'Pclass','Embarked'});
    for i = 1 : height(fare)
        % apply the average fare based on class and embarked to missing values
        tbl.Fare(tbl.Pclass == fare.Pclass(i) & tbl.Embarked == fare.Embarked(i) & isnan(tbl.Fare)) = fare.mean_Fare(i);
    end
    tbl.FareRange = double(discretize(tbl.Fare, [0:10:30, 100, 520], 'categorical',{'<10','10-20','20-30','30-100','>100'}));

    % split strings by white space
    tbl_cabins = cellfun(@strsplit, tbl.Cabin, 'UniformOutput', false);
    % count the number of tokens
    tbl.nCabins = cellfun(@length, tbl_cabins);
    % deal with exceptions - only the first class people had multiple cabins
    tbl.nCabins(tbl.Pclass ~= 1 & tbl.nCabins > 1,:) = 1;
    % if Cabin is empty, then nCabins should be 0
    tbl.nCabins(cellfun(@isempty, tbl.Cabin)) = 0;
    
    tbl(:,{'Name','Ticket','Cabin'}) = [];
end