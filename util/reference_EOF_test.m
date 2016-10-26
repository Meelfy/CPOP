%求距平
M=reValue;       % or M=dlmread('RAIN_mask.dat');
 M=dlmread('RAIN_mask_13mean.dat');
X=detrend(M,0)';

%EOF时空转换；见《气候变率诊断和预测方法》吴洪宝 P28
C=X'*X/valuenum;   %协方差矩阵C
[EOF0,E]=eig(C); %协方差矩阵C的特征值E和特征向量EOF0  

E=rot90(E,2); %将对角阵按特征值从大到小排列
EOF0=fliplr(EOF0);%将特征向量左右颠倒

EOF=X*EOF0;   %目标协方差矩阵XX'/n的特征向量
E=E*valuenum/n; %目标协方差矩阵XX'/n的特征值，从大到小排列
lambda=diag(E);%将特征值提取出来
clear C EOF0 E 
sq=[sqrt(lambda*n)+eps]';   % 1*n 
sq=sq(ones(1,valuenum),:); %  valnum * n
EOF=EOF./sq;  % 空间函数 valnum*n 第i列代表第i模态的空间函数 
PC=EOF'*X;    % 时间函数 n*n 第i行代表第i模态的时间系数
clear sq; 
%对主成分和特征向量标准化
EOF=EOF.*sqrt(repmat(lambda',valuenum,1));
PC=PC./sqrt(repmat(lambda,1,n));
dlmwrite('RAIN_PC.dat',PC,'delimiter',' ','newline','pc'); %
dlmwrite('RAIN_EOF.dat',EOF,'delimiter',' ','newline','pc'); %


%EOF的显著性检验——North（1982） 
n_eof=0;
for i=1:n
    err=lambda(i)*sqrt(2/n);
    if(lambda(i)-lambda(i+1)>=err)
        continue;
    else
        n_eof=i;   %此程序n_eof=7，说明前七个模态都是有效的
        break;
    end
end
clear err i 

%累积方差贡献作图 
cum=100*cumsum(lambda)./sum(lambda);%累积方差贡献作图
percent_explained=100*lambda./sum(lambda);%方差贡献
%----EOF(monthly anomaly):前七个模态有效，前三个模态占比20.8%,7.4%,5.1%；————%
%----EOF(13点滑动平均):前三个模态占比36.54%,8.5%,6.3%；-------------------------%
figure
pareto(percent_explained)
xlabel('主成分','fontsize',12,'fontname','宋体')
ylabel('方差贡献率(%)','fontsize',12,'fontname','宋体')
set(gcf,'color','w');
dlmwrite('PerctExpln_EOF.dat',percent_explained,'delimiter',' ','newline','pc');
dlmwrite('PerctCum_EOF.dat',cum,'delimiter',' ','newline','pc');
