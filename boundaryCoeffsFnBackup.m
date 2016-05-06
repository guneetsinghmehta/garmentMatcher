function[fftCoeffs]=boundaryCoeffsFnBackup(image,mask3D)
    %input - image is 3D, mask3D is 3D
    %output - normalized fft coeffs magnitude
    %find 500(n) points using normalize boundary
    %z=x+yi - convert
%     1 subtract the mean of x and mean of y - not center of object
%     2 find dft using fft
%     3 find the absolute values of fft
%     4 divide by the first element - to make scale invariant
%     5 first element - DC component - discard this - translation invariant
%     6 discard high frequencies - say 100 onwards
%     7 to make reflection invariant - just reverse the direction of traversal -
%     in effect compare with the reversed conjugate of the original - also 
%     compare with reverse conjugate and output the minimum distance
%     
%     8 ***CAUTION - to make rotation invariant - remove the imaginary part of the
%     fft just after taking the fft***
%     9 similarity score function - on a scale of 0 to 1
%     
%     Tests
%     1. Same image
%     2. Image of two t shirts
%     3. one shirt one t shirt
%     4. one shirt and one trouser
    
    fftCoeffs=0;
    mask=mask3D(:,:,1);
    % define the number of points on each boundary
    n=500;

    % find the boundary
    boundary=bwboundaries(mask);
    if(size(boundary,1)>1||size(boundary,2)>1),error('more than one boundary. check mask');return ;end
    boundary=boundary{1,1};
    
    % find points on the boundary s1, s2=n-s1
    [x,y]=normalizeBoundary(boundary,n);
    display(1);
    figure;imshow(image);hold on;
    plot(y,x,'*');
    % interpolate the points both in x and y to find xNew and yNew
    %now xNew and yNew both have n points
    
    %find centorid of the shirt
    label=bwlabel(mask);
    stat=regionprops(label,'centroid');
    xc=stat.Centroid(1);
    yc=stat.Centroid(2);
    % define z=(x-xc)+i(y-yc)
    z=(x-xc)+(y-yc)*1i;
    
    %find fft of z
    zfft=fft(z);
    display(1);
    % remove the first component - translation invariant
    %remove higher freq components - removes noise
end

function[x,y]=normalizeBoundary(boundary,n)
%Finds a boundary containing n points. If the boundary has less than n
%points then interpolation is done.
%If boundary has more than n points then the other points are thrown
    s1=size(boundary,1);s2=n-s1;
    x=zeros(1,n);
    y=zeros(1,n);
    if(s2==0)
        x=boundary(:,1);
        y=boundary(:,2);
    elseif(s2<0)
       %more points than needed - need to downsample
       %Checked - working
       a=1;b=s1;%here s1>n
       diff=(b-a)/n;  
       for i=1:n
           index=a+(i-1)*diff;
           index=floor(index);
           x(i)=boundary(index,1);
           y(i)=boundary(index,2);
       end
    elseif(s2>0)
        queryIndices=indices(boundary(:,1),n);%have size s2
        x1=boundary(:,1);
        x2=floor(interp1(1:s1,x1,queryIndices));
        y1=boundary(:,2);
        y2=floor(interp1(1:s1,y1,queryIndices));
        
        index=1;p=1;
        for i=1:s1
            x(index)=x1(i);
            index=index+1;
            if(queryIndices(p)==i)
               x(index)=x2(p);
               p=p+1;
               index=index+1;
            end
        end
        
        index=1;p=1;
        for i=1:s1
            y(index)=y1(i);
            index=index+1;
            if(queryIndices(p)==i)
               y(index)=y2(p);
               p=p+1;
               index=index+1;
            end
        end
        display(1);
    end
end

function[x2]=indices(x,n)
     s1=size(x,1);s2=n-s1;
     x2=zeros([1,s2]);
    for i=1:s2
       x2(i)=i*s1/s2;
    end
end

%  
%     x=x-mean(x);%Makes it translation invariant
%     y=y-mean(y);
%     z=x+y*(1i);
%     zMaxAmp=max(abs(z));
%     z=z/zMaxAmp; %Makes it scale invariant
%     
%     Zfft=fft(z);
