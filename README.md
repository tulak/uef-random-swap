## Random swap clustering algorithm implementation 
The main implementation is in file `randomSwap.m` it uses fast kmeans implementation from file `ownKmeans.m`. One can provide own distance function to be used with the algorithm. The default euclidean distance is implemented in `euclideanDistance.m`

### Usage


```matlab
[partitions, cenroids, tsa, swaps, time] = randomSwap(data, ...             % data matrix where row represnts a vector
                                                      nClusters, ...        % number of clusters
                                                      swaps, ...            % number of random swap iterations to perform
                                                      kmeansIterations, ... % number of iterations to use with kmeans
                                                      distanceFn            % distance function (default: euclideadnDistance)
                                                      )
```
