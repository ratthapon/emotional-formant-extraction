% Clean-up MATLAB's environment
%    clear all; close all;
%load('wave/01/filename_train_test_randomized.mat');
%------------------ anger -------------------------------------------------

stat_an_train = [];
for name = filename_an_train'
    [x,fs] = audioread(char(name));
    x = x(:,1);
    F0 = windowed_spectrum_stat(x, fs);
    stats = stat_formant(F0);
    stat_an_train = [stat_an_train;stats];
end
stat_an_sample = [];
for name = filename_an_sample'
    [x,fs] = audioread(char(name));
    x = x(:,1);
    F0 = windowed_spectrum_stat(x, fs);
    stats = stat_formant(F0);
    stat_an_sample = [stat_an_sample;stats];
end

%------------------ happy -------------------------------------------------

stat_ha_train = [];
for name = filename_ha_train'
    [x,fs] = audioread(char(name));
    x = x(:,1);
    F0 = windowed_spectrum_stat(x, fs);
    stats = stat_formant(F0);
    stat_ha_train = [stat_ha_train;stats];
end
stat_ha_sample = [];
for name = filename_ha_sample'
    [x,fs] = audioread(char(name));
    x = x(:,1);
    F0 = windowed_spectrum_stat(x, fs);
    stats = stat_formant(F0);
    stat_ha_sample = [stat_ha_sample;stats];
end

%------------------ sadness -----------------------------------------------

stat_sa_train = [];
for name = filename_sa_train'
    [x,fs] = audioread(char(name));
    x = x(:,1);
    F0 = windowed_spectrum_stat(x, fs);
    stats = stat_formant(F0);
    stat_sa_train = [stat_sa_train;stats];
end
stat_sa_sample = [];
for name = filename_sa_sample'
    [x,fs] = audioread(char(name));
    x = x(:,1);
    F0 = windowed_spectrum_stat(x, fs);
    stats = stat_formant(F0);
    stat_sa_sample = [stat_sa_sample;stats];
end

%------------------ neutral -----------------------------------------------

stat_ne_train = [];
for name = filename_ne_train'
    [x,fs] = audioread(char(name));
    x = x(:,1);
    F0 = windowed_spectrum_stat(x, fs);
    stats = stat_formant(F0);
    stat_ne_train = [stat_ne_train;stats];
end
stat_ne_sample = [];
for name = filename_ne_sample'
    [x,fs] = audioread(char(name));
    x = x(:,1);
    F0 = windowed_spectrum_stat(x, fs);
    stats = stat_formant(F0);
    stat_ne_sample = [stat_ne_sample;stats];
end

% %------------------------- Classify Attribute -----------------------------
new_an_train = zscore(stat_an_train);
new_an_sample = zscore(stat_an_sample);
new_ha_train = zscore(stat_ha_train);
new_ha_sample = zscore(stat_ha_sample);
new_sa_train = zscore(stat_sa_train);
new_sa_sample = zscore(stat_sa_sample);
new_ne_train = zscore(stat_ne_train);
new_ne_sample = zscore(stat_ne_sample);

% training = [stat_an_train;stat_ha_train;stat_sa_train;stat_ne_train];
% sample = [stat_an_sample;stat_ha_sample;stat_sa_sample;stat_ne_sample];
training = [new_an_train;new_ha_train;new_sa_train;new_ne_train];
sample = [new_an_sample;new_ha_sample;new_sa_sample;new_ne_sample];
group = [];
m = 1;
for k = 1:size(stat_an_train,1)
    group = [group;m];
end
m = 2;
for k = 1:size(stat_ha_train,1)
    group = [group;m];
end
m = 3;
for k = 1:size(stat_sa_train,1)
    group = [group;m];
end
m = 4;
for k = 1:size(stat_ne_train,1)
    group = [group;m];
end
%------------------------- Classify Expected ------------------------------
ex = [];
m = 1;
for k = 1:size(stat_an_sample,1)
    ex = [ex;m];
end
m = 2;
for k = 1:size(stat_ha_sample,1)
    ex = [ex;m];
end
m = 3;
for k = 1:size(stat_sa_sample,1)
    ex = [ex;m];
end
m = 4;
for k = 1:size(stat_ne_sample,1)
    ex = [ex;m];
end

%-------------------------------- Classify process ------------------------
group;
% class = knnclassify(sample, training, group, 1);
% 
sample = zscore(sample);
training = zscore(training);
class = knnclassify(sample, training, group, 1);
ex;
%-------------------------------- find percent ----------------------------
all = 0;
all_an = 0;
all_ha = 0;
all_sa = 0;
all_ne = 0;
for k = 1:size(class,1)
    if(ex(k) == class(k))
        all = all + 1;
        if(ex(k) == 1)
            all_an = all_an + 1;
        end
        if(ex(k) == 2)
            all_ha = all_ha + 1;
        end
        if(ex(k) == 3)
            all_sa = all_sa + 1;
        end
        if(ex(k) == 4)
            all_ne = all_ne + 1;
        end
    end
end
all = all*100/size(class,1)
anger = all_an*100/size(stat_an_sample,1)
happy = all_ha*100/size(stat_ha_sample,1)
sadness = all_sa*100/size(stat_sa_sample,1)
neutral = all_ne*100/size(stat_ne_sample,1)

bar(1, all, 'FaceColor',[0 .5 0],'EdgeColor',[0 .9 0],'LineWidth',1.5);
hold on
ylim([0 100])
bar(2, anger , 'FaceColor',[.5 0 0],'EdgeColor',[.9 0 0],'LineWidth',1.5);
bar(3, happy , 'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.5);
bar(4, sadness, 'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.5);
bar(5, neutral, 'FaceColor',[.5 0 .5],'EdgeColor',[.9 0 .9],'LineWidth',1.5);
legend('all','anger','happy','sadness', 'neutral');
title('Formant classify');