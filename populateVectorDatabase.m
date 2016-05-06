function[vectorDatabase,gaborArray]=populateVectorDatabase(filenames,scaleDownFactor)
    % Input- imageNames as cell array
    % scale down the image by the factor
    if ~isequal(exist('vl_sift'), 3)
        sift_lib_dir = fullfile('sift_lib', ['mex' lower(computer)]);
        orig_path = addpath(sift_lib_dir);
        temp = onCleanup(@()path(orig_path));
    end
    
    vectorDatabase=cell([size(filenames,2) 1]);
    filterSx=11;
    filterSy=11;
    scales=9;
    orientations=9;
    gaborArray = gaborFilterBank(scales,orientations,filterSx,filterSy);
    
    display(filenames);
    resolution=200;%size to which all images are reduced maintaining the aspect ratio
    for i=1:size(filenames,2)
        
        fprintf('%d %s\n',i,filenames{1,i});
        %reading and extracting the template images
        image=imread(filenames{1,i});
        %image=image(1:scaleDownFactor:end,1:scaleDownFactor:end,:);
        image=changeImage(image,resolution);
        
        mask=getMask(image);
       
        % find Sift features
%        gray_s=rgb2gray(im2single(image));
%         [Fs, Ds] = vl_sift(gray_s);
        Fs=0;Ds=0;

        colorInfo=colorInfoFn(image,mask);
        
        %detect patterns in R,G and B - right now in grayscale
        patternVector=patternVectorFn(image,mask,gaborArray);
        
        %findingBoundaryCoeffs
        prop=boundaryCoeffsFn(image,mask);
        boundaryHist=getShapeHist(prop);
        
        %populate the features
        vectorDatabase{i}.filename=filenames{1,i};
        vectorDatabase{i}.Fs=Fs;
        vectorDatabase{i}.Ds=Ds;
        vectorDatabase{i}.colorInfo=colorInfo;
        vectorDatabase{i}.patternVector=patternVector;% Not being used
        vectorDatabase{i}.boundaryHist=boundaryHist;% Not being used 
    end
end

