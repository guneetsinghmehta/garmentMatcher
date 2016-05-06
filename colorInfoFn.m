function[colorAccumulator]=colorInfoFn(image,mask)
    %colorInfo is a N+1 cross N+1 array containing information about the colors in a a* B* space
    %inputs - image and mask , both 3 D arrays
    
    %Parameter 
    N = 10;
    Nbright=7;

    % conver image to CIELAB space.
    mask=uint8(mask);
    rgb=image.*mask;
    lab = applycform(rgb, makecform('srgb2lab'));
    lab = lab2double(lab);
    
    % separate a and b channel, throw the L channel - brightness values
    L = lab(:,:,1);
    a = lab(:,:,2);
    b = lab(:,:,3);
    bin_centers = linspace(-100, 100, N);
    bin_centers2 = linspace(-100, 100, Nbright);
    subscripts = 1:N;
    subscripts2 = 1:Nbright;
    Li = interp1(bin_centers2, subscripts2, L, 'linear', 'extrap');
    ai = interp1(bin_centers, subscripts, a, 'linear', 'extrap');
    bi = interp1(bin_centers, subscripts, b, 'linear', 'extrap');
    Li = round(Li);
    ai = round(ai);
    bi = round(bi);

    Li = max(min(Li, Nbright), 1);
    ai = max(min(ai, N), 1);
    bi = max(min(bi, N), 1);
    H = accumarray([bi(:), ai(:),Li(:)], 1, [N N Nbright]);
    colorAccumulator=H;
    %Removing the black portion in accumulator
    colorAccumulator(1+floor(N/2),1+floor(N/2),1+floor(Nbright/2))=0;
    
    %Normalizing accumulator
    temp=mask(:,:,1);
    colorAccumulator=colorAccumulator/sum(temp(:));
    % return the accumulator which is a N+1 cross N+1 array
    
    %uncomment below to see the returned accumulator
    xdata = [min(bin_centers), max(bin_centers)];
    ydata = xdata;
%     figure;imshow(colorAccumulator,[0 1000], 'InitialMagnification', 300, 'XData', xdata, 'YData', ydata)
%     figure;imshow(rgb);    
%     figure;imagesc(colorAccumulator);colorbar;
%     axis on
%     xlabel('a*')
%     ylabel('b*')
end

