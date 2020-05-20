v2 = readmatrix("3dboneRotated.csv");
v3 = readmatrix("3dboneRotatedv3.csv");

v2LW = v2(:,20) - v2(:,2);
v3LW = v3(:,23) - v3(:,2);


plot(v2LW, 'r');
hold on;
plot(v3LW, 'b');
title("Horizontal distance from Plevis to LeftWrist")
ylabel('Distance(m)')
xlabel('sample')

% fs = 30;
% y2 = fft(v2LW);
% y3 = fft(v3LW);
% n = length(v2LW);
% f = (0:n-1)*(fs/n);
% power2 = mag2db(abs(y2).^2/n);
% power3 = mag2db(abs(y3).^2/n);
% plot(f, power2, f, power3)
% xlim([0, 30])
% xlabel('Frequency')
% ylabel('Power')