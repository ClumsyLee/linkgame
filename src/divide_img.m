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

    index = find_baseband_index(f_domain);  % Find the baseband.

    period = round(1 / f(index));
    phase_pixel = round(angle(f_domain(index)) / (2 * pi * f(index)));
    if phase_pixel <= 0
        blank = -phase_pixel;
    else
        blank = period - phase_pixel;
    end

    % figure
    % plot(f, abs(f_domain));

    % figure
    % hold on
    % plot(hline);
    % plot(max(abs(hline)) / 2 * cos(2 * pi / period * ([0:len-1] - blank)));
end

%% find_baseband_index: Find the index of the baseband
function baseband = find_baseband_index(f_domain)
    f = abs(f_domain);
    [max_wight, max_band] = max(f);

    %% Find base band.
    baseband = max_band;
    for ratio = [2, 3, 4]
        band = (max_band - 1) / ratio + 1;
        [maximum, index] = max_around(f, band, 0.05);
        if maximum > 0.8 * max_wight
            baseband = index;
        end
    end
end

%% max_around: Find maximum around a index.
function [maximum, index] = max_around(x, index, error_ratio)
    from = ceil(index *  (1 - error_ratio));
    to   = floor(index * (1 + error_ratio));
    [maximum, index] = max(x(from:to));
    index = index + from - 1;
end
