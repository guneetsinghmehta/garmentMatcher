function[mask]=getMask(image)
%returns a 3 channel mask for a shirt image in catalogue image
% not for finding mask of torso in a wild image
    se=strel('disk',6);
    border=20;
    gray=rgb2gray(image);
    gray=padarray(gray,[border border],uint8(255));
    mask=edge(gray,'canny');
    mask=imdilate(mask,se);
    mask=imfill(mask,'holes');
    %fill holes - why ?
    mask=imerode(mask,se);
    mask=mask(border+1:end-border,border+1:end-border,:);
    mask=repmat(mask,[1 1 3]);
end