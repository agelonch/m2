tmwaveform = csvread('OriginalSignal.csv');
startVal = 5;
maxVal = 256;
errormaxB = 8;
error = zeros(1,maxVal)+500;
avglen = zeros(1,maxVal);
signalSize = zeros(1,maxVal);
bitsMatrix = zeros(1,maxVal);
huffman = false;

tmwaveform2 = normalization(tmwaveform);
stdSignal = bitStd(tmwaveform2);

for i=startVal:maxVal
    [error(i),avglen(i),signalSize(i)] = HuffmanSplit(stdSignal,i,false,huffman);
    bitsMatrix(i) = i;
end

[dictUsage,wastedBits,exponent] = plot1DResults(error,bitsMatrix,avglen,signalSize,startVal,maxVal,huffman);

minBits = min(bitsMatrix(error <= errormaxB));
[row,column] = find(bitsMatrix == minBits & error <= errormaxB);
[eee,aaa,sss] = HuffmanSplit(stdSignal,minBits,true,true);
bestConf = {'Error','Num. Bits','Num Values','Wasted Values','DictUsage','Avg. len','Size Signal';...
    eee,log2(exponent(row,column)),bitsMatrix(row,column),...
    wastedBits(row,column),dictUsage(row,column),aaa,sss};

%% Fit
[eee,aaa,sss] = HuffmanFitSplit(stdSignal,minBits,true,true);
bestConf2 = {'Error','Num. Bits','Num Values','Wasted Values','DictUsage','Avg. len','Size Signal';...
    eee,log2(exponent(row,column)),bitsMatrix(row,column),...
    wastedBits(row,column),dictUsage(row,column),aaa,sss};

plotSignal(tmwaveform)
