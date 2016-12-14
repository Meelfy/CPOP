function file_name = findFileAll(file_path, file_type)
    % 给出绝对路径 file_path
    % 和文件类型 file_type
    % 递归的找出file_path 下所有的 file_type 类型的文件

    % example：
    % clc;clear
    % file_type = 'nc';
    % file_path = 'E:\Datasets\WIND\WIND_daily';

    % 得到所有的子文件夹（包括自己）
    subdir = regexp(genpath(file_path), ';', 'split');
    file_name = [];
    file_name_dir = {};

    % 遍历所有的文件夹
    for i = 1 : length( subdir )
        if isempty(dir([subdir{i}, '\*.', file_type]))
            % 如果当前文件夹下没有相应的文件
            continue
        end
        file_name = [file_name; dir([subdir{i}, '\*.', file_type])];
        num_subdir = length(dir([subdir{i}, '\*.', file_type]));
        % 为文件名添加路径dir的属性
        for j = 1:num_subdir
            file_name_dir{length(file_name) - j + 1} = [subdir{i} '\'];
        end
    end

    % 给文件赋予路径的属性
    for i = 1:length(file_name)
        file_name(i).dir = file_name_dir{i};
    end