clc;
clear all;

% load table from data folder:
load('data/table_sg_kemal.mat');

%% grab some data: and find interpolated surface: 
%test1 = sg((sg.group_id == 1) & (sg.run_id==1) & (sg.fast == 0), :);

%cubic_interpolation(test1.cc,'cc',test1.p,'p',test1.throughput)

% sorted by pp,cc,p:
%cubic_interpolation(test1.pp,'pp',test1.cc,'cc', ...
%                           test1.throughput);
                        
%pp_cc_grp_tbl_test1 = table(test1.pp,test1.cc);

%[G, test_grps] = findgroups(pp_cc_grp_tbl_test1);

%maxth = splitapply(@max,test1.throughput, G);

%test_grps = table2array(test_grps);
% cubic_interpolation(test_grps(:,1),'pp',test_grps(:,2),'cc', ...
%                            maxth);
                        
% cubic_ploynomial(test_grps(:,1),'pp',test_grps(:,2),'cc', ...
%                            maxth);





max_runs = 15;                       
for group_id = 13 : 1: 17       %% medium and large files
    num_runs = max(table2array(unique(sg((sg.group_id == group_id) & ...
                        (sg.fast == 0), 16))));   %16->run_id
                    
    num_runs_arr(group_id) = num_runs;
    figure;
    for run_id = 1 : 1 : num_runs
       t = sg((sg.group_id == group_id) & ...
                (sg.run_id==run_id) & ...
                (sg.fast == 0) & ((sg.p == 4) | (sg.p==2) ), :);

       sft = fit([t.cc, t.p],t.throughput,'cubicinterp');
       sf{group_id, run_id} = sft;
       plot(sft,[t.cc,t.p], t.throughput );

       hold on;
    end
     xlabel('cc');
     ylabel('p');
     zlabel('throughput');
    savefig(strcat( 'fitted_curves/sf_grp_' , int2str(group_id)));
end