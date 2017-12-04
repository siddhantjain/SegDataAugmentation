if(exist('../data/caltech101/masks','dir'))
    rmdir '../data/caltech101/masks' s;
end

if(exist('../data/caltech101/test','dir'))
    rmdir '../data/caltech101/test' s;
end

if(exist('../data/caltech101/train','dir'))
    rmdir '../data/caltech101/train' s;
end


generateDataset;
datasetSplitter;
trainDataset;
testDataset;
disp('Normal accuracy');
accuracy

%Average Augmentation%

%generateAverageBackgrounds;
%augmentDataset;
%generateDatasetAugmented;
%trainAugmentedDataset;
%testDataset;

%disp('Augmented accuracy');
%accuracy


% Exploded Augmentation
generateExplodedBackgrounds;
explodeDataset;
generateDatasetExploded;
trainExplodedDataset;
testDataset;

disp('Exploded accuracy');
accuracy

