clear;

% I = imread("0520exData/training/depth/20200520164509856.png");
load('v3Params.mat');
load('timeindexOrigin.mat');
load('trainingImageDatastore.mat')
% J = undistortImage(I,v3Params);

v3 = readmatrix("0520exData/training/0/pos.csv");
v3(:,2:97) = lowpass(v3(:,2:97), 0.3);
grabMat = zeros(32, 3);

for i = 1:size(imds.Files, 1)
%     I = imread("0520exData/training/depth/" + timeindexOrigin(i) + ".png");
    grabMat = zeros(32, 3);
    I = readimage(imds,i);
    J = undistortImage(I,v3Params);
    for cnt=0:31
        grabMat(cnt+1,:) = (v3Params.Intrinsics.IntrinsicMatrix' * v3(i,3*cnt+2:3*cnt+4)' / v3(i,3*cnt+4))';
    end
    grabMat(:,3) = [];
    J = insertMarker(J,grabMat,'o','color','white','size',5);
    imshow(J);
    imwrite(J,'0520exData/training/pos/' + timeindexOrigin(i) + '.png')

end
