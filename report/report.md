# 连连看综合实验

* 无 36
* 李思涵
* 2013011187

## 原创性声明

此实验的代码 & 实验报告均为原创。


## 第一章 制作自己的连连看

### 1.1
### 1.2
### 1.3
### 1.4

## 第二章 攻克别人的连连看

### 2.1 对屏幕截图分块

```matlab
imgs_truth = divide_img(graycapture);
show_divided_img(imgs_truth);
```

![分块结果](divide_graygroundtruth.png)

### 2.2 对摄像头采集到的图像分块

```matlab
imgs = divide_img(graygroundtruth);
show_divided_img(imgs);
```

![分块结果](divide_graycapture.png)

### 2.3 计算分块相似性

为了使各个分块的纹理更加突出，我们先对每个分块进行高通滤波：

```matlab
%% highpass_img: Keep only the high-freq component of the img.
function high_freq_img = highpass_img(img, order)
    % Ensure an even order.
    if mod(order, 2)
        order = order + 1;
    end

    filter_1d = fir1(order, 0.5, 'high');
    filter_2d = zeros(order + 1);
    center = order / 2 + 1;

    for row = 1:order+1
        for col = 1:order+1
            r = round(sqrt((row - center)^2 + (col - center)^2));
            if r > center - 1
                value = 0;
            else
                value = filter_1d(center - r);
            end
            filter_2d(row, col) = value;
        end
    end

    high_freq_img = filter2(filter_2d, img);
```

然后对各对图像块之间进行匹配：

```matlab
%% match_imgs: Match images
function similarity = match_imgs(imgs, order, margin_ratio)
    img_num = numel(imgs);
    high_imgs = cell(img_num, 1);
    similarity = eye(img_num);

    margin = round(margin_ratio * size(imgs{1}));

    for k = 1:img_num
        high_imgs{k} = highpass_img(imgs{k}, order);
    end

    for k1 = 1:img_num-1
        for k2 = k1+1:img_num
            img1 = high_imgs{k1};
            img2 = high_imgs{k2};

            corr1 = max(max(normxcorr2(img1(1+margin(1):end-margin(1), ...
                                            1+margin(2):end-margin(2)), ...
                                       img2)));
            corr2 = max(max(normxcorr2(img2(1+margin(1):end-margin(1), ...
                                            1+margin(2):end-margin(2)), ...
                                       img1)));
            corr = max([corr1 corr2]);

            similarity(k1, k2) = corr;
            similarity(k2, k1) = corr;
        end
    end
```

对结果进行排序：

```matlab
%% sort_match: Sort matching result.
function [matches, values] = sort_match(similarity)
    img_num = length(similarity);

    % Remove useless elements.
    [values, index] = sort(similarity(:), 'descend');
    from = mod(index - 1, img_num) + 1;
    to = ceil(index / img_num);
    matches = [from to];

    values = values(from < to);
    matches = matches(from < to, :);
```

我们先将匹配结果存至变量中：

```matlab
sim = match_imgs(imgs, 20, 0.2);
[matches, values] = sort_match(sim);
```

同时，我们编写函数展示匹配结果：

```matlab
%% show_matches: Show matches in two columns.
function show_matches(imgs, matches, values)
    row = length(matches);

    for k = 1:row
        match = matches(k, :);

        subplot(row, 2, 2 * k - 1);
        imshow(imgs{match(1)});
        title(['Block ' num2str(match(1))]);
        ylabel(values(k))

        subplot(row, 2, 2 * k);
        imshow(imgs{match(2)});
        title(['Block ' num2str(match(2))]);
    end
```

然后我们显示相似度最大的十对图像块：

```matlab
match_range = 1:10;
show_matches(imgs, matches(match_range, :), values(match_range));
```

![相似度最大的十对图像块](10_matches.png)

可以看到，这十对图片确实是正确匹配的。

### 2.4 找到前十误匹配

通过人工查找，将相似度最大的前十误匹配显示出来：

```matlab
match_range = [181 183:191];
show_matches(imgs, matches(match_range, :), values(match_range));
```

![相似度最大的十对误匹配图像块](10_mismatches.png)

### 2.5
### 2.6
### 2.7
### 2.8
