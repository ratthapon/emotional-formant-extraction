dir = 'EMOLA\';
Tw = 30;
Ts = 20;
trainFeat = zeros(length(trainFileList), 15);
testFeat = zeros(length(testFileList), 15);

for i = 1:length(trainFileList)
    i
    [x, fs] = audioread([dir trainFileList{i}]);
    
    Nw = Tw * 10^-3 * fs;
    Ns = Ts * 10^-3 * fs;
    frames = vec2frames( x(:), Nw, Ns, 'cols', @hamming, false );
    
    C = zeros(size(frames));
    F = zeros(3, size(frames, 2));
    
    for fIdx = 1:size(frames, 2)
        % cepstrum extraction
        [c, y] = spCepstrum(frames(:, fIdx), fs, 'hamming', false);
        C(:, fIdx) = c;
        
        % formant extraction
        f = spFormantCepstrum(c, fs);
        F(1:length(f), fIdx) = f;
        
    end
    dirPath = fileparts(['featTrain/' trainFileList{i}]);
    mkdir(dirPath);
    featwrite( ['featTrain/' trainFileList{i}] , F);
    
    % stat features extraction
    trainFeat(i, :) =  computeStat(F');
end

for i = 1:length(testFileList)
    j = i
    [x, fs] = audioread([dir testFileList{i}]);
    
    Nw = Tw * 10^-3 * fs;
    Ns = Ts * 10^-3 * fs;
    frames = vec2frames( x(:), Nw, Ns, 'cols', @hamming, false );
    
    C = zeros(size(frames));
    F = zeros(3, size(frames, 2));
    
    for fIdx = 1:size(frames, 2)
        % cepstrum extraction
        [c, y] = spCepstrum(frames(:, fIdx), fs, 'hamming', false);
        C(:, fIdx) = c;
        
        % formant extraction
        f = spFormantCepstrum(c, fs);
        F(1:length(f), fIdx) = f;
        
    end
    dirPath = fileparts(['featTest/' trainFileList{i}]);
    mkdir(dirPath);
    featwrite( ['featTest/' trainFileList{i}] , F);
    
    % stat features extraction
    testFeat(i, :) =  computeStat(F');
end








