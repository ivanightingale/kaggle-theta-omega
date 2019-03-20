function entries = replaceWithMean(entries)

    meanAge = nanmean(entries);
    for i = 1 : size(entries, 1)
        if isnan(entries(i ,1))
            entries(i ,1) = meanAge;
        end
    end
end

