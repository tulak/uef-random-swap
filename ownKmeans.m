% Author: Filip Zachar (2017)

function [ clusterLabels, clusterCentroids, totalSquaredError, iterations, kData ] = ownKmeans(data, centroids, distanceFn, maxIterations)
    if isstruct(data)
      kData = data;
    else        
        [nVectors, nFeatures] = size(data);
        nClusters = size(centroids, 1);

        % set all vectors to active state if not staticCentroidMap is provided
        staticCentroidsMap = zeros(nClusters, 1);

        % Array to store distance of a vector to the closest centroid
        minDistances = repmat(Inf,nVectors, 1);

        partitions = zeros(nVectors, 1);

        kData = struct(...
            'nClusters', nClusters, ...
            'nVectors', nVectors, ...
            'data', data, ...
            'centroids', centroids, ...
            'partitions', partitions, ...
            'distanceFn', distanceFn, ...
            'staticCentroidsMap', staticCentroidsMap, ...
            'minDistances', minDistances ...
        );
    end
    
    partitions_old = kData.partitions;
    

    % data is matrix in which row is feature vector
    if ~exist('maxIterations', 'var'), maxIterations = inf; end
    iterations = 0;
    while ~isequal(kData.partitions, partitions_old) || iterations == 0
        iterations = iterations + 1;
        partitions_old = kData.partitions;
        
        kData = repartition(kData);
        kData = calculateCentroids(kData);
        
        if iterations >= maxIterations
            break;
        end
    end

    clusterLabels = kData.partitions;
    clusterCentroids = kData.centroids;
    totalSquaredError = calculateTotalSquaredError(kData);
end

%%
% returns partition map of vectors based on given centroids
function [kData] = repartition(kData)
    for vID = 1:kData.nVectors
        vector = kData.data(vID, :);
        currentCentroid = kData.partitions(vID);
        distances = repmat(Inf, kData.nClusters, 1);
        
        currentCentroidID = kData.partitions(vID);
        if currentCentroidID && kData.staticCentroidsMap(currentCentroidID)
            distances(currentCentroidID) =  kData.minDistances(vID);
        end
        
        for cID = 1:kData.nClusters
            if kData.staticCentroidsMap(cID) == 0 || kData.staticCentroidsMap(currentCentroid) == 0
                centroid = kData.centroids(cID, :);
                distances(cID) = kData.distanceFn(centroid, vector); 
            end
        end
        
        [dist, cluster] = min(distances);
        
        kData.minDistances(vID) = dist;
        kData.partitions(vID) = cluster; 
    end
end

%%
function [kData] = calculateCentroids(kData)        
    for cID = 1:kData.nClusters
        cluster_vectors = kData.data(kData.partitions == cID, :);
        newCentroid = mean(cluster_vectors);
        if isequal(newCentroid, kData.centroids(cID, :))
            kData.staticCentroidsMap(cID) = 1;
        else
            kData.centroids(cID, :) = newCentroid;
        end
        
    end
end

%%
function [error] = calculateTotalSquaredError(kData)
    error = 0;
    for cID = 1:kData.nClusters
        centroid = kData.centroids(cID, :);
        cluster_vectors = kData.data(kData.partitions == cID, :);
        nClusterVectors = size(cluster_vectors, 1);
        
        for vID = 1:nClusterVectors
            vector = cluster_vectors(vID, :);
            error = error + kData.distanceFn(vector, centroid)^2;
        end
    end
end
