% Author: Filip Zachar (2017)

function [Rerror, Rswaps, Rtime, Rci] = testDataset(datasetName, nClusters, maxSwaps, kmeansIterationLimit)
    data = load(['datasets/' char(datasetName) '.txt']);
    gths = load(['datasets/' char(datasetName) '_gt.txt']);
    
    [labels, centroids, error, swaps, time] = randomSwap(data, nClusters, maxSwaps, kmeansIterationLimit);
    Rci = CI(gths, centroids);
    Rerror = error;
    Rswaps = swaps;
    Rtime = time;
    
    drawResult(data,centroids);
end