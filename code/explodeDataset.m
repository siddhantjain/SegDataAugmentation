outputFolder = fullfile('../data/', 'caltech101/train');
rootFolderImages = fullfile(outputFolder, '101_ObjectCategories');
rootFolderMasks = fullfile(outputFolder, 'masks/class_bg_masks');
rootFolderBackgrounds = fullfile(outputFolder, 'masks/class_bg');
rootFolderExploded = fullfile(outputFolder, '101_ObjectCategoriesExploded');

folderNamesI = dir(rootFolderImages);
folderNamesI = folderNamesI(~ismember({folderNamesI.name},{'.','..','.DS_Store'}));
folderNamesM = dir(rootFolderMasks);
folderNamesM = folderNamesM(~ismember({folderNamesM.name},{'.','..','.DS_Store'}));

folderNamesB = dir(rootFolderBackgrounds);
folderNamesB = folderNamesB(~ismember({folderNamesB.name},{'.','..','.DS_Store'}));

imageClassNames = {};
maskClassNames = {};
backgroundClassNames = {};

for index = 1:numel(folderNamesI)
    imageClassNames{end+1} = folderNamesI(index).name; 
end

for index = 1:numel(folderNamesM)
    maskClassNames{end+1} = folderNamesM(index).name; 
end

for index = 1:numel(folderNamesB)
    backgroundClassNames{end+1} = folderNamesB(index).name; 
end

destinationFolderExploded = rootFolderExploded;
if ~exist(destinationFolderExploded, 'dir')
    mkdir(destinationFolderExploded);
end

for fIndex =  1:length(imageClassNames)
    imageClassName = imageClassNames{fIndex};
    maskIndex = find(strcmp(maskClassNames, imageClassName));
    if length(maskIndex) == 0
        continue;
    end
    maskClassName = maskClassNames{maskIndex};
    
    assert(strcmp(maskClassName,imageClassName),'no mask found for image');
    imagePaths = dir(strcat(folderNamesI(fIndex).folder,'/',imageClassName));
    maskPaths = dir(strcat(folderNamesM(maskIndex).folder,'/',imageClassName));
    backgroundPaths = dir(strcat(folderNamesB(maskIndex).folder,'/',imageClassName));
    
    imagePaths = imagePaths(~ismember({imagePaths.name},{'.','..','.DS_Store'}));
    maskPaths = maskPaths(~ismember({maskPaths.name},{'.','..','.DS_Store'}));
    backgroundPaths = backgroundPaths(~ismember({backgroundPaths.name},{'.','..','.DS_Store'}));
    
    if(length(maskPaths)==0)
        continue;
    end
    destinationFolder = strcat(destinationFolderExploded,'/',imageClassName);
    if ~exist(destinationFolder, 'dir')
        mkdir(destinationFolder);
    end
    
    
    for iIndex = 1:length(imagePaths)
        iPath = strcat(imagePaths(iIndex).folder,'/',imagePaths(iIndex).name);
        mPath = strcat(maskPaths(iIndex).folder,'/',maskPaths(iIndex).name);
        for bIndex = 1:length(backgroundPaths)
            backgroundPath = strcat(backgroundPaths(bIndex).folder,'/',backgroundPaths(bIndex).name);

            explodedImage = replaceBackground(iPath,mPath, backgroundPath);
         
            
            iName = imagePaths(iIndex).name;
            iNameSplit = strsplit(iName,'.');

            bName = backgroundPaths(bIndex).name;
            bNameSplit = strsplit(bName,{'.','_'});
            
            explodedFname = strcat(destinationFolder,'/',iNameSplit(1), '_exploded_',bNameSplit(2),'.jpg');
            imwrite(explodedImage, explodedFname{1});
        end
        
    end
end