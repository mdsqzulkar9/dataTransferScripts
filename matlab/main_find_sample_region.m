clc;
clear all;
% load data from main_fitting_curves.m script
%load('/Users/mds/Dropbox/gits/dataTransferScripts/matlab/data/out_main_fitting_curves.mat');
load('/Users/mds/Dropbox/gits/dataTransferScripts/matlab/data/out_main_fix_third_param.mat');


% number of suitable regions you want to sample.
num_sample_regions = 10;

num_grps = size(groups,1);
for grp_id = 1 : 1 : 1
    num_runs = num_runs_arr(grp_id);
    
    % extract the sfs for each group
    sfs = sf(grp_id,1:num_runs);
    
    
    x_sample = 1;
    y_sample = 1;
    
   [px,py] = find_sample_region(sfs, x_sample, y_sample, num_runs, ...
                                    num_sample_regions);
                                
end

disp('find sample region finished')