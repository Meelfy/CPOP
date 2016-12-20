function result_analysis()
    clc;clear;close;
    result_TDNN = xlsread('result/result_TDNN.xlsx');
    % 数字代表列号
    % idx 隐藏层个数 延迟时间 训练集MSE 验证集MSE 测试集MSE 全集MSE 训练集相关系数 验证集相关系数 测试集相关系数 全集相关系数 
    % 1   2          3        4         5         6         7       8              9              10             11           
    % region1 region2 region3 region4 region5 region6 region7 region8 region9
    % 12      13      14      15      16      17      18      19      20

    % 统计延迟时间的变化
    min_delay = min(result_TDNN(:, 3));
    max_delay = max(result_TDNN(:, 3));
    disp(['最小的延迟时间为： ' num2str(min_delay)]);
    disp(['最大的延迟时间为： ' num2str(max_delay)]);

    % 统计各个延迟时间的结果
    % 对所有存在的延迟时间进行遍历
    for idx = min_delay : 20
        result_time(idx, :) = mean(result_TDNN(result_TDNN(:, 3) == idx, :), 1);
    end

    % 全集MSE 随时间 的变化
    plot(result_time(:, 7))

    % 测试集MSE 随时间 的变化
    plot(result_time(:, 6))

    % 全集相关系数 的变化
    plot(result_time(:, 11))

    % 测试集相关系数 的变化
    plot(result_time(:, 10))

    % 九个区域 的变化
    plot(mean(result_time(:, 12:20)))
    