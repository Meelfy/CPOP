function SST_Preprocessing_monthly()
    % Reads the data and extracts the region of interest
    % time tange 1981.12-2016.11
    % space range 30°„E - 70°„W(290°„E)  & 50°„N - 30°„S
   
    clear('all');
    clc;
    % read SST and mask
    csv_SST  = dlmread('E:/Datasets/SST/OISST/sst.csv');
    mask_SST = dlmread('E:/Datasets/SST/OISST/mask.csv');

    month_num = size(csv_SST, 1) / 180;
    row_num   = 80;
    col_num   = 260;
    SST = zeros(month_num, row_num * col_num);

    for i = 1:month_num
        raw_SST{i} = zeros(180, 360);
    end

    % Dlmread automatically ignores blank lines
    % So it is 180 instead of 181
    for i = 1:month_num
        raw_SST{i} = csv_SST((i-1)*180+1:i*180, 1:360);
        raw_SST{i}(~mask_SST) = -9999;
    end
    
    for i = 1:month_num 
        % x ~ 90 - 50(50°„N) : 90 + 29(30°„S)
        % y ~ 31(30°„E)      : 180 + (180 - 70) (70°„W)
        SST(i,:) = reshape(raw_SST{i}(40:119,31:290), 1, row_num * col_num);
    end

    % Remove -9999
    mask = (SST(1,:)==-9999);
    for i = 2:month_num
        mask = mask| (SST(i,:)==-9999);
    end
    mask = ~mask;
    SST =  SST(:,mask);
    
    % When the mask is equal to 1 that there is data
    dlmwrite('data/SST_198112-201611_monthly_mask.dat', mask, 'delimiter', ' ');
    dlmwrite('data/SST_198112-201611_monthly.dat', SST, 'delimiter', ' ');
end