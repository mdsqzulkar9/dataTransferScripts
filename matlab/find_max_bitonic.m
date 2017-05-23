function max_elem = find_max_bitonic(ary)
     
    max_elem = recurse(1,size(ary,2))
    
    function c = recurse(low, high)

       mid = int64(low + (high - low)/2); 
       
       if (high - low) == 1
           c = high;
           return
       end
       
       if(ary(mid) < ary(mid+1))
           c = recurse(mid, high);
           return
       else
          c = recurse(low,mid);
          return
       end   
    end
 
end