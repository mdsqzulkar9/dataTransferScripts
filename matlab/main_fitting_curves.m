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

num_grps = size(groups,1);
max_runs = 3;
sf = cell(num_grps, max_runs);                       
for group_id = 1 : 1: 12       %% small files
    %num_runs = max(table2array(unique(sg((sg.group_id == group_id) & ...
    %                    (sg.fast == 0), 16))));   %16->run_id
    num_runs =1
    num_runs_arr(group_id) = num_runs;
    figure;
    for run_id = 1 : 1 : num_runs
       t = sg((sg.group_id == group_id) & ...
                (sg.run_id==run_id) & ...
                (sg.fast == 0) & ((sg.p==2)|(sg.p==1)), :);

       sft = fit([t.cc, t.pp],t.throughput,'linearinterp');
       sf{group_id, run_id} = sft;
       plot(sft,[t.cc,t.pp], t.throughput );

       hold on;
    end
     xlabel('cc');
     ylabel('pp');
     zlabel('throughput');
    savefig(strcat( 'fitted_curves/sf_grp' , int2str(group_id),'_run_',...
                        int2str(run_id)));
end



% max_runs = 15;                       
% for group_id = 13 : 1: 17       %% medium and large files
%     num_runs = max(table2array(unique(sg((sg.group_id == group_id) & ...
%                         (sg.fast == 0), 16))));   %16->run_id
%                     
%     num_runs_arr(group_id) = num_runs;
%     figure;
%     for run_id = 1 : 1 : num_runs
%        t = sg((sg.group_id == group_id) & ...
%                 (sg.run_id==run_id) & ...
%                 (sg.fast == 0) & ((sg.pp==2)|((sg.pp==1)), :);
% 
%        sft = fit([t.cc, t.p],t.throughput,'cubicinterp');
%        sf{group_id, run_id} = sft;
%        plot(sft,[t.cc,t.p], t.throughput );
% 
%        hold on;
%     end
%      xlabel('cc');
%      ylabel('p');
%      zlabel('throughput');
%     savefig(strcat( 'fitted_curves/sf_grp_' , int2str(group_id)));
% end
% 
% 
% %% take uniform sampling over 32 X 32 surface
% 
% % take exhaustive samples for each dimension
%  x_samples = 1:1:32;
%  y_samples = 1:1:32;
% sample_grid = zeros(size(sf,1),size(sf,2));
% 
% for group_id = 1 : 1 : size(sf,1)
%     for run_id = 1 : 1 : size(sf,2)
%         if (~isempty( sf{group_id,run_id} ))
%             sft = sf{group_id,run_id}
%             % to find exhaustive max:
%             for x_sample=1:1:32
%                 for y_sample = 1:1:32
%                     sample_grid(x_sample,y_sample) = sft(x_sample,y_sample); 
%                 end
%              end
%         
%             [argvalue argmax] = max(sample_grid(:));
%             [cc param] = ind2sub(size(sample_grid), argmax);
%             in_max_th(group_id,run_id) = argvalue;
%             max_cc(group_id,run_id) = cc;
%             max_param(group_id,run_id) = param;
%         end
%     end
% end
% 
% clear group_id run_id sft argvalue argmax cc ...
%       param;
%   
% 
% 
% %% find bitonic max of curves parallel to x axis : here : cc 
% % % for i = 1 : 1 : 32
% % %    sgrid = sample_grid(:,i)';
% % %    max_elem(i) = find_max_bitonic(sgrid);
% % %    
% % % end
% % % x_samples = 1:1:32;
% % %  y_samples = 1:1:32;
% % % clear i;
% % % for i = 1 : 1 : 32
% % %     max_val(i) = x_samples(max_elem(i));
% % % end
% % 
% % %% fit a spline curve through the previously computed max values:
% % 
% % 
% % 
% % 
% % 
% % 
% % %% Compute error: exhaustive searche - bitonic search 
% % 
% % 
% % 
% % 
% % 
% % %% reason about running time bounds
% % 
% % 
% % 
% % %% Find the sampling region: 
% % 
% % 
% % 
% % %% Online test phase : 
% % 
% % % pick a test sample: from group 1 :
% % run_id = 8;















