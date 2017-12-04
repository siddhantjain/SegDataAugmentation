url = 'http://www.vision.caltech.edu/Image_Datasets/Caltech101/101_ObjectCategories.tar.gz';
% Store the output in a temporary folder
outputFolder = fullfile('../data/', 'caltech101'); % define output folder
rootFolder = fullfile(outputFolder, '101_ObjectCategories');

if ~exist(rootFolder, 'dir') % download only once
    disp('Downloading 126MB Caltech101 data set...');
    untar(url, outputFolder);
end


categoriesF = dir(rootFolder);
%categoriesF = categoriesF(~ismember({categoriesF.name},{'.','..','BACKGROUND_Google'}));

categories = {};
for index = 1:numel(categoriesF)
    categories{end+1} = categoriesF(index).name; 
end

categories = {'anchor','butterfly','platypus','chair','crayfish','lobster'}
imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource', 'foldernames');

tbl = countEachLabel(imds);

% determine the smallest amount of images in a category
minSetCount = min(tbl{:,2}); 

% Use splitEachLabel method to trim the set.
imds = splitEachLabel(imds, minSetCount, 'randomize');

imds.ReadFcn = @(filename)readAndPreprocessImage(filename);


[trainingSet, testSet] = splitEachLabel(imds, 0.5, 'randomize');

save('../data/caltech101.mat','trainingSet','testSet');
