function res = find_NN(train_mat,test_vec)

    num_tests = size(test_vec,1);
    num_sample_reg = size(test_vec,2);
    
    num_train = size(train_mat,1);
    
    
   % fill test mat with same test
   for i = 1 : 1 : num_train
        test_mat(i,:) = test_vec;
   end 

   diff = abs(train_mat - test_mat);
   [min_val , index] = min(diff);
   res = mode(index);
  
end