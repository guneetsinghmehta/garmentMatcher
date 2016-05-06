function[finalImage]=showImgTile(filenames,resolution,numRows,numCols)
    %input is a cell of images of size s1,
    %resolution is the number of max rows or cols in the image
    % numRows ,numCols -  number of rows and columns in the image
    %figHandle is the handle of the figure on which images are plotted
    filenames=filenames';
    s1=size(filenames,1)
    finalImage=[];rowImage=[];
    if(s1>numRows*numCols)
       display('s1>numRows*numCols');
       s1=numRows*numCols;
    end
    %finalImage=zeros(numRows*resolution,numCols*resolution,3);
    for i=1:s1
       newImage=changeImage(imread(filenames{i,1}),resolution);
       rowImage=[rowImage newImage];
      if(floor(i/numCols)*numCols==i)
        %indicates last image
        finalImage=[finalImage;rowImage];
        rowImage=[];
      end
    end
    blank=uint8(255*ones(resolution,resolution,3));
    flag=0;
    while(mod(s1,numCols)~=0)
        rowImage=[rowImage blank];
        s1=s1+1;
        flag=1;
    end
    if(flag==1)
        finalImage=[finalImage;rowImage];
    end
    
    
end

