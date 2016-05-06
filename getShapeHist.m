function[hist]=getShapeHist(prop)
    x=prop.xNorm;
    y=prop.yNorm;
    
    N=30;
    z=(x)+(y)*(1i);
    z=abs(z);
    hist=zeros(N,1);

    try
        for i=1:size(x,2)
            index=ceil(abs(z(i))*N);
            hist(index)=hist(index)+1;
        end
    catch
        fprintf('Error');
        hist(1:N)=1/N;
    end
end