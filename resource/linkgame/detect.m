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

    [row, col] = size(mtx);
    bool = 0;

    % Zero turn.
    if spaces_in_between(mtx, x1, y1, x2, y2)
        bool = 1;
    end

    % One turn.
    if spaces_in_between(mtx, x1, y1, x2, y1) && ...
       spaces_in_between(mtx, x2, y1, x2, y2) && ...
       mtx(x2, y1) == 0 || ...
       spaces_in_between(mtx, x1, y1, x1, y2) && ...
       spaces_in_between(mtx, x1, y2, x2, y2) && ...
       mtx(x1, y2) == 0
        bool = 1;
    end

end

%% spaces_in_between: Judge whether two blocks have only spaces in between.
function bool = spaces_in_between(mtx, x1, y1, x2, y2)
    left = min(x1, x2);
    right = max(x1, x2);
    down = min(y1, y2);
    up = max(y1, y2);

    bool = (x1 == x2 && all(mtx(x1, down+1:up-1) == 0) || ...
            y1 == y2 && all(mtx(left+1:right-1, y1) == 0));
end


