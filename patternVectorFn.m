function[patternVector]=patternVectorFn(image,mask,gaborArray)
    %We want to find the mean and standard deviation of the image to Gabor
    %filter with different frequencies and angles
    %output - returns patternVector containing
%     1 scales
%     2 orientations
%     3. mean value at each scale and orientation
%     4. std value at each scale and orientation
%     5. a u*v array of ones and zeros based on the filter response of
%     different filters
    %Caveats-
    %1. if shirt is slightly tilted then - stripes in horizontal direction
    %will change to stripes in say 30degre - Can live with this

    %Working - 
    %1 find GaborFilters
    %2 convolove with image center
    %3 find mean and standard deviation
    meanThresh=3;
    stdThresh=1.5;% seeing results of smooth,vert and horz.jpg
    
    %1 GaborFilters
    [u,v] = size(gaborArray);
    patternVector.scales=u;
    patternVector.orientations=v;
    %2 convolving the center of image -size of filterSx,filterSy
    mask2(:,:,1)=imerode(mask(:,:,1),strel('disk',10));%eroding the boundaries
    mask2=repmat(mask2,[1 1 3]);
    temp=bwdist(mask2(:,:,1));
    temp=1-5*temp/max(temp(:));
    temp(temp<0)=0;
    temp=repmat(temp,[1 1 3]);
    image=double(image);
    innerImage=image.*double(mask2);
    outerImage=image.*double(mask-mask2);
    finalImage=innerImage.*temp+outerImage.*temp;
    img=double(rgb2gray(uint8(finalImage)));
    
    vector=zeros(u,v);
    for i = 1:u
        for j = 1:v
            gaborResult = imfilter(img, gaborArray{i,j});
            gaborResult=mask2(:,:,1).*gaborResult;
            gaborResult=abs(gaborResult);
            kip=gaborResult(mask2(:,:,1)==1);
            meanVal=mean(kip);
            stdVal=std(kip);
            if(meanVal>meanThresh&&stdVal>stdThresh)
               vector(i,j)=1;
            end
%             if(i==3)
%                  figure;imagesc(gaborResult);colorbar;
%                  title(['mean=' num2str(meanVal) ' stdval=' num2str(stdVal) ' j=' num2str(j)]);
%                     fprintf('u=%d v=%d mean =%f std= %f %d\n',i,j,meanVal,stdVal,vector(i,j));
%             end
%             fprintf('u=%d v=%d mean =%f std= %f %d\n',i,j,meanVal,stdVal,vector(i,j));
            patternVector.mean{i,j}=meanVal;
            patternVector.std{i,j}=stdVal;
        end
%         fprintf('\n');
    end
    patternVector.vector=vector;
%     f2=figure;imshow(uint8(image));title(num2str(sum(vector(:))));
%     pause(3);
%     close(f2);
end