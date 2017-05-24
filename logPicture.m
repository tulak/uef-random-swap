function logPicture(name, kData )
    f = figure('Visible', 'off');
    drawResult(kData.data, kData.centroids);
    saveas(f, ['screens/' num2str(name) '.jpg'], 'jpg');
    close(f);


end

