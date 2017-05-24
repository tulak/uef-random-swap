function drawResult(data, centroids) 
    hold on;
    scatter(data(:, 1), data(:, 2), [], 'blue')
    scatter(centroids(:, 1), centroids(:, 2), 200, 'red', 'filled', 'd')
end