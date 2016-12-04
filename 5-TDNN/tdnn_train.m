function result = tdnn_train(X_input, Y_input, delay_times, hiddenLayerSize)
% Solve an Input-Output Time-Series Problem with a Time Delay Neural Network
    

    result = zeros(1,20);
    result(2) = hiddenLayerSize;
    result(3) = delay_times;


    % Standardize the input and output data
    X_input = normalize_By_Col(X_input);
    Y_input = normalize_By_Col(Y_input);


    %**********************TDNN start**********************
    delay_weeks = delay_times;
    % modify the delay date
    % Uses a memory-saving algorithm to calculate the 
    % error when the algorithm conjugate gradient
    % The input data was std
    % Training, Validation, Testing 8: 1: 1
    % Data has been randomly divided


    % This script assumes these variables are defined:
    %
    %   EOF_SST - input time series.
    %   X - target time series.

    X = tonndata(X_input,false,false);
    % EOF_SST = fromnndata(X,true,false,false);
    % Reversible
    T = tonndata(Y_input,false,false);

    % Choose a Training Function
    % For a list of all training functions type: help nntrain
    % 'trainlm' is usually fastest.
    % 'trainbr' takes longer but may be better for challenging problems.
    % 'trainscg' uses less memory. Suitable in low memory situations.
    trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.
    % trainFcn = 'trainlm';

    % Create a Time Delay Network
    inputDelays = 1:delay_weeks;
    hiddenLayerSize = hiddenLayerSize;
    net = timedelaynet(inputDelays,hiddenLayerSize,trainFcn);

    % Choose Input and Output Pre/Post-Processing Functions
    % For a list of all processing functions type: help nnprocess
    net.input.processFcns = {'removeconstantrows','mapstd'};% 对输入进行标准化
    net.output.processFcns = {'removeconstantrows'};

    % Prepare the Data for Training and Simulation
    % The function PREPARETS prepares timeseries data for a particular network,
    % shifting time by the minimum amount to fill input states and layer
    % states. Using PREPARETS allows you to keep your original time series data
    % unchanged, while easily customizing it for networks with differing
    % numbers of delays, with open loop or closed loop feedback modes.
    [x,xi,ai,t] = preparets(net,X,T);

    % Setup Division of Data for Training, Validation, Testing
    % For a list of all data division functions type: help nndivide
    % Training set: A set of examples used for learning, which is to fit the parameters [i.e., weights] of the classifier. 
    % Validation set: A set of examples used to tune the parameters [i.e., architecture, not weights] of a classifier, 
    % for example to choose the number of hidden units in a neural network. 
    % Test set: A set of examples used only to assess the performance [generalization] of a fully specified classifier.
    % divideblock can decompose data in order, not random.
    % net.divideFcn = 'dividerand';  % Divide data randomly
    net.divideFcn = 'divideblock'; 
    net.divideMode = 'time';  % Divide up every sample
    net.divideParam.trainRatio = 60/100;
    net.divideParam.valRatio = 20/100;
    net.divideParam.testRatio = 20/100;

    % Choose a Performance Function
    % For a list of all performance functions type: help nnperformance
    net.performFcn = 'mse';  % Mean Squared Error

    % Choose Plot Functions
    % For a list of all plot functions type: help nnplot
    net.plotFcns = {'plotperform','plottrainstate', 'ploterrhist', ...
      'plotregression', 'plotresponse', 'ploterrcorr', 'plotinerrcorr'};
    
    % 6 ——> 10
    net.trainParam.max_fail   = 10;
    % net.trainParam.showWindow = false;

    % Train the Network
    [net,tr] = train(net,x,t,xi,ai);

    % Test the Network
    y = net(x,xi,ai); % 输出结果
    e = gsubtract(t,y);% 直接作差
    performance = perform(net,t,y);
    result(7) = performance;

    % Recalculate Training, Validation and Test Performance
    trainTargets = gmultiply(t,tr.trainMask);
    valTargets = gmultiply(t,tr.valMask);
    testTargets = gmultiply(t,tr.testMask);
    trainPerformance = perform(net,trainTargets,y);
    result(4) = trainPerformance;
    valPerformance = perform(net,valTargets,y);
    result(5) = valPerformance;
    testPerformance = perform(net,testTargets,y);
    result(6) = testPerformance;



    %***************相关系数图片***************%
    i1 = tr.trainInd;
    t1 = t(:,i1);
    y1 = y(:,i1);
    result(8) = corr2([t1{:}],[y1{:}]);

    i2 = tr.valInd;
    t2 = t(:,i2);
    y2 = y(:,i2);
    result(9) = corr2([t2{:}],[y2{:}]);

    i3 = tr.testInd;
    t3 = t(:,i3);
    y3 = y(:,i3);
    result(10) = corr2([t3{:}],[y3{:}]);

    t4 = [t1 t2 t3];
    y4 = [y1 y2 y3];
    result(11) = corr2([t4{:}],[y4{:}]);
    % print(gcf,'-dpng',['img/result_', num2str(result(2)), '_', num2str(result(3))]);
    clear i1 t1 y1 i2 t2 y2 i3 t3 y3 t4 y4;
    %***************相关系数图片***************%


    for j = 1:length(e)
        result(12:20) = result(12:20) + abs(e{j}(1:9,1))';
    end

    % % prediction
    % predicte = sim(net, predicte_input);
    % e = gsubtract(t,y);