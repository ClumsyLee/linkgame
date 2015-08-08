%% divide_img: Divide image into blocks
function blocks = divide_img(img)
    [h_period, h_blank] = find_horizontal_period(img);
    [v_period, v_blank] = find_horizontal_period(img');

    blocks = cell(floor((size(img) - [v_blank h_blank]) ./ ...
                        [v_period h_period]));

    row_max = size(img, 1) - v_period + 1;
    col_max = size(img, 2) - h_period + 1;

    k = 1;
    blocks = blocks';
    for row = v_blank+1:v_period:row_max
        for col = h_blank+1:h_period:col_max
            blocks{k} = img(row:row+v_period-1, col:col+h_period-1);
            k = k + 1;
        end
    end
    blocks = blocks';
end

%% find_horizontal_period: Find
function [period, blank] = find_horizontal_period(img)
    % Remove AC component.
    hline = mean(double(img) - mean(mean(img)));

    len = length(hline);
    f = [0:len-1] / len;
    f_domain = fft(hline);
    [~, index] = max(abs(f_domain));

    period = round(1 / f(index));
    phase_pixel = round(angle(f_domain(index)) / (2 * pi * f(index)));
    if phase_pixel <= 0
        blank = -phase_pixel;
    else
        blank = period - phase_pixel;
    end

    figure
    plot(f, abs(f_domain));

    figure
    hold on
    plot(hline);
    plot(max(abs(hline)) / 2 * cos(2 * pi / period * ([0:len-1] - blank)));
end
