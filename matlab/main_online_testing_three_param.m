% THIS script is only provide prediction of cc, and p/pp. 
% online testing is based on two parameters.
% 

clc;
clear all;

%load('/Users/mds/Dropbox/gits/dataTransferScripts/matlab/data/out_main_find_sample_region.mat');
load('/Users/mds/Dropbox/gits/dataTransferScripts/matlab/data/out_main_find_sample_region2.mat');


rng(20161009);

%% First divide the each group for 10 fold cross validation. 
num_folds =  10;
master_num = 1;
for num_sample_reg = 1 : 1 : num_sample_regions
    
    
    for grp_id = 1 : 1 : num_grps
        mean_predict_err = 0;
        mean_error = 0;
        error_counter = 0;
        group_error = 0;
        group_prediction_err = 0;
        num_runs = num_runs_arr(grp_id);
        validation_error = 0;
        validation_predict_err = 0;
        percentage_err = 0;
        percent_predict_err = 0;
        for validation = 1 : 1 : num_folds

            randomize = randperm(num_runs);

            test_run = randomize(1);
            train_run = randomize(2:end);
            
            % for each sample region
            for sample_reg = 1 : 1 : num_sample_reg
                x = px(sample_reg);
                y = py(sample_reg);
                
                % find throughput for runs in train_run
                for r = 1 : 1 : size(train_run,2)
                    t_run_id = train_run(r);
                    sft = sf{ grp_id,  t_run_id };
                    th_train(r, sample_reg ) = sft(x,y);
                end

                % find throughput for test data:
                sft = sf{ grp_id, test_run };
                th_test(sample_reg) = sft(x,y);

            end % sample region

            % compute nearnest neighbor to predict closest run
            predicted_run_temp = find_NN(th_train,th_test);
            predicted_run = train_run(predicted_run_temp);
            
            % find max throughput for predicted run:
            predicted_max_th = in_max_th(grp_id,predicted_run);
            predicted_max_x = max_cc(grp_id, predicted_run);
            predicted_max_y = max_param(grp_id, predicted_run);
            
            
            % for each sample regions 
            
            
            % find max throughput for actual run:
            optimal_max_th = in_max_th(grp_id,test_run);
            
            %find the actual achieved throughput:
            sft_test_run = sf{grp_id, test_run};
            actual_max_th = sft_test_run(predicted_max_x, ...
                                         predicted_max_y);
            
            validation_error = abs(optimal_max_th - ...
                                                    actual_max_th);
            validation_predict_err = abs(predicted_max_th - ...
                                         optimal_max_th);
                                     
            optimal_th_arr(master_num) = optimal_max_th;
            actual_th_arr(master_num) = actual_max_th;
            predicted_th_arr(master_num) = predicted_max_th;
            master_num = master_num + 1;
            percentage_err = percentage_err + ...
                        (100 -((validation_error/optimal_max_th)*100)); 
            percent_predict_err = percent_predict_err + ...
                        (100 -((validation_predict_err/optimal_max_th)*100));   
            error_counter = error_counter + 1;
            clear test_run train_run randomize x y t_run_id sft ...
                th_train th_test predicted_run_temp predicted_run ...
                actual_max_th;
        end % validation
        
        group_error = group_error + percentage_err;
        group_prediction_err = group_prediction_err + percent_predict_err;
        
        mean_error = group_error / error_counter;
        mean_predict_err = group_prediction_err / error_counter;
        
        group_mse(num_sample_reg,grp_id) = (mean_error);
        
        group_predict_mse(num_sample_reg,grp_id) = mean_predict_err;
        
        err_cnt(num_sample_reg,grp_id) = error_counter;
        
    end % groups
    
    group_rmse = (group_mse);
    disp(strcat('sample size: ', num2str(num_sample_reg),' finished!'));
end % num of samples
