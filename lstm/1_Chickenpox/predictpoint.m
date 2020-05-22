clear;

% I = imread("0520exData/training/depth/20200520164509856.png");
load('v3Params.mat');
load('timeindexOrigin.mat');
load('Ypred.mat');
% load('trainingImageDatastore.mat', trainingImageDatastore)
% J = undistortImage(I,v3Params);
futureduration = 30; %1ïbå„
grabMat = zeros(32, 3);
poseimg = imageDatastore(fullfile('0520exData','training', 'depth'),...
    'IncludeSubfolders',true,'FileExtensions','.png','LabelSource','foldernames');

for i = 1:size(YPred, 2)
%     I = imread("0520exData/training/depth/" + timeindexOrigin(i) + ".png");
    grabMat = zeros(32, 3);
    I = readimage(poseimg,size(poseimg.Files, 1)-size(YPred, 2)-futureduration+i);
    J = undistortImage(I,v3Params);
    for cnt=0:31
        grabMat(cnt+1,:) = (v3Params.Intrinsics.IntrinsicMatrix' * YPred(3*cnt+1:3*cnt+3, i) / YPred(3*cnt+3, i))';
    end
    grabMat(:,3) = [];
    J = insertMarker(J,grabMat,'o','color','yellow','size',3);
%     imshow(J);
    imwrite(J,'0520exData/training/predictpos2/' + timeindexOrigin(size(poseimg.Files, 1)-size(YPred, 2)-futureduration+i) + '.png')

end
