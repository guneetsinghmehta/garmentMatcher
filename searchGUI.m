function[]=searchGUI()
    %make a figure
    set(0,'DefaultFigureWindowStyle','normal');
    searchGUI=figure;
    set(0,'DefaultFigureWindowStyle','docked');
     SSize = get(0,'screensize');SW = SSize(3); SH = SSize(4);       %SW - width of screen, SH - Height of screen
    set(searchGUI,'Resize','on','Units','pixels','Position',[50 50 round(SW/5) round(SH*0.5)],'Visible','on','MenuBar','none','name','control GUI','NumberTitle','off');    
    imageFigure=figure;
    queryFigure=figure;
    distanceFigure=figure;
    table=uitable(distanceFigure,'Data',[],'Units','normal','Position',[0 0 1 1]);
    set(imageFigure,'NumberTitle','off','Menubar','none','name','Image Results');
    set(queryFigure,'NumberTitle','off','Menubar','none','name','Query Image');
    set(distanceFigure,'NumberTitle','off','Menubar','none','name','Distance Results');
    global gaborArray vectorDatabase closestImageNumber weights;
    global queryVector;
    queryVector.Fs=[];queryVector.Ds=[];
    queryVector.colorInfo=[];
    queryVector.boundaryHist=[];
    queryVector.patternVector=[];
    global queryFilename;
    closestImageNumber =3;
    weights=[ 10 10 10 1]; % boundary color pattern sift(not used)
    numRows=3;
    resolution=200;
    
    %add two buttons - train and select query image
    train_box=uicontrol('Parent',searchGUI,'Style','Pushbutton','Units','normalized','Position',[0.05 0.8 0.35 0.15],'String','Train','Callback',@trainFn,'TooltipString','Press to train the model');
    query_box=uicontrol('Parent',searchGUI,'Style','Pushbutton','Units','normalized','Position',[0.05 0.6 0.35 0.15],'String','Load Image','Callback',@queryFn,'TooltipString','Press to search images');
    crop_box=uicontrol('Parent',searchGUI,'Style','Pushbutton','Units','normalized','Position',[0.05 0.4 0.35 0.15],'String','Crop','Callback',@cropFn);
    graphCut_box=uicontrol('Parent',searchGUI,'Style','Pushbutton','Units','normalized','Position',[0.05 0.2 0.35 0.15],'String','GraphCut','Callback',@graphCutFn);
    reset_box=uicontrol('Parent',searchGUI,'Style','Pushbutton','Units','normalized','Position',[0.05 0.0 0.35 0.15],'String','Reset','Callback',@resetFn);
    
    closestImageNumber_text=uicontrol('Parent',searchGUI,'Style','text','Units','normalized','Position',[0.5 0.85 0.35 0.05],'String','#Results');
    closestImageNumber_box=uicontrol('Parent',searchGUI,'Style','slider','Units','normalized','Position',[0.5 0.8 0.35 0.05],'Value',closestImageNumber,'Callback',@changeFn,'Min',1,'Max',12,'SliderStep',[1 3]);
    w1_box=uicontrol('Parent',searchGUI,'Style','text','Units','normalized','Position',[0.5 0.65 0.35 0.05],'String','Shape');
    w1_box=uicontrol('Parent',searchGUI,'Style','slider','Units','normalized','Position',[0.5 0.6 0.35 0.05],'Value',weights(1),'Callback',@changeFn,'Min',0,'Max',10,'SliderStep',[0.1 0.5]);
    w2_box=uicontrol('Parent',searchGUI,'Style','text','Units','normalized','Position',[0.5 0.45 0.35 0.05],'String','Color');
    w2_box=uicontrol('Parent',searchGUI,'Style','slider','Units','normalized','Position',[0.5 0.4 0.35 0.05],'Value',weights(2),'Callback',@changeFn,'Min',0,'Max',10,'SliderStep',[0.1 0.5]);
    w3_box=uicontrol('Parent',searchGUI,'Style','text','Units','normalized','Position',[0.5 0.25 0.35 0.05],'String','Pattern');
    w3_box=uicontrol('Parent',searchGUI,'Style','slider','Units','normalized','Position',[0.5 0.2 0.35 0.05],'Value',weights(3),'Callback',@changeFn,'Min',0,'Max',10,'SliderStep',[0.1 0.5]);
