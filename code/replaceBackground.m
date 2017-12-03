function [outputImage] = replaceBackground(imageFile, mask, targetBackground)

image = imread(imageFile);
imageSize = size(image);
alexnetSize = [227, 227];

%Mask as input
maskStruct = load(mask);
backgroundMask = maskStruct.backgroundMask;
foregroundMask = ~backgroundMask;

%Size is alexnet size [227, 227, 3]
newBackgroundStruct = load(targetBackground);
newBackground = newBackgroundStruct.meanBgImage;

%To apply the RxC mask on image of size RxCx3
imForeground = bsxfun(@times, foregroundMask, cast(foregroundMask,class(image)));
targetBGMask = resize(backgroundMask, alexnetSize);
imBackground = bsxfun(@times, targetBGMask, cast(targetBGMask,class(newBackground)));
imForeground = imresize(imForeground, alexnetSize);

outputImage = imBackground + imForeground;
outputImage = imresize(outputImage, imageSize);
end