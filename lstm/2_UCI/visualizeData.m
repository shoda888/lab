%% Visualize Data
%
% Copyright 2018 The MathWorks, Inc.

clear
load('HARDataset')

%% �Z���T�[�f�[�^�̉���

g = 9.80665;

f = 50;
t = (0:127) / f;

kk = 199;
trgt = dataA(kk, :);

plot(t, g * trgt.ax), hold on
plot(t, g * trgt.ay)
plot(t, g * trgt.az), hold off
xlim([min(t) max(t)])

str = [actLabels{trgt.t} '(�팱�Ҕԍ� : ' num2str(trgt.s) ')'];

xlabel('���� [sec]')
ylabel('�����x [m/s^2]')
title(str)
grid on

h = gca;
h.FontName = 'Meiryo UI';
h.FontSize = 12;
