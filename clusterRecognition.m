% catFeat = [mfcc_train formant_upgrade_train];

%% adjust imbalance train test samples
nClass = 4;

% Train
idxOne = find(group==1);
idxTwo = find(group==2);
idxThree = find(group==3);
idxFour = find(group==4);
nTrain = min([length(idxOne), length(idxTwo), ...
    length(idxThree), length(idxFour)]);
idxMinTrain = [idxOne(1:nTrain); idxTwo(1:nTrain); idxThree(1:nTrain); idxFour(1:nTrain)];

% Test
idxOne = find(label==1);
idxTwo = find(label==2);
idxThree = find(label==3);
idxFour = find(label==4);
nTest = min([length(idxOne), length(idxTwo), ...
    length(idxThree), length(idxFour)]);
idxMinTest = [idxOne(1:nTest); idxTwo(1:nTest); idxThree(1:nTest); idxFour(1:nTest)];

% assigned train/test indices
% idxTrain = idxMinTrain;
% idxTest = idxMinTest;
idxTrain = 1:length(group);
idxTest = 1:length(label);

% assigned train/test labels
clsTrain = group;%(idxTrain);
clsTest = label;%(idxTest);

%% combination the features
% mfcc_train_2 = mfcc_train;
% mfcc_test_2 = mfcc_sample;

% trainingFeat = [zscore(mfcc_train_2) ];
% testFeat = [zscore(mfcc_test_2) ];

trainingFeat = [zscore(trainFeat) ];
testFeat = [zscore(testFeat) ];

% trainingFeat = [zscore(mfcc_train_2) zscore(formant_upgrade_train(idxTrain, :))];
% testFeat = [zscore(mfcc_test_2) zscore(formant_upgrade_sample(idxTest, :))];

% trainingFeat = [zscore(mfcc_train_2) zscore(formant_train(idxTrain, :))];
% testFeat = [zscore(mfcc_test_2) zscore(formant_sample(idxTest, :))];

% trainingFeat = [zscore(formant_train(idxTrain, :))];
% testFeat = [zscore(formant_sample(idxTest, :))];

% trainingFeat = [formant_upgrade_train(idxTrain, :)];
% testFeat = [formant_upgrade_sample(idxTest, :)];

% trainingFeat = [zscore(formant_upgrade_train(idxTrain, :))];
% testFeat = [zscore(formant_upgrade_sample(idxTest, :))];

% trainingFeat = [zscore(mfcc_train_2) zscore(repmat(formant_upgrade_train, 1, 4))];
% testFeat = [zscore(mfcc_test_2) zscore(repmat(formant_upgrade_sample, 1, 4))];

%% normalization
trainingFeat = zscore(trainingFeat')';
testFeat = zscore(testFeat')';

% trainingFeat = zscore(trainingFeat);
% testFeat = zscore(testFeat);

%% clustering feature for classification
rng(1); % fixed randomization

% emotional clustering
% K = 65;
% K = 256;
% [cluster, centroid] = kmeans(trainingFeat, K);

% sub-emotional clustering
K = 128;
[cluster1, centroid1] = kmeans(trainingFeat(clsTrain==1, :), K);
[cluster2, centroid2] = kmeans(trainingFeat(clsTrain==2, :), K);
[cluster3, centroid3] = kmeans(trainingFeat(clsTrain==3, :), K);
[cluster4, centroid4] = kmeans(trainingFeat(clsTrain==4, :), K);
cluster = [cluster1; cluster2; cluster3; cluster4];
centroid = [centroid1; centroid2; centroid3; centroid4];

% classes-cluster distribution
figure(1),subplot(2,2,1), hist(cluster(clsTrain==1), K), ylim([0 150]), title('Anger')
figure(1),subplot(2,2,2), hist(cluster(clsTrain==2), K), ylim([0 150]), title('Happy')
figure(1),subplot(2,2,3), hist(cluster(clsTrain==3), K), ylim([0 150]), title('Sadness')
figure(1),subplot(2,2,4), hist(cluster(clsTrain==4), K), ylim([0 150]), title('Neutal')

% assign cluster label for classification
clusterClass = zeros(K, 1);
for k = 1:size(centroid, 1)
    classesInCluster = clsTrain(cluster==k);
    
    % count the label in cluster then use the major classes as a cluster class
    %     N = hist(classesInCluster, 1:4);
    %     [~, clusterClass(k)] = max(N);
    
    % assign sub-emotional label to cluster label
    clusterClass(k) = ceil(k/K);
end

%% classifications
% classify using cluster
predictedCls = knnclassify(testFeat, centroid, clusterClass, 1);
isCorrect = predictedCls == clsTest;

% classify using k-nn
predictedClsKNN = knnclassify(testFeat, trainingFeat, clsTrain, 1);
isCorrectKNN = predictedClsKNN == clsTest;

acc = mean([isCorrectKNN isCorrect]);

clsCorrect_v1 = [...
    mean(isCorrectKNN); ...
    mean(isCorrectKNN(clsTest==1)); ...
    mean(isCorrectKNN(clsTest==2)); ...
    mean(isCorrectKNN(clsTest==3)); ...
    mean(isCorrectKNN(clsTest==4)); ...
    ];

clsCorrect = [...
    mean(isCorrect); ...
    mean(isCorrect(clsTest==1)); ...
    mean(isCorrect(clsTest==2)); ...
    mean(isCorrect(clsTest==3)); ...
    mean(isCorrect(clsTest==4)); ...
    ];

[clsCorrect_v1 clsCorrect]'