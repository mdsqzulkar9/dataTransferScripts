% THIS script will fix the value of thrid parameter based on file size. 
clear all;
clc;
%% load data from previous scrips: main_fitting_curves.m
load('/Users/mds/Dropbox/gits/dataTransferScripts/matlab/data/out_main_fitting_curves.mat');


%% fix the third param - p for small files and pp for medium and large files:
crvf = cell(num_grps, max_runs);
%SMALL files:
for group_id = 1 : 1 : 12
    figure;
    for run_id = 1 : 1 : num_runs_arr(group_id)
        opt_cc = max_cc(group_id,run_id); 
        opt_param = max_param(group_id,run_id);

        sample_points = [1 2 4 8 16 32];
        [n_cc, n_param]=find_closest_sample(opt_cc, opt_param, sample_points);

        z_points = table2array(sg(   (sg.group_id == group_id) & ...
                                     (sg.run_id == run_id) & ...
                                     (sg.fast == 0) & ...
                                     (sg.cc == n_cc) & ...
                                     (sg.p == n_param),10 ))   %10->throughput
        
        if(size(sample_points,2) == size(z_points,1))
            crv_fit = fit(sample_points', z_points,'poly2')
            crvf{group_id, run_id} = crv_fit;
            plot(crv_fit,sample_points, z_points);
            hold on;
        end
    end
    xlabel('p');
    ylabel('throughput');
    savefig(strcat( 'fitted_curves/crvf_quadratic_grp_' , int2str(group_id)));
end

% MEDIUM and LARGE files:
for group_id = 13 : 1 : 17
    figure;
    for run_id = 1 : 1 : num_runs_arr(group_id)
        opt_cc = max_cc(group_id,run_id); 
        opt_param = max_param(group_id,run_id);

        sample_points = [1 2 4 8 16 32];
        [n_cc, n_param]=find_closest_sample(opt_cc, opt_param, sample_points);

        z_points = table2array(sg(   (sg.group_id == group_id) & ...
                                     (sg.run_id == run_id) & ...
                                     (sg.fast == 0) & ...
                                     (sg.cc == n_cc) & ...
                                     (sg.p == n_param),10 ));   %10->throughput
        if(size(sample_points,2) == size(z_points,1))
            crv_fit = fit(sample_points', z_points,'poly2')
            crvf{group_id, run_id} = crv_fit;
            plot(crv_fit,sample_points, z_points);
            hold on;
        end
    end
    xlabel('pp');
    ylabel('throughput');
    savefig(strcat( 'fitted_curves/crvf_quadratic_grp_' , int2str(group_id)));
end


%% find max of z : 
