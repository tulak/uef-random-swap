% Author: Filip Zachar (2017)

function [retPartitions, retCentroids, retError, acceptedSwaps, elapsedTime] = randomSwap(data, nClusters, swaps, kmeansIterationLimit, distanceFn)
    % type of 'data' input variable is matrix in which rows represent
    % vectors and columns represent dimensions (features)
    global pry;
    pry = 0;
    tic; % Start the stopwatch
    
    %%% Set default number of trial swaps
    if ~exist('swaps', 'var'), swaps = 30; end
    %%% Set default distance function
    if ~exist('distanceFn', 'var'), distanceFn = @euclideanDistance; end
    %%% Set default kmeans iteration limit to 2
    if ~exist('kmeansIterationLimit', 'var'), kmeansIterationLimit = 2; end
    
    [nVectors, nFeatures] = size(data);
    
    %%% Initial centroid selection method
    centroids = randomCentroids(data, nClusters);
    % centroids = randomSyntheticCentroids(data, nClusters);    
    % centroids = randomClusterCentroids(data, nClusters);   
    
    acceptedSwaps = 0;
    [partitions, centroids, error, iterations, kData] = ownKmeans(data, centroids, distanceFn, 2);
    
    for swapN = 1:swaps
       originalCentroids = kData.centroids;
       originalStaticCentroidsmap = kData.staticCentroidsMap;

       swappedkData = swapCentroids(kData); 
       kData = swappedkData;
       
       [newPartitions, newCentroids, newError, newIterations, newkData] = ownKmeans(kData);

       if newError < error
          partitions = newPartitions;
          centroids = newCentroids;
          error = newError;
          kData = newkData;
          
          acceptedSwaps = acceptedSwaps + 1;
       else
           kData.centroids = originalCentroids;
           kData.staticCentroidsMap = originalStaticCentroidsmap;
       end
    end
    
    retPartitions = partitions;
    retCentroids = centroids;
    retError = error;
    elapsedTime = toc;
end

%%
function [RkData] = swapCentroids(kData)
    % random centroid that is gonna be swapped
    sacrificeID = randi(kData.nClusters);
    kData.staticCentroidsMap(sacrificeID) = 0;
    
    newCentroid = randomCentroids(kData.data, 1);
    kData.centroids(sacrificeID, :) = newCentroid;
    RkData = kData;
end

%%
% selects random data vectors as centroids
function [ centroids ] = randomCentroids( data, nClusters)
    [nVectors, nFeatures] = size(data);
    
    centroids = zeros(nClusters, nFeatures);
    for c = 1:nClusters
        random_index = randi([1 nVectors]);
        centroids(c, :) = data(random_index, :);
    end
end

%%
% generates random centroids in the features range (min, max)
function [ centroids ] = randomSyntheticCentroids( data, nClusters)
    [nVectors, nFeatures] = size(data);
   
    centroids = zeros(nClusters, nFeatures);
    maxs = max(data);
    mins = min(data);
    
    for cid = 1:nClusters
        for fid = 1:nFeatures
           centroids(cid, fid) = randi([mins(fid), maxs(fid)]);
        end
    end
end

%% 
% assigns vercors randomly to the clusters and calculates centroids of these
% clusters
function [ centroids ] = randomClusterCentroids( data, nClusters)
    [nVectors, nFeatures] = size(data);
    assignments = zeros(nVectors,1);
    centroids = zeros(nClusters, nFeatures);
    
    % Assign randomly to clusters
    for vid = 1:nVectors
       assignments(vid) = randi([1, nClusters]);
    end
    
    for cid = 1:nClusters
        cluster_vectors = data(assignments == cid, :);
        centroids(cid, :) = mean(cluster_vectors);
    end
end
