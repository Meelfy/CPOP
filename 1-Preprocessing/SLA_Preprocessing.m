function SLA_Preprocseeing()
% Reads the data and extracts the region of interest
% time tange 199301-201508
% space range 100°E - 290°E  & 50°N - 50°S
    clear all;
    clc;
    file_path = 'E:/Datasets/AVISO月平均SLA(四分之一度)/monthly_mean/';
    file_name = dir([file_path, '*.nc']);
    file_num  = size(file_name, 1);
    one_SLA   = zeros(101, 191);
    row_num   = 101;
    col_num   = 191;
    SLA = zeros(file_num, row_num * col_num);

    for i = 1:file_num
        temp = ncread([file_path, file_name(i).name], 'sla');
        % change to x+(col) ~ E; y+(row) ~ N
        temp = temp';        
        % change to x+(col) ~ E; y+(row) ~ S
        temp = flipud(temp);
        % Latitude / row direction accuracy of 0.25 °, longitude / column direction of 0.25 °
        % The lower right corner (562, 1162) of the upper left corner (159, 399)
        temp = temp(159:562,399:1162);
        % Handle null values and fineness conversions
        Partitioned_Matrix = mat2cell(temp, 4*ones(1,row_num), 4*ones(1,col_num));
        one_SLA = cell2mat(cellfun(@(x)mean(x(:)),Partitioned_Matrix,'UniformOutput',0));

        SLA(i,:) = reshape(one_SLA, 1, row_num * col_num);

        % Displays the processing progress
        % disp(double(i)/file_num*100);
    end
    SLA(isnan(SLA)) = -9999;

    % Remove -9999
    mask = (SLA(1,:)==-9999);
    for i = 2:file_num
        mask = mask| (SLA(i,:)==-9999);
    end
    mask = ~mask;
    SLA =  SLA(:,mask);

    dlmwrite('data/SLA_199301-201508_mask.dat', mask, 'delimiter', ' ');
    dlmwrite('data/SLA_199301-201508.dat', SLA, 'delimiter', ' ');
end