% clear
base = zeros(576, 640);
I = imread("0331v3TrimData/16/depth/20200331153208308x.png");
c = [0,3,6,9,12,50,12,9,6,3,0;3,6,12,21,50,50,50,21,12,6,3;6,12,24,50,50,50,50,50,24,12,6;9,21,50,50,50,100,50,50,50,21,9;12,50,50,50,100,100,100,50,50,50,12;50,50,50,100,100,100,100,100,50,50,50;12,50,50,50,100,100,100,50,50,50,12;9,21,50,50,50,100,50,50,50,21,9;6,12,24,50,50,50,50,50,24,12,6;3,6,12,21,50,50,50,21,12,6,3;0,3,6,9,12,50,12,9,6,3,0];
for k=1:size(grabMat, 1)
    row = int16(grabMat(k, 2));
    col = int16(grabMat(k, 1));
    base(row-5:row+5, col-5:col+5) = base(row-5:row+5, col-5:col+5) + c;
end
% im = image(base);
% axis off
% colorbar
imwrite(base,winter, "heatmap.png");
J = imread("heatmap.png");
D = imfuse(J,I,'falsecolor','Scaling','joint', 'ColorChannels', 'red-cyan');
imshow(D)
