outputFolder = fullfile('../data/', 'caltech101/train');
rootFolderImages = fullfile(outputFolder, '101_ObjectCategories');
rootFolderAnnotations = fullfile(outputFolder, 'Annotations');

folderNamesI = dir(rootFolderImages);
folderNamesI = folderNamesI(~ismember({folderNamesI.name},{'.','..','.DS_Store'}));

folderNamesA = dir(rootFolderAnnotations);
folderNamesA = folderNamesA(~ismember({folderNamesA.name},{'.','..','.DS_Store'}));

imageClassNames = {};
annotationClassNames = {};

for index = 1:numel(folderNamesI)
    imageClassNames{end+1} = folderNamesI(index).name; 
end

for index = 1:numel(folderNamesA)
    annotationClassNames{end+1} = folderNamesA(index).name; 
end

% 
% for fIndex = 1:length(folderNamesA)
%      if(~ismember(folderNamesA(fIndex).name,anns))
%          folderNamesA(fIndex)
%      end
% end

destinationFolderBg = strcat(outputFolder,'/masks/mean_background');
if ~exist(destinationFolderBg, 'dir')
    mkdir(destinationFolderBg);
end
    
alexNetSize = [227 227];
for fIndex =  1:length(imageClassNames)
    imageClassName = imageClassNames{fIndex};
    annotationIndex = find(strcmp(annotationClassNames, imageClassName));
    
    %no annotation exists for this class, so skip
    if length(annotationIndex) == 0
        continue;
    end
    annotationClassName = annotationClassNames{annotationIndex};
    
    assert(strcmp(annotationClassName,imageClassName),'this should not happen');
    imagePaths = dir(strcat(folderNamesI(fIndex).folder,'/',imageClassName));
    annotationPaths = dir(strcat(folderNamesA(annotationIndex).folder,'/',imageClassName));
    
    imagePaths = imagePaths(~ismember({imagePaths.name},{'.','..','.DS_Store'}));
    annotationPaths = annotationPaths(~ismember({annotationPaths.name},{'.','..','.DS_Store'}));

    
    
    averageClassBackground = zeros([alexNetSize ,3]);
    averageClassBackgroundMask = ones(alexNetSize);
    
    destinationFolder = strcat(outputFolder,'/masks/class_bg_masks/',imageClassName);
    
    if ~exist(destinationFolder, 'dir')
        mkdir(destinationFolder);
    end

    for iIndex = 1:length(imagePaths)
        iPath = strcat(imagePaths(iIndex).folder,'/',imagePaths(iIndex).name);
        aPath = strcat(annotationPaths(iIndex).folder,'/',annotationPaths(iIndex).name);
        backgroundMask = segmentBackground(iPath,aPath);
        backgroundImage = imread(iPath);
        maskedBgImage = bsxfun(@times, backgroundImage, cast(backgroundMask,class(backgroundImage)));
        
        backgroundMask = double(imresize(backgroundMask,alexNetSize));
        maskedBgImage  = double(imresize(maskedBgImage,alexNetSize));
        iName = imagePaths(iIndex).name;
        iNameSplit = strsplit(iName,{'_','.'});
        
        bgFname = strcat(destinationFolder,'/','mask_',iNameSplit(2),'.mat');
        save(bgFname{1},'backgroundMask');
        
        averageClassBackground = averageClassBackground + maskedBgImage;
        averageClassBackgroundMask = averageClassBackgroundMask + backgroundMask; 
    end
    averageClassBackground = averageClassBackground ./ averageClassBackgroundMask;
    %TODO: consider dividing this by 255, instead of typecasting it to
    %uint8 and hence losing information in float value.
    meanBgImage = uint8(averageClassBackground);
    save(strcat(destinationFolderBg,'/',imageClassName,'.mat'),'meanBgImage');
end