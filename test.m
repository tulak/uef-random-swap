% Author: Filip Zachar (2017)

% datasets =     {'a1' 'a2' 'a3' 's1' 's2' 's3' 's4' 'dim032' 'unbalance'};
% clusterSizes = [ 20   35   50   15   15   15   15   16       8];
%  datasetSizes = [3000 5250 7500 5000 5000 5000 5000 1024     6500];


datasets =     {'a2' 'a3' 's4' };
clusterSizes = [ 35   50   15 ];
datasetSizes = [5250 7500 5000];
nRepeat = 100;
maxSwaps = 2000;
kmeansIterationLimit = 2;

nDatasets = size(datasets, 2);

%%% totalSqError, swaps, time, ci, success
results = zeros(nDatasets, 5);
tic;
for dID = 1:nDatasets
    dataset = datasets(dID)
    c = clock;
    disp(datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6))));
    nClusters = clusterSizes(dID);
    
    datasetResults = zeros(nRepeat, 5);
    parfor repeat = 1:nRepeat
       [error, swaps, time, ci] = testDataset(dataset, nClusters, maxSwaps, kmeansIterationLimit); 
       datasetResults(repeat, :) = [error swaps time ci (ci == 0)];
    end
    results(dID, 1:4) = mean(datasetResults(:, 1:4));
    results(dID, 5) = sum(datasetResults(:, 5)) / nRepeat; % success rate
end
totalTime = toc;