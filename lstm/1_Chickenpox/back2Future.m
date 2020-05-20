%% �K�i���~����̖����\��
clear
%% �n��f�[�^�̓ǂݍ���

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

%% �w�K�f�[�^�ƃe�X�g�f�[�^�̕���
numTimeStepsTrain = floor(0.8 * size(data, 2));

XTrain = data(:, 1:numTimeStepsTrain);
YTrain = data(:, 10:numTimeStepsTrain+9);
XTest = data(:, numTimeStepsTrain+1:end-9);
YTest = data(:, numTimeStepsTrain+10:end);

numTimeStepsTest = size(XTest, 2);

idxTrain = 1:numTimeStepsTrain;
idxTest = (numTimeStepsTrain+1):(numTimeStepsTrain + numTimeStepsTest);

%% �f�[�^�̕W����

mu = mean(XTrain, 2);
sig = std(XTrain, 0, 2);

XTrain = (XTrain - mu) ./ sig;
YTrain = (YTrain - mu) ./ sig;

XTest = (XTest - mu) ./ sig;

%% LSTM Network �̍\�z

inputSize = 96;
numResponses = 96;
numHiddenUnits = 200;

layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];

%% �w�K�I�v�V�����̐ݒ�

opts = trainingOptions('adam', ...
    'MaxEpochs', 250, ...
    'GradientThreshold', 1, ...
    'InitialLearnRate', 0.005, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropPeriod', 125, ...
    'LearnRateDropFactor', 0.2, ...
    'Verbose', 0, ...
    'Plots', 'training-progress');

%% LSTM Network �̊w�K

net = trainNetwork(XTrain, YTrain, layers, opts);


%% �ϑ��l�ɂ��l�b�g���[�N�̏�Ԃ��X�V

% ��Ԃ����Z�b�g
net = resetState(net);

% �ߋ��f�[�^����͂��āA��Ԃ��X�V
net = predictAndUpdateState(net, XTrain);

%% �����Ƃ̊ϑ��l���������\��

YPred = [];
numTimeStepsTest = size(XTest, 2);

for i = 1:numTimeStepsTest
    
    [net, YPred(:, i)] = predictAndUpdateState(net, XTest(:, i));
    
end

YPred = sig .* YPred + mu;

%% �\���덷�̎Z�o

rmse = sqrt(mean((YPred - YTest).^2));
disp(rmse)

%% �ϑ��l�E�\���l�E�\���덷�̉���

figure
subplot(2, 1, 1)
plot(time(idxTest), YTest(8,:))
hold on
plot(time(idxTest), YPred(8,:),'.-')
hold off
legend(["�ϑ��l" "�\���l"])
ylabel("value")
title("���i���W�̗\���l")

h = gca;
h.FontName = 'Meiryo UI';
h.FontSize = 14;

subplot(2, 1, 2)
stem(time(idxTest), YPred(8,:) - YTest(1,:))
ylabel("�\���덷")
title("RMSE = " + rmse)

h = gca;
h.FontName = 'Meiryo UI';
h.FontSize = 14;


