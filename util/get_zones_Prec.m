function zones_Prec = get_zones_Prec(time_start, time_end)
% This function returns the raw data for the precipitation without null values
% The data have been averaged according to the clustering regions
% Data are given in terms of months with a time span of 1981-12-201504
% a total of 401 months
    if nargin == 0
        time_start = 1;
        time_end = 401;
    end
    Prec_zones_9_manually = dlmread('data/Prec_zones_9_manually.dat');
    Prec = dlmread('data/Prec_198112-201504.dat');

    % Apply for memory
    for k = time_start:time_end
        grid_Prec{k} = zeros(72,128);
    end

    % Read precipitation data
    for k = time_start:time_end
        temp = Prec(k,:);
        mask = dlmread('data/Prec_198112-201504_mask.dat');
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