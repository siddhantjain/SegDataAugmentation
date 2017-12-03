load('../data/caltech101')

for index = 1:length(trainingSet.Files)
    imPath = trainingSet.Files{index};
    imPathSplit = strsplit(imPath,{'/'});
    
    newImPath = '';
    for partIndex = 2:numel(imPathSplit)
        if partIndex == numel(imPathSplit)-2
            newImPath = strcat(newImPath,'/','train'); 
        end
        newImPath = strcat(newImPath,'/',imPathSplit(partIndex));
        if partIndex == numel(imPathSplit)-1
           if ~exist(newImPath{1}, 'dir')
                mkdir(newImPath{1});
           end 
        end
    end
    image = imread(imPath);
    imwrite(image,newImPath{1});
    
end

for index = 1:length(testSet.Files)
    imPath = testSet.Files{index};
    imPathSplit = strsplit(imPath,{'/'});
    
    newImPath = '';
    for partIndex = 2:numel(imPathSplit)
        if partIndex == numel(imPathSplit)-2
            newImPath = strcat(newImPath,'/','test'); 
        end
        newImPath = strcat(newImPath,'/',imPathSplit(partIndex));
        if partIndex == numel(imPathSplit)-1
           if ~exist(newImPath{1}, 'dir')
                mkdir(newImPath{1});
           end 
        end
    end
    image = imread(imPath);
    imwrite(image,newImPath{1});
    
end


%for annotations%
for index = 1:length(trainingSet.Files)
    imPath = trainingSet.Files{index};
    anPath = '';
    imPathSplit = strsplit(imPath,{'/'});
    
    newImPath = '';
    newAnPath = '';
    doCopy = true;
    for partIndex = 2:numel(imPathSplit)
        if partIndex == numel(imPathSplit)-2
            anPath = strcat(anPath,'/','Annotations');
            newAnPath = strcat(newAnPath,'/','train/Annotations');
            continue;
        end
        
        if partIndex == numel(imPathSplit)
           tempName = imPathSplit(partIndex);
           tempstr = strsplit(tempName{1},{'.','_'});
           anPath = strcat(anPath,'/','annotation_',tempstr{2},'.mat');
           newAnPath = strcat(newAnPath,'/','annotation_',tempstr{2},'.mat');
           continue;
        end
        anPath = strcat(anPath,'/',imPathSplit(partIndex));
        newAnPath = strcat(newAnPath,'/',imPathSplit(partIndex));
        
        if partIndex == numel(imPathSplit)-1
           if ~exist(anPath{1}, 'dir')
                doCopy = false;
           end
            if ~exist(newAnPath{1}, 'dir')
                mkdir(newAnPath{1});
           end 
        end
    end

    if doCopy
        copyfile(anPath{1},newAnPath{1});    
    end
end