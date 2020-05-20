%% 階段昇降動作の未来予測
clear
%% 系列データの読み込み

v3 = readmatrix("0520exData/training/0/pos.csv");
data = lowpass(v3(:,2:97), 0.3);
data = data';
time = readmatrix("timeindex.csv");

figure
plot(data(1:4,:)');
ylabel("Xvalue")
title("Plevis")

h = gca;
h.FontName = 'Meiryo UI';
h.FontSize = 14;

%% 学習データとテストデータの分割
numTimeStepsTrain = floor(0.8 * size(data, 2));

XTrain = data(:, 1:numTimeStepsTrain);
YTrain = data(:, 10:numTimeStepsTrain+9);
XTest = data(:, numTimeStepsTrain+1:end-9);
YTest = data(:, numTimeStepsTrain+10:end);

numTimeStepsTest = size(XTest, 2);

idxTrain = 1:numTimeStepsTrain;
idxTest = (numTimeStepsTrain+1):(numTimeStepsTrain + numTimeStepsTest);

%% データの標準化

mu = mean(XTrain, 2);
sig = std(XTrain, 0, 2);

XTrain = (XTrain - mu) ./ sig;
YTrain = (YTrain - mu) ./ sig;

XTest = (XTest - mu) ./ sig;

%% LSTM Network の構築

inputSize = 96;
numResponses = 96;
numHiddenUnits = 200;

layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];

%% 学習オプションの設定

opts = trainingOptions('adam', ...
    'MaxEpochs', 250, ...
    'GradientThreshold', 1, ...
    'InitialLearnRate', 0.005, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropPeriod', 125, ...
    'LearnRateDropFactor', 0.2, ...
    'Verbose', 0, ...
    'Plots', 'training-progress');

%% LSTM Network の学習

net = trainNetwork(XTrain, YTrain, layers, opts);


%% 観測値によりネットワークの状態を更新

% 状態をリセット
net = resetState(net);

% 過去データを入力して、状態を更新
net = predictAndUpdateState(net, XTrain);

%% 月ごとの観測値を供給しつつ予測

YPred = [];
numTimeStepsTest = size(XTest, 2);

for i = 1:numTimeStepsTest
    
    [net, YPred(:, i)] = predictAndUpdateState(net, XTest(:, i));
    
end

YPred = sig .* YPred + mu;

%% 予測誤差の算出

rmse = sqrt(mean((YPred - YTest).^2));
disp(rmse)

%% 観測値・予測値・予測誤差の可視化

figure
subplot(2, 1, 1)
plot(time(idxTest), YTest(8,:))
hold on
plot(time(idxTest), YPred(8,:),'.-')
hold off
legend(["観測値" "予測値"])
ylabel("value")
title("骨格座標の予測値")

h = gca;
h.FontName = 'Meiryo UI';
h.FontSize = 14;

subplot(2, 1, 2)
stem(time(idxTest), YPred(8,:) - YTest(1,:))
ylabel("予測誤差")
title("RMSE = " + rmse)

h = gca;
h.FontName = 'Meiryo UI';
h.FontSize = 14;


