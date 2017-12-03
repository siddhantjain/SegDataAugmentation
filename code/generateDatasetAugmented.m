
outputFolder = fullfile('../data/', 'caltech101'); % define output folder
rootFolder = fullfile(outputFolder, 'train/101_ObjectCategoriesAugmented/Data_Augmented');

categoriesF = dir(rootFolder);
categoriesF = categoriesF(~ismember({categoriesF.name},{'.','..'}));

categories = {};
for index = 1:numel(categoriesF)
    categories{end+1} = categoriesF(index).name; 
end

imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource', 'foldernames');

tbl = countEachLabel(imds);

% determine the smallest amount of images in a category
minSetCount = min(tbl{:,2}); 

% Use splitEachLabel method to trim the set.
imds = splitEachLabel(imds, minSetCount, 'randomize');

imds.ReadFcn = @(filename)readAndPreprocessImage(filename);


trainingSet = imds;

save('../data/caltech101Augmented.mat','trainingSet');