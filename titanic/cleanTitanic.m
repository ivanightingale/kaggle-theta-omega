function tbl = cleanTitanic(tbl)

    tbl.Fare(tbl.Fare == 0) = NaN;  % treat 0 fare as NaN

    tbl.Sex = double(tbl.Sex);
    
    % replace NaN age with mean
    tbl.Age(isnan(tbl.Age)) = nanmean(tbl.Age);
    % categorize age groups
    tbl.AgeGroup = discretize(tbl.Age, [0:10:20, 65, 80], 'categorical', {'child','teen','adult','senior'});

    % replace undefined with mode
    tbl.Embarked(isundefined(tbl.Embarked)) = mode(tbl.Embarked);
    tbl.Embarked = double(tbl.Embarked);

    fare = grpstats(tbl(:,{'Pclass','Fare','Embarked'}),{'Pclass','Embarked'}, 'nanmean');
    for i = 1 : height(fare)
        % replace NaN with average fare based on class and embarked to
        % missing values (only for training set)
        tbl.Fare(isnan(tbl.Fare) & tbl.Pclass == fare.Pclass(i) & tbl.Embarked == fare.Embarked(i)) = fare.nanmean_Fare(i);
    end
    tbl.FareRange = discretize(tbl.Fare, [0:10:30, 100, 520], 'categorical', {'<10','10-20','20-30','30-100','>100'});
    
    tbl.Pclass = categorical(tbl.Pclass, [3, 2, 1], 'Ordinal', true);
    tbl.Sex = categorical(tbl.Sex);
    tbl.Embarked = categorical(tbl.Embarked);
    tbl.AgeGroup = categorical(tbl.AgeGroup,{'child','teen','adult','senior'}, 'Ordinal', true);
    tbl.FareRange = categorical(tbl.FareRange, {'<10','10-20','20-30','30-100','>100'}, 'Ordinal', true);
    
    tbl(:,{'Name','Ticket','Cabin'}) = [];
end