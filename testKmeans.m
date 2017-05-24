function testKmeans( datasetName, nClusters )
    tic;
    data = load(['datasets/' char(datasetName) '.txt']);
    gths = load(['datasets/' char(datasetName) '_gt.txt']);

    [nVectors, nFeatures] = size(data);
    centroids = zeros(nClusters, nFeatures);
    for c = 1:nClusters
        random_index = randi([1 nVectors]);
        centroids(c, :) = data(random_index, :);
    end

    [ clusterLabels, clusterCentroids, totalSquaredError, iterations] = ownKmeans(data, centroids, @euclideanDistance, Inf);
    ci = CI(gths, clusterCentroids);
    
    ci
    totalSquaredError
    iterations
    toc
    
    drawResult(data,clusterCentroids);
end