%     w4_box=uicontrol('Parent',searchGUI,'Style','text','Units','normalized','Position',[0.5 0.05 0.35 0.05],'String','Sift(NW)','Visible','off');
%     w4_box=uicontrol('Parent',searchGUI,'Style','slider','Units','normalized','Position',[0.5 0.0 0.35 0.05],'Value',weights(4),'Callback',@changeFn,'Min',0,'Max',10,'SliderStep',[0.1 0.5],'Visible','off');
    if(exist('Training.mat','file')~=0)
        load('Training.mat');
    end
    
    %open figure, show the query image
    
    %Add buttons for each feature
    %Get a vector from query - global
    %Make a listening function - using weights,closestImageNumber and the
    %query vector which plots new images every time 
    % Add button for graphCut.
    %Make one GUI
    
    function graphCutFn(~,~)
       addpath(pwd,'GraphCut')
       waitfor(GC_GUI);
       set(0,'DefaultFigureWindowStyle','docked');
       queryFilename='cropped.tif';
       queryMatch(vectorDatabase,queryFilename,closestImageNumber,gaborArray);
       changeFn(0,0);
    end
    
    function trainFn(~,~)
        set(train_box,'Enable','off');
        list=dir('Training');
%         filenames={'polo1.jpg','polo2.jpg','polo3.jpg','polo4.jpg','polo5.jpg','polo6.jpeg','shirt1.jpg','shirt2.jpg','trouser1.jpg','trouser2.jpg'};
        list=list';
        for i=3:size(list,2)
           filenames{1,i-2}=fullfile('Training',list(1,i).name);
        end
        scaleDownFactor=1;
        [vectorDatabase,gaborArray]=populateVectorDatabase(filenames,scaleDownFactor);
        save('Training.mat','vectorDatabase');
    end

    function queryFn(~,~)
        [filename,pathname,~]=uigetfile({'*.*';'*.tif';'*.tiff';'*.jpg';'*.jpeg'},'Select query Image','MultiSelect','off'); 
        queryFilename=fullfile(pathname,filename);
        [closestFilenames,distance]=queryMatch(vectorDatabase,queryFilename,closestImageNumber ,gaborArray);
        display(closestFilenames);
        figure(queryFigure);imshow(imread(queryFilename));title('query Image');
        
        numCols=ceil(size(closestFilenames,2)/3);
        resultImage=showImgTile(closestFilenames,resolution,numRows,numCols);
        figure(imageFigure);imshow(resultImage);
        
        distance=distance(1:size(closestFilenames,2));
        distance=reshape(distance,numRows,numCols);
        distance=distance/sum(weights)*100;
        set(table,'Data',distance);
    end

    function resetFn(~,~)
        clf (imageFigure);
        searchGUI();
    end

    function cropFn(~,~)
        figure(imageFigure);
        tempFig=figure;
        [filename,pathname,~]=uigetfile({'*.jpg';'*.tiff';'*.tif';'*.jpeg'},'Select query Image','MultiSelect','off');
        queryFilename=fullfile(pathname,filename);
        image=imread(queryFilename);
        set(0,'DefaultFigureWindowStyle','normal');
        f1=figure;imshow(image);
        display('draw rectangle on the image');
        set(0,'DefaultFigureWindowStyle','docked');
        h=imrect;
        roi=getPosition(h);
        close(f1);
        data2=roi;
        a=data2(1);b=data2(2);c=data2(3);d=data2(4);
        vertices(:,:)=[a,b;a+c,b;a+c,b+d;a,b+d;];
        BW=roipoly(image,vertices(:,1),vertices(:,2));
        B=bwboundaries(BW);
        boundary=B{1};
        xindices=boundary(:,1);xMin=min(xindices);xMax=max(xindices);
        yindices=boundary(:,2);yMin=min(yindices);yMax=max(yindices);
        
        BW=repmat(uint8(BW),[1 1 3]);
        croppedImage=image.*BW;
        croppedImage=croppedImage(xMin:xMax,yMin:yMax,:);
        
%         tempFig2=figure;
%         imshow(croppedImage);
        imwrite(croppedImage,'cropped.tif');
        close(tempFig);
%         close(tempFig2);
        
        queryFilename='cropped.tif';
        [closestFilenames,distance]=queryMatch(vectorDatabase,queryFilename,closestImageNumber ,gaborArray);
        display(closestFilenames);
        changeFn(0,0);
%         figure(imageFigure);
%         subplot(1,closestImageNumber +1,1);imshow(imread(queryFilename));title('query Image');
%         for i=1:closestImageNumber 
%             subplot(1,closestImageNumber+1,i+1);imshow(imread(closestFilenames{i}));title([' distance=' num2str(distance(i))]);
%         end
    end

    function changeFn(object,~)
        closestImageNumber=floor(get(closestImageNumber_box,'Value'));
        weights(1)=floor(get(w1_box,'Value'));
        weights(2)=floor(get(w2_box,'Value'));
        weights(3)=floor(get(w3_box,'Value'));
       % weights(4)=floor(get(w4_box,'Value'));
        display(weights);
        Fq=queryVector.Fs;
        Dq=queryVector.Ds;
        colorInfoq=queryVector.colorInfo;
        boundaryHistq=queryVector.boundaryHist;
        patternVectorq=queryVector.patternVector;
        s1=size(vectorDatabase,1);
        
        siftDistance=zeros([s1,1]);
        colorDist=zeros([s1,1]);
        patternDist=zeros([s1,1]);
        boundaryHistDist=zeros([s1,1]);
        for i=1:s1
           % make it scalable with number of features
           Fs=vectorDatabase{i}.Fs;
           Ds=vectorDatabase{i}.Ds;
           colorInfos=vectorDatabase{i}.colorInfo;
           boundaryHists=vectorDatabase{i}.boundaryHist;
           patternVectors=vectorDatabase{i}.patternVector;

