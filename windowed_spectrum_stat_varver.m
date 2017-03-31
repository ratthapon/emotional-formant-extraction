% function true_result = windowed_spectrum_stat_varver(x, fs)
filename = sprintf('ne/184.wav');
[x,fs] = audioread(filename);
x = x(:,1);

%% Initialization
N = length(x);

frame_length = 30;
frame_overlap = 20;
window = 'hamming';

nsample = round(frame_length  * fs / 1000); % convert ms to points
noverlap = round(frame_overlap * fs / 1000); % convert ms to points
if ischar(window)
    window   = eval(sprintf('%s(nsample)', window)); % e.g., hamming(nfft)
end
F0 = [];
pos = 1; i = 1;
frame = [];
while (pos+nsample < N)
    frame = [x(pos:pos+nsample-1)];
    [C(:,i), y(:,i)] = spCepstrum(frame, fs, window);
    F = spFormantCepstrum(C(:,i), fs);
    F0(size(F0, 1) + 1, 1:size(F, 2)) = F; % P'ARM ----------------------
    pos = pos + (nsample - noverlap);
    i = i + 1;
end
T = (round(nsample/2):(nsample-noverlap):N-1-round(nsample/2))/fs;



stat_y = [];
mean_y = mean(abs(y));
sd_y = std(y);
var_y = var(y); %varience
stat_y = [stat_y; mean_y, sd_y];
mean_of_sd= filter( ones(1, 64)/64, 1, sd_y);
sd_of_sd = stdfilt(sd_y, ones(1, 31));
var_of_var = (stdfilt(var_y, ones(1, 31))).^2;

% norm_vary = zscore(var_y);
% var_of_varnormy  = (stdfilt(norm_vary, ones(1, 31))).^2;


% var_of_x = (stdfilt(new_x, ones(1, 31))).^2;


% another_sd = std(var_y)*0.3; %bias variable
another_sd = std(var_of_var)*0.3;

%threshold1 = (ones(size(mean_of_sd)) .* mean_of_sd) + another_sd; %straight line
%threshold2 = (ones(size(mean_of_sd)) .* mean_of_sd) - another_sd; %straight line
%threshold3 = (ones(size(mean_of_sd)) .* mean_of_sd); %straight line
%# Create the gaussian filter with hsize = [5 5] and sigma = 2
minFilterSize = min(256, floor((length(sd_y)-1)/3));
G = fspecial('average',[1 minFilterSize]);
alpha = 1;
% localMeanOfVarOfVar = filtfilt(G, 1, var_y) + another_sd; %the chosen one
localMeanOfVarOfVar = filtfilt(G, 1, var_of_var); + another_sd; %the chosen one

% xnew = resample(x, 16000, 48000);

% %plotting
% figure
% % subplot(5, 1, 1);
% plot(x);
% xlabel('time');
% ylabel('frequency');
% title('whole signal');
% 
% figure
% % subplot(5, 1, 2);
% spectrogram(xnew, 30, 20, 512, 'yaxis');
% colormap(gray);
% colormap(flipud(colormap));
% title('spectrogram');
% 
% % subplot(5, 1, 3);
% 
% 
% figure
% hold on;
% plot(var_of_var);
% % plot(var_y);
% plot(localMeanOfVarOfVar, 'r');
% legend('var_s_p_e_c_t_r_u_m', 'local maen of var');
% title('variance of spectrum and Local mean');
% 
% figure
% % subplot(5, 1, 4);
% plot(var_of_var);
% % legend('var_v_a_r');
% title('var-var of spectrum');


%figure, plot(G, 'r');
% thresholding
% speechSegment = var_y > localMeanOfVarOfVar;
speechSegment = var_of_var > localMeanOfVarOfVar;

% figure
% % subplot(5, 1, 5);
% plot(speechSegment, 'r');
% axis([-inf inf -1 2]);
% title('speech Segment');




%% Baseline method
% new_x = resample(stdfilt(x), size(F0, 1), length(stdfilt(x)));
% thr = adaptthresh(new_x);
% speechSegment2 = new_x > thr;
% newF0 = F0(speechSegment2, 1:3);
% 
% figure, subplot(2, 1, 1);
% hold on;
% plot(new_x);
% plot(thr, 'r');
% title(' resampled signal & threshold (adaptive)');
% 
% subplot(2, 1, 2);
% plot(speechSegment2);
% axis([-inf inf -1 2]);
% title('speech segment');
% 
% subplot(3, 1, 3);
% plot(speechSegment2);
% title('thresholded');

%%
result = sd_y .* speechSegment;

true_result1 = [(F0(:,1))'.*result];
true_result2 = [(F0(:,2))'.*result];
true_result3 = [(F0(:,3))'.*result];

true_result = [true_result1; true_result2; true_result3];

true_result = true_result(: , speechSegment);

% true_result = F0(speechSegment, 1:3);
% end
