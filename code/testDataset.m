dataset = load('../data/caltech101.mat'); 
models = load('../models/trained_classifier.mat');

testSet = dataset.testSet;
classifier = models.classifier;
% Extract test features using the CNN
testFeatures = activations(net, testSet, featureLayer, 'MiniBatchSize',32);

% Pass CNN image features to trained classifier
predictedLabels = predict(classifier, testFeatures);

% Get the known labels
testLabels = testSet.Labels;

match = testLabels == predictedLabels;
correct = sum(match(:));
accuracy = correct/numel(match);
confMat = confusionmat(testLabels,predictedLabels);
