    clear;
    exnum = [16];
    I = imread("0331v3TrimData/16/depth/20200331153208308x.png");
    load('v3Params.mat');
    load('KNNtrainedModel.mat');
    load('TestBoneData.mat')
    
    for i = 1:size(exnum, 2)
        v3 = readmatrix("0331v3TrimData/" + exnum(i) + "/0/pos.csv");
        v3(:,2:97) = lowpass(v3(:,2:97), 0.3);
        yfit = KNNtrainedModel.predictFcn(testData);
        grabMat = zeros(size(find(yfit(:,1) == "Grabbing"), 1), 3);
        cnt = 0;
        for j=1:size(yfit, 1)
            if yfit(j,:)=="Grabbing"
                cnt = cnt + 1;
                grabMat(cnt,:) = (v3Params.Intrinsics.IntrinsicMatrix' * v3(j,26:28)' / v3(j,28))';
            end
        end
        grabMat(:,3) = [];
        I = insertMarker(I,grabMat,'o','color','white','size',5);
        imshow(I);
    end
