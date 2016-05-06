function[distance]=colorDistFn(a,b)
   if(sum(size(a)==size(b))~=3)
      distance= -1 ;
      display('different sized accumulators');
      return
   end
   
   distance=sum(sum(sum(a.*b)));
   A=sum(sum(sum(a.*a)));
   B=sum(sum(sum(b.*b)));
   distance=1-distance/(sqrt(A)*sqrt(B));
end