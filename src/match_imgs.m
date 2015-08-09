%% match_imgs: Match images
function similarity = match_imgs(imgs, order)
    img_num = numel(imgs);
    high_imgs = cell(img_num, 1);
    similarity = eye(img_num);

    for k = 1:img_num
        high_imgs{k} = highpass_img(imgs{k}, order);
    end

    for k1 = 1:img_num-1
        for k2 = k1+1:img_num
            corr = max(max(normxcorr2(high_imgs{k1}, high_imgs{k2})));
            similarity(k1, k2) = corr;
            similarity(k2, k1) = corr;
        end
    end
