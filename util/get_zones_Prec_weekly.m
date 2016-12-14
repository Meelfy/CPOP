function zones_Prec = get_zones_Prec_weekly(time_start, time_end)
% This function returns the raw data for the precipitation without null values
% The data have been averaged according to the clustering regions
% Data are given in terms of months with a time span of 19811101-20140228
% a total of 12478 days 
    if nargin == 0
        time_start = 1;
        time_end   = 1688;
    end
    Prec_zones_9_manually = dlmread('data/Prec_zones_9_manually.dat');
    Prec = dlmread('data/weekly_Prec_19811101-19891231_19900103-20140226.dat');

    % Apply for memory
    for k = time_start:time_end
        grid_Prec{k} = zeros(72,128);
    end

    % Read precipitation data
    for k = time_start:time_end
        temp = Prec(k,:);
        mask = dlmread('data/daily_Prec_19800101-20140228_mask.dat');
        j = 1;
        for i = 1:size(mask,2)
            if mask(i) == 0
                mask(i) = nan;
            else
                mask(i) = temp(j);
                j = j + 1;
            end
        end
        grid_Prec{k} = reshape(mask,72,128);
    end 

    % Use the average of all pixels in the area to replace the rainfall in the area
    for j = time_start:time_end
        for i = 1:9
            zones_Prec(j,i) = mean(grid_Prec{1,j}(Prec_zones_9_manually==i));
        end
    end
end