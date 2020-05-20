clear
exnum = [9, 10, 12, 13, 15, 16];
for i = 1:size(exnum, 2)
    v3 = readmatrix("0331v3TrimData/" + exnum(i) + "/0/pos.csv");
    depth = imageDatastore(fullfile("0331v3TrimData/" + exnum(i) + "/depth"),...
    'IncludeSubfolders',true,'FileExtensions','.png','LabelSource','foldernames');
    imgs = readall(depth);
    framenum = length(imgs);
    labels = ones(framenum, 1);
    for j = 1:framenum
        if strfind(depth.Files{j},'x.png') > 0
            labels(j, 1) = 0;
        else
            
        end
    end
    v3(:,98) = [];
    pos = [v3(1:framenum,:), labels];
    writematrix(pos, "0331v3TrimData/" + exnum(i) + "/0/pos.csv");
end


