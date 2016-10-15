% Reads the data and extracts the region of interest
% time tange 198112 - 201509
% space range 100°E - 290°E  & 50°N - 50°S
function SST_Preprocessing()
    clear('all');
    clc;
    month_num = 406;
    row_num   = 101;
    col_num   = 191;
    SST = zeros(month_num, row_num * col_num);

    for i = 1:month_num
        raw_SST{i} = zeros(180, 360);
    end
    % read SST and mask
    csv_SST  = dlmread('E:\Datasets\SST\OISST\sst.csv');
    mask_SST = dlmread('E:\Datasets\SST\OISST\mask.csv');

    % Dlmread automatically ignores blank lines
    % So it is 180 instead of 181
    for i = 1:month_num
        raw_SST{i} = csv_SST((i-1)*180+1:i*180, 1:360);
        raw_SST{i}(~mask_SST) = -9999;
    end
    
    for i = 1:month_num
        % space range 100°E - 290°E  & 50°N - 50°S
        SST(i,:) = reshape(raw_SST{i}(40:140,100:290), 1, row_num * col_num);
    end
    dlmwrite('data\SST_198112-201509.dat', SST, 'delimiter', ' ');
end