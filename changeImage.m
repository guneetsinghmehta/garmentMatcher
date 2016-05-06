function[imOut]=changeImage(image,resolution)
    %Return a square image . resize the image to a size of resolution
    % pad the image with zeros which are not filled completely
%    image=image{1,1};
    [s1,s2,~]=size(image);
    maxDim=max(s1,s2);
    s1Final=floor(s1/maxDim*resolution);
    s2Final=floor(s2/maxDim*resolution);
    imOut=imresize(image,[s1Final s2Final]);
    %figure;imshow(imOut);
    
    imOut=padarray(imOut,[floor((resolution-s1Final)/2),floor((resolution-s2Final)/2)],'replicate');
    %figure;imshow(imOut);
    
    imOut=padarray(imOut,[resolution-size(imOut,1),resolution-size(imOut,2)],'post');
end