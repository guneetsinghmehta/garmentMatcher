function[distance]=patternVectorDistFn(patternVector1,patternVector2)
    vector1=patternVector1.vector;
    vector2=patternVector2.vector;
    [s1,s2]=size(vector1);
    if(sum(size(vector1)==size(vector2))~=2)
       error('unequal vectors'); 
    end
    count=sum(sum(vector1==vector2));
    distance=1-count/(s1*s2);
end