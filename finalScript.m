function[]=finalScript()
    %Adding Sift Library
   if ~isequal(exist('vl_sift'), 3)
        sift_lib_dir = fullfile('sift_lib', ['mex' lower(computer)]);
        orig_path = addpath(sift_lib_dir);
        temp = onCleanup(@()path(orig_path));
    end
    

    filenames={'polo1.jpg','polo2.jpg','polo3.jpg','polo4.jpg','polo5.jpg','polo6.jpeg'};
    scaleDownFactor=1;
    vectorDatabase=populateVectorDatabase(filenames,scaleDownFactor);
    display(vectorDatabase);
    
    %shiftedImage contains one image - shifted and rotated. 
    %queryMatch - returns the name of the matching file
    transformedImage=imread(filenames{1,1});
    transformedImage=transformedImage(4:scaleDownFactor:end,4:scaleDownFactor:end,:);
    transformedImage=imrotate(transformedImage,180);
    maskTemp=getMask(transformedImage);
    transformedImage=transformedImage.*uint8(maskTemp);
    imwrite(transformedImage,'query.tif');
    queryMatchResult=queryMatch(vectorDatabase,'query.tif');
%     queryMatchResult=queryMatch(vectorDatabase,'polo7.jpg');
    display(queryMatchResult);
    
    %showing results
    figure;
    subplot(1,2,1);imshow(imread('query.tif'));title('query');
    subplot(1,2,2);imshow(imread(queryMatchResult));title('closest match');
    
end

function[vectorDatabase]=populateVectorDatabase(filenames,scaleDownFactor)
    % Input- imageNames as cell array
    % scale down the image by the factor
    
    vectorDatabase=cell([size(filenames,2) 1]);
    for i=1:size(filenames,2)
        %reading and extracting the template images
        image=imread(filenames{1,i});
        image=image(1:scaleDownFactor:end,1:scaleDownFactor:end,:);
        mask=getMask(image);
        image=image.*uint8(mask);
        figure;imshow(image);title(filenames{1,i});
        
        % find Sift features
        gray_s=rgb2gray(im2single(image));
        [Fs, Ds] = vl_sift(gray_s);
        %dominant color
        [dominantColor,dominant3ColorRatio]=dominantColorFn(image,mask);
        
        %populate the features
        vectorDatabase{i}.filename=filenames{1,i};
        vectorDatabase{i}.Fs=Fs;
        vectorDatabase{i}.Ds=Ds;
        vectorDatabase{i}.dominantColor=dominantColor;
        vectorDatabase{i}.dominant3ColorRatio=dominant3ColorRatio;
    end
   
end

