%% sim_play: Simulate auto-playing.
function sim_play(img, ground)
    WIDTH = 5;

    [blocks, h_period, h_blank, v_period, v_blank] = divide_img(img);
    block_size = [v_period, h_period];
    blank = [v_blank, h_blank];

    steps = omg(ground);

    row = (1:size(img, 1))';
    col = 1:size(img, 2);

    for k = 2:4:length(steps)
        x(1) = steps(k);
        y(1) = steps(k + 1);
        x(2) = steps(k + 2);
        y(2) = steps(k + 3);

        % Indicate that two blocks.
        subplot(2, 5, 5)
        imshow(blocks{x(1), y(1)});
        subplot(2, 5, 10)
        imshow(blocks{x(2), y(2)});

        mask = logical(zeros(size(img)));

        for k = [1 2]
            ul = blank + [x(k) - 1, y(k) - 1] .* block_size + [1 1];
            lr = blank + [x(k), y(k)] .* block_size;

            row_range = (row >= ul(1) & row <= lr(1));
            col_range = (col >= ul(2) & col <= lr(2));
            row_bound = row_range & (row - ul(1) < WIDTH | ...
                                     lr(1) - row < WIDTH);
            col_bound = col_range & (col - ul(2) < WIDTH | ...
                                     lr(2) - col < WIDTH);

            frame = bsxfun(@and, row_bound, col_range) | ...
                    bsxfun(@and, col_bound, row_range);
            mask = mask | bsxfun(@and, row_range, col_range);

            img(frame) = 128;
        end

        subplot(2, 5, [1, 9])
        imshow(img)
        pause(0.5)
        img(mask) = 0;
    end
    imshow(img)  % Show last frame.
