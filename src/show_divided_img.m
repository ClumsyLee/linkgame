%% show_divided_img: Show divided image
function show_divided_img(blocks)
    [row, col] = size(blocks);
    blocks = blocks';

    for k = 1:numel(blocks)
        subplot(row, col, k);
        imshow(blocks{k});
    end
