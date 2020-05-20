clear
exnum = 12;
v3 = readmatrix("../0331v3Data/" + exnum + "/0/pos.csv");
% v3(:,1) = [];
v3(:,98) = [];

diff = diff(v3);

dWRIST_LEFT = vecnorm(diff(:,23:25),2, 2);
dHAND_LEFT = vecnorm(diff(:,26:28),2, 2);
dHANDTIP_LEFT = vecnorm(diff(:,29:31),2, 2);
dTHUMB_LEFT = vecnorm(diff(:,32:34),2, 2);
% dHAND = [dWRIST_LEFT, dHAND_LEFT, dHANDTIP_LEFT, dTHUMB_LEFT];
dHAND = [dHAND_LEFT, dHANDTIP_LEFT, dTHUMB_LEFT];
% dLWx = diff(:,23);
% dLWy = diff(:,24);
% dLWz = diff(:,25);
figure
plot(vecnorm(dHAND, 2, 2), 'r');
% hold on;
% plot(dHAND_LEFT, 'b');
% hold on;
% plot(dHANDTIP_LEFT, 'k');
% hold on;
% plot(dTHUMB_LEFT, 'c');
title("Position LeftWrist")
ylabel('Distance(m)')
xlabel('sample')