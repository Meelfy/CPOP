function EOF_SST_Time = EOF_SST_Time()
    SST = dlmread('data/SST_198112-201509.dat');
    valuenum = size(SST, 2);
    n = size(SST, 1);

    % 求距平
    % 对时间进行分解
    X = detrend(SST, 0)';

    % 求协方差矩阵 C
    C = X' * X / valuenum;

    % 协方差矩阵C的特征值E和特征向量EOF0  
    [EOF0, E] = eig(C); 

    % 将对角阵按特征值从大到小排列
    E = rot90(E, 2); 

    % 将特征向量左右颠倒
    EOF0 = fliplr(EOF0);

    % 目标协方差矩阵XX'/n的特征向量
    EOF = X * EOF0;   

    % 目标协方差矩阵XX'/n的特征值，从大到小排列
    E = E * valuenum / n; 

    % 将特征值提取出来
    lambda = diag(E);

    clear C EOF0 E 
    sq = [sqrt(lambda * n) + eps]';% 1*n 
    sq = sq(ones(1, valuenum), :); % valnum * n

    % 空间函数 valnum*n 第i列代表第i模态的空间函数 
    EOF = EOF ./ sq;  

    % 时间函数 n*n 第i行代表第i模态的时间系数
    PC = EOF' * X;    
    clear sq; 

    % 对主成分和特征向量标准化
    EOF = EOF .* sqrt(repmat(lambda', valuenum, 1));
    PC = PC ./ sqrt(repmat(lambda, 1, n));

    %EOF的显著性检验――North（1982） 
    n_eof = 0;
    for i = 1:n
        err = lambda(i)*sqrt(2/n);
        if(lambda(i) - lambda(i+1) >= err)
            continue;
        else
            n_eof = i;   % 此程序n_eof = 3，说明前3个模态都是有效的
            break;
        end
    end
    clear err i 

    % Each row represents a time series
    dlmwrite('data/EOF_SST_198112-201509.dat', PC', 'delimiter', ' ');
end