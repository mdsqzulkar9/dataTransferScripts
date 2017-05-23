
clear all;
clc;
%% load data from previous script:
load('/Users/mds/Dropbox/gits/dataTransferScripts/matlab/data/out_main_online_testing_two_params.mat');


%% Error for Small, Medium and Large files:

% Small files: 
small_grp_mems = 1:1:12;
medium_grp_mems = 13:14;
large_grp_mems = 15:17;

%  groups error:
small_grps_err = group_rmse(:,1:12);
medium_grps_err = group_rmse(:,13:14);
large_grps_err = group_rmse(:,15:17);

% average error for each sample : 
small_mean_err = nanmean(small_grps_err')
medium_mean_err = nanmean(medium_grps_err')
large_mean_err = nanmean(large_grps_err')

figure;
plot(small_mean_err,'-o');
hold on
plot(medium_mean_err,'-*');
hold on
plot(large_mean_err,'-+');
ylim([50 100]);
xlabel('Number of samples');
ylabel('% Accuracy');
title('Percentage error for different sample size');

legend({'Small','Medium', 'Large'},'FontSize',12,'TextColor','blue')
savefig('fitted_curves/1_Samplewise_error_graph_two_param');

%% prediction graph:


%  groups error:
p_small_grps_err = group_predict_mse(:,1:12);
p_medium_grps_err = group_predict_mse(:,13:14);
p_large_grps_err = group_predict_mse(:,15:17);

% average error for each sample : 
p_small_mean_err = nanmean(p_small_grps_err')
p_medium_mean_err = nanmean(p_medium_grps_err')
p_large_mean_err = nanmean(p_large_grps_err')

figure;
plot(p_small_mean_err,'-o');
hold on
plot(p_medium_mean_err,'-*');
hold on
plot(p_large_mean_err,'-+');
ylim([50 100]);
xlabel('Number of samples');
ylabel('% Accuracy');
title('Percentage prediction error for different sample size');

legend({'Small','Medium', 'Large'},'FontSize',12,'TextColor','blue')
savefig('fitted_curves/2_Samplewise_error_graph_two_param_prediction');





