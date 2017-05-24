function drawSwap(data, c1, c2) 
    hold on;
    scatter(data(:, 1), data(:, 2), [], 'blue')
    scatter(c1(:, 1), c1(:, 2), 200, 'red', 'filled', 'd')
    scatter(c2(:, 1), c2(:, 2), 100, 'green', 'filled', 's')
end