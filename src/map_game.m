%% map_game: Map imgs into a game ground.
function [ground, legends] = map_game(imgs, matches, values, ...
                                      accept_threshold, combine_threshold)
    ground = zeros(size(imgs));

    kind_num = 1;

    % Accpet all close matches.
    % last_close = find(values < accept_threshold) - 1;
    last_close = length(matches);
    for k = 1:last_close
        match = matches(k, :);
        kinds = ground(match);
        if kinds == 0  % New kind.
            figure
            subplot 121
            imshow(imgs{match(1)});
            title(kind_num);
            subplot 122
            imshow(imgs{match(2)});

            ground(match) = kind_num;
            legends{kind_num} = imgs{match(1)};
            kind_num = kind_num + 1;
        % elseif any(kinds == 0)  % Old kind, one not classified.
        %     ground(match) = max(kinds);
        % elseif kinds(1) ~= kinds(2)  % Old kind & close, combine.
        %     ground(ground == kinds(2)) = kinds(1);
        end  % Else already the same.
    end
