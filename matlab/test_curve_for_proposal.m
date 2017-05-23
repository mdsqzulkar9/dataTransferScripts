
% Curve fitting for Proposal:

load('data/table_sg_kemal.mat');

num_grps = 1
max_runs = 15;
sf = cell(num_grps, max_runs);     
group_id = 17

max_runs = 15;  
group_id = 17
% for group_id = 13 : 1: 17       %% medium and large files
    % num_runs = max(table2array(unique(sg((sg.group_id == group_id) & ...
    %                    (sg.fast == 0), 16))));   %16->run_id
    num_runs = 3                
    num_runs_arr(group_id) = num_runs;
    figure;
    spec_runs = [2,3,4]
    for run_id = 1 : 1 : num_runs
       t = sg((sg.group_id == group_id) & ...
                (sg.run_id==spec_runs(run_id) ) & ...
                (sg.fast == 0), :);

       sft = fit([t.cc, t.p],t.throughput,'cubicinterp');
       sf{group_id, spec_runs(run_id)} = sft;
       plot(sft,[t.cc,t.p], t.throughput );
       if run_id == 1
            colormap winter
       end
       if run_id == 2
           colormap gray
       end
       if run_id == 3
           colormap winter
       end
       hold on;
    end
     xlabel('Concurrency');
     ylabel('Parallelism');
     zlabel('Throughput (Mbps)');
    savefig(strcat( 'fitted_curves/sf_grp_' , int2str(group_id)));
%end

load('/Users/mds/Dropbox/gits/dataTransferScripts/matlab/data/out_main_fitting_curves.mat');
crvf = cell(num_grps, max_runs);
%SMALL files:
%for group_id = 1 : 1 : 12
group_id = 17;
    figure;
    num_runs = 3
    spec_runs = [1,2,3];
    for run_id = 1 : 1 : num_runs
        opt_cc = max_cc(group_id,spec_runs(run_id) ); 
        opt_param = max_param(group_id,spec_runs(run_id) );

        sample_points = [1 2 4 8 16 32];
        [n_cc, n_param]=find_closest_sample(opt_cc, opt_param, sample_points);

        z_points = table2array(sg(   (sg.group_id == group_id) & ...
                                     (sg.run_id == spec_runs(run_id)) & ...
                                     (sg.fast == 0) & ...
                                     (sg.cc == n_cc) & ...
                                     (sg.p == n_param),10 ))   %10->throughput
        
        if(size(sample_points,2) == size(z_points,1))
            crv_fit = fit(sample_points', z_points,'cubicinterp')
            crvf{group_id, spec_runs(run_id)} = crv_fit;
            plot(crv_fit,sample_points, z_points);
            hold on;
        end
    end
    xlabel('Pipelining');
    ylabel('Throughput (Mbps)');
    savefig(strcat( 'fitted_curves/crvf_quadratic_grp_' , int2str(group_id)));
%end