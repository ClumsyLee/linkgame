function bool = detect(mtx, x1, y1, x2, y2)
    % ========================== 参数说明 ==========================

    % 输入参数中，mtx为图像块的矩阵，类似这样的格式：
    % [ 1 2 3;
    %   0 2 1;
    %   3 0 0 ]
    % 相同的数字代表相同的图案，0代表此处没有块。
    % 可以用[m, n] = size(mtx)获取行数和列数。
    % (x1, y1)与（x2, y2）为需判断的两块的下标，即判断mtx(x1, y1)与mtx(x2, y2)
    % 是否可以消去。

    % 注意mtx矩阵与游戏区域的图像不是位置对应关系。下标(x1, y1)在连连看界面中
    % 代表的是以左下角为原点建立坐标系，x轴方向第x1个，y轴方向第y1个

    % 输出参数bool = 1表示可以消去，bool = 0表示不能消去。

    %% 在下面添加你的代码O(∩_∩)O
    bool = mtx(x1, y1) == mtx(x2, y2) && ...
           (zero_turn(mtx, x1, y1, x2, y2) || ...
            one_turn(mtx, x1, y1, x2, y2) || ...
            two_turns(mtx, x1, y1, x2, y2));
end

%% zero_turn: Judge whether two blocks have only spaces in between.
function bool = zero_turn(mtx, x1, y1, x2, y2)
    left = min(x1, x2);
    right = max(x1, x2);
    down = min(y1, y2);
    up = max(y1, y2);

    bool = (x1 == x2 && all(mtx(x1, down+1:up-1) == 0) || ...
            y1 == y2 && all(mtx(left+1:right-1, y1) == 0));
end

%% one_turn: Judge whether two blocks can be linked in one turn.
function bool = one_turn(mtx, x1, y1, x2, y2)
    bool = (zero_turn(mtx, x1, y1, x2, y1) && ...
            zero_turn(mtx, x2, y1, x2, y2) && ...
            mtx(x2, y1) == 0 || ...
            zero_turn(mtx, x1, y1, x1, y2) && ...
            zero_turn(mtx, x1, y2, x2, y2) && ...
            mtx(x1, y2) == 0);
end

%% two_turns: Assuming not zero or one turn.
function bool = two_turns(mtx, x1, y1, x2, y2)
    % Pad the matrix for the possible links.
    mtx = padarray(mtx, [1, 1]);
    x1 = x1 + 1;
    y1 = y1 + 1;
    x2 = x2 + 1;
    y2 = y2 + 1;

    direction = [ 0  1
                  0 -1
                  1  0
                 -1  0];

    for k = 1:4
        delta = direction(k, :);
        pos = [x1 y1] + delta;

        % Toward if possible.
        while all(pos > [0 0] & pos <= size(mtx)) && mtx(pos(1), pos(2)) == 0
            if one_turn(mtx, pos(1), pos(2), x2, y2)
                bool = 1;
                return
            end
            pos = pos + delta;
        end
    end

    bool = 0;
end
