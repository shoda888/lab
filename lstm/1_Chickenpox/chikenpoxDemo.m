%% ���vጂ̌����̗\��
%
% Copyright 2018 The MathWorks, Inc.

%% �n��f�[�^�̓ǂݍ���

data = chickenpox_dataset;
data = [data{:}];

time = datetime('1931/1/1'):calmonths(1):datetime('1972/6/1');

figure
plot(time, data);
ylabel("���Ґ�")
title("��������̐��vጂ̊��Ґ�")

h = gca;
h.FontName = 'Meiryo UI';
h.FontSize = 14;

%% �w�K�f�[�^�ƃe�X�g�f�[�^�̕���

numTimeStepsTrain = floor(0.9 * numel(data));

XTrain = data(1:numTimeStepsTrain);
YTrain = data(2:numTimeStepsTrain+1);
XTest = data(numTimeStepsTrain+1:end-1);
YTest = data(numTimeStepsTrain+2:end);

numTimeStepsTest = numel(XTest);

idxTrain = 1:numTimeStepsTrain;
idxTest = (numTimeStepsTrain+1):(numTimeStepsTrain + numTimeStepsTest);

%% �f�[�^�̕W����

mu = mean(XTrain);
sig = std(XTrain);

XTrain = (XTrain - mu) / sig;
YTrain = (YTrain - mu) / sig;

XTest = (XTest - mu) / sig;

%% LSTM Network �̍\�z

inputSize = 1;
numResponses = 1;
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

%% �����̎��ԗ̈�ł̗\��

% �ߋ��f�[�^����͂��ď�Ԃ��X�V
net = predictAndUpdateState(net, XTrain);

% �P�X�e�b�v�ڂ̗\��
[net, YPred(1)] = predictAndUpdateState(net, XTest(1));

% �Q�X�e�b�v�ڈȍ~�̗\��
for i = 2:numTimeStepsTest
    
    [net, YPred(i)] = predictAndUpdateState(net, YPred(i - 1));

end

YPred = sig * YPred + mu;

%% RMSE�i���ϓ��덷�������j�̎Z�o

rmse = sqrt(mean((YPred - YTest).^2));
disp(rmse)

%% �ϑ��l�E�\���l�̉���

figure

plot(time(idxTrain), data(idxTrain))
hold on

plot(time(idxTest), YPred, '.-')
hold off
ylabel("���Ґ�")
title("���vጂ̊��Ґ��̗\��")
legend(["�ϑ��l" "�\���l"])

%% �ϑ��l�E�\���l�E�\���덷�̉���

figure
subplot(2, 1, 1)
plot(time(idxTest), YTest)
hold on
plot(time(idxTest), YPred, '.-')
hold off
legend(["�ϑ��l" "�\���l"])
ylabel("���Ґ�")
title("���vጂ̊��Ґ��̗\��")

h = gca;
h.FontName = 'Meiryo UI';
h.FontSize = 14;

subplot(2, 1, 2)
stem(time(idxTest), YPred - YTest)
ylabel("�\���덷")
title("RMSE = " + rmse)

h = gca;
h.FontName = 'Meiryo UI';
h.FontSize = 14;

%% �ϑ��l�ɂ��l�b�g���[�N�̏�Ԃ��X�V

% ��Ԃ����Z�b�g
net = resetState(net);

% �ߋ��f�[�^����͂��āA��Ԃ��X�V
net = predictAndUpdateState(net, XTrain);

%% �����Ƃ̊ϑ��l���������\��

YPred = [];
numTimeStepsTest = numel(XTest);

for i = 1:numTimeStepsTest
    
    [net, YPred(i)] = predictAndUpdateState(net, XTest(i));
    
end

YPred = sig * YPred + mu;

%% �\���덷�̎Z�o

rmse = sqrt(mean((YPred - YTest).^2));
disp(rmse)

%% �ϑ��l�E�\���l�E�\���덷�̉���

figure
subplot(2, 1, 1)
plot(time(idxTest), YTest)
hold on
plot(time(idxTest), YPred,'.-')
hold off
legend(["�ϑ��l" "�\���l"])
ylabel("���Ґ�")
title("���vጂ̊��Ґ��̗\���i�����Ƃ̍X�V�j")

h = gca;
h.FontName = 'Meiryo UI';
h.FontSize = 14;

subplot(2, 1, 2)
stem(time(idxTest), YPred - YTest)
ylabel("�\���덷")
title("RMSE = " + rmse)

h = gca;
h.FontName = 'Meiryo UI';
h.FontSize = 14;
