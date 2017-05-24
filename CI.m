% Author: Filip Zachar (2017)

function [ centroidIndex ] = CI( gths, centroids )
% gths - ground thruth data
% centroids - the centroids from the solution
% - both matrices as a collection of row vectors
nCentroids = size(centroids,1);
nGths = size(gths, 1);

mapCentroid = zeros(nCentroids, 1);
mapGth = zeros(nGths, 1);

%% Map centroids to ground truth
for cid = 1:nCentroids
    lengths = zeros(nGths,1);
    
    for gid = 1:nGths
        lengths(gid) = norm(centroids(cid, :) - gths(gid, :));
    end
    
    [length, gid] = min(lengths);
    mapCentroid(cid) = gid;
end

%% Map ground truth to centroids
for gid = 1:nGths
    lengths = zeros(nCentroids,1);
    
    for cid = 1:nCentroids
        lengths(cid) = norm(centroids(cid, :) - gths(gid, :));
    end
    
    [length, cid] = min(lengths);
    mapGth(gid) = cid;
    
end

%% Caculate the # of ophrams
% # of gths that are ophrams
centroidOphrams = abs(size(unique(mapGth), 1) - nCentroids);
% # of centroids that are ophrams
gthOphrams = abs(size(unique(mapCentroid), 1) - nGths);

centroidIndex = max(centroidOphrams, gthOphrams);


end

%%
