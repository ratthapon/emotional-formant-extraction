%% define some const
load('filename_train_test_randomized');
wavDir = 'EMOLA';
trainFileList = [filename_an_train; filename_ha_train; filename_ne_train; filename_sa_train; ];
testFileList = [filename_an_sample; filename_ha_sample; filename_ne_sample; filename_sa_sample; ];

group = [ones(1, length(filename_an_train))  2*ones(1, length(filename_ha_train)) , ...
    3*ones(1, length(filename_ne_train)) 4*ones(1, length(filename_sa_train))]';
label = [ones(1, length(filename_an_sample))  2*ones(1, length(filename_ha_sample)) , ...
    3*ones(1, length(filename_ne_sample)) 4*ones(1, length(filename_sa_sample))]';









