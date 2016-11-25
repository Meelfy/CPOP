function Time_Delay_Neural_Network_train
% Solve an Input-Output Time-Series Problem with a Time Delay Neural Network
    
    % read data
    zones_Prec = get_zones_Prec();
    EOF_SST = dlmread('data/SST_198112-201509.dat');

    % Intercept SST to make them time consistent
    EOF_SST = EOF_SST(1:end - 5, :);

    % Standardize the input and output data
    zones_Prec = normalize_By_Col(zones_Prec);
    EOF_SST = normalize_By_Col(EOF_SST);



    %**********************TDNN start**********************
    delay_month = 6;
    % modify the delay date
    % Uses a memory-saving algorithm to calculate the 
    % error when the algorithm conjugate gradient
    % The input data was std
    % Training, Validation, Testing 8: 1: 1
    % Data has been randomly divided


    % This script assumes these variables are defined:
    %
    %   EOF_SST - input time series.
    %   zones_Prec - target time series.

    X = tonndata(EOF_SST,false,false);
    % EOF_SST = fromnndata(X,true,false,false);
    % Reversible
    T = tonndata(zones_Prec,false,false);

    % Choose a Training Function
    % For a list of all training functions type: help nntrain
    % 'trainlm' is usually fastest.
    % 'trainbr' takes longer but may be better for challenging problems.
    % 'trainscg' uses less memory. Suitable in low memory situations.
    trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.
    % trainFcn = 'trainlm';

    % Create a Time Delay Network
    inputDelays = 1:delay_month;
    hiddenLayerSize = 30;
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
    net.divideParam.trainRatio = 70/100;
    net.divideParam.valRatio = 15/100;
    net.divideParam.testRatio = 15/100;

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
    performance = perform(net,t,y)

    % Recalculate Training, Validation and Test Performance
    trainTargets = gmultiply(t,tr.trainMask);
    valTargets = gmultiply(t,tr.valMask);
    testTargets = gmultiply(t,tr.testMask);
    trainPerformance = perform(net,trainTargets,y)
    valPerformance = perform(net,valTargets,y)
    testPerformance = perform(net,testTargets,y)



    % prediction
    predicte = sim(net, predicte_input);
    e = gsubtract(t,y);
