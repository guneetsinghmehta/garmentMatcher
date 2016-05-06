%interpolation
n=500;
x=[1:400];
xquery=zeros(n-size(x));
% find N=ceil(size(x)/size(xquery), intantiate j=1%N if j==N put in the
% query 
N=ceil(size(x)/size(xquery);
counter=1;index=1;
output=zeros([1 n]);
for i=1:size(x)
    
    if(counter>=N)
       
        counter=0;
    end
end