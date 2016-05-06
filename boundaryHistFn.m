function[distance]=boundaryHistFn(hist1,hist2)
    a=sqrt(sum(hist1(:).*hist1(:)));
    b=sqrt(sum(hist2(:).*hist2(:)));
    distance=sum(hist1(:).*hist2(:))/(a*b);
    distance=1-distance;%coz distance =1 if hist1==hist2
end