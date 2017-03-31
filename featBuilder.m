
for i = 1:length(trainFileList)
    [x, fs] = audioread(trainFileList{i});
    [c, y] = spCepstrum(x, fs, window, show)
    
end









