function [outputImage] = replaceBackground(imageFile, mask, targetBackground)

image = imread(imageFile);
imageSize = size(image);
alexnetSize = [227, 227];

%Mask as input
maskStruct = load(mask);
backgroundMask = maskStruct.backgroundMask;
foregroundMask = uint8(~backgroundMask);

%Size is alexnet size [227, 227, 3]
newBackgroundStruct = load(targetBackground);
newBackground = newBackgroundStruct.bgImage;

%To apply the RxC mask on image of size RxCx3
image = imresize(image, alexnetSize);
imForeground = bsxfun(@times, image, cast(foregroundMask,class(image)));
imBackground = bsxfun(@times, newBackground, cast(backgroundMask,class(newBackground)));

outputImage = uint8(imBackground) + uint8(imForeground);
end