%           siftDistance(i)=sdFn(Fs,Ds,Fq,Dq);
           colorDist(i)=colorDistFn(colorInfos,colorInfoq);
           patternDist(i)=patternVectorDistFn(patternVectors,patternVectorq);
           boundaryHistDist(i)=boundaryHistFn(boundaryHists,boundaryHistq);
        end
        maxsiftDistance=max(siftDistance);
 %       siftDistance=siftDistance/maxsiftDistance;

        for i=1:s1
            dist(i)=weights(1)*boundaryHistDist(i)+weights(2)*colorDist(i)+weights(3)*patternDist(i);
        end
        [distance,index]=sort(dist);

        for i=1:closestImageNumber
            closestFilenames{i}=vectorDatabase{index(i)}.filename;
        end
        
        figure(queryFigure);clf(queryFigure);imshow(imread(queryFilename));title('Query Image');
        figure(imageFigure);
        clf(imageFigure);
        numCols=ceil(size(closestFilenames,2)/numRows);
        resultImage=showImgTile(closestFilenames,resolution,numRows,numCols);
        imshow(resultImage);
        distance=distance(1:size(closestFilenames,2));
        distance(end+1:numRows*numCols)=0;
        distance=reshape(distance,numRows,numCols);
        distance=distance/sum(weights(:));
        set(table,'Data',distance);
    end
        
    function[queryResultFilename,distance]=queryMatch(vectorDatabase,queryImage,number,gaborArray)
    %features right now - sift,dominantColor,dominant3ColorRatio
    % weights               1 ,     10      ,   5
    % calculate distances of each feature, for sift ? 
    % calculate finalValue 1*siftDist+10*domColorDist+5*....
    % output - filenames of image with minimum finalValue
        s1=size(vectorDatabase,1);
        w=[0 0 1];%color boundary Pattern

        image=imread(queryImage);
        image=changeImage(image,resolution);
        mask=getMask(image);
        image=image.*uint8(mask);

        %finding features for the query image
        gray_s=rgb2gray(im2single(image));
        colorInfoq=colorInfoFn(image,mask);
        propq=boundaryCoeffsFn(image,mask);
        boundaryHistq=getShapeHist(propq);
        patternVectorq=patternVectorFn(image,mask,gaborArray);
        queryVector.colorInfo=colorInfoq;
        queryVector.boundaryHist=boundaryHistq;
        queryVector.patternVector=patternVectorq;

        siftDistance=zeros([s1,1]);
        colorDist=zeros([s1,1]);
        patternDist=zeros([s1,1]);
        boundaryHistDist=zeros([s1,1]);
        for i=1:s1
           % make it scalable with number of features
           Fs=vectorDatabase{i}.Fs;
           Ds=vectorDatabase{i}.Ds;
           colorInfos=vectorDatabase{i}.colorInfo;
           boundaryHists=vectorDatabase{i}.boundaryHist;
           patternVectors=vectorDatabase{i}.patternVector;

           colorDist(i)=colorDistFn(colorInfos,colorInfoq);
           patternDist(i)=patternVectorDistFn(patternVectors,patternVectorq);
           boundaryHistDist(i)=boundaryHistFn(boundaryHists,boundaryHistq);
        end
        maxsiftDistance=max(siftDistance);

        for i=1:s1
            dist2(i)=weights(1)*boundaryHistDist(i)+weights(2)*colorDist(i)+weights(3)*patternDist(i);
        end
        display(colorDist);
        display(boundaryHistDist);
        display(dist2);

        %Not scalable to sort n entries
        [~,index]=sort(dist2);
        for i=1:number
           queryResultFilename{i}=vectorDatabase{index(i)}.filename; 
           distance(i)=dist2(index(i));
        end

        function[distance]=sdFn(Fs,Ds,Fq,Dq)
            distance=0;
%             [matches, scores] = vl_ubcmatch(Ds, Dq);
%             scores=sort(scores);
%             if(size(scores,2)>=10)
%                 distance=mean(scores(1:10));
%             else
%                 distance=mean(scores);
%             end

        end

    end


end

