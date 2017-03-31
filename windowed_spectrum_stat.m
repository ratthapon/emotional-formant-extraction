% function true_result = windowed_spectrum_stat(x, fs)
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

% figure, spectrogram(x,30,20,512,fs,'yaxis');

stat_y = [];
mean_y = mean(abs(y));
sd_y = std(y);
stat_y = [stat_y; mean_y, sd_y];
mean_of_sd = filter( ones(1, 64)/64, 1, sd_y);
sd_of_sd = stdfilt(sd_y, ones(1, 31));

cv_y = sd_of_sd ./ mean_of_sd;

another_sd = std(sd_of_sd)*0.02; %before = 0.3

%threshold1 = (ones(size(mean_of_sd)) .* mean_of_sd) + another_sd; %straight line
%threshold2 = (ones(size(mean_of_sd)) .* mean_of_sd) - another_sd; %straight line
%threshold3 = (ones(size(mean_of_sd)) .* mean_of_sd); %straight line
%# Create the gaussian filter with hsize = [5 5] and sigma = 2
minFilterSize = min(180, floor((length(sd_y)-1)/3)); %before = 70
G = fspecial('average',[1 minFilterSize]);
alpha = 1;
LocalMean = filtfilt(G, 1, sd_of_sd) + another_sd; %the chosen one



% %plotting
% figure
% subplot(3, 1, 1);
% plot(x);
% title('whole signal');
% xlabel('Frequency');
% ylabel('Amplitude');
% 
% % subplot(4, 1, 2);
% % plot(mean_y);
% % title('mean of signal');
% 
% subplot(3, 1, 2);
% hold on;
% 
% %plot(sd_of_sd);
% plot(LocalMean, '--');
% legend('threshold');
% plot(sd_y);
% xlabel('Frequency');
% ylabel('Amplitude');
% 
% 
% 
% title('standard deviation of signal');
% 
% %figure, plot(G, 'r');
% %% thresholding
% 
thresholded = sd_of_sd > LocalMean;
% subplot(3, 1, 3);
% plot(thresholded, 'r');
% axis([-inf inf 0 1.5]);
% title('thresholded signal');

% result = thresholded;
result = cv_y .* thresholded;


true_result1 = [(F0(:,1))'.*result];
true_result2 = [(F0(:,2))'.*result];
true_result3 = [(F0(:,3))'.*result];

true_result = [true_result1; true_result2; true_result3];

true_result = true_result(: , thresholded);
% end
