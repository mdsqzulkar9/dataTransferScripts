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
                        
                        
group_id = 13;
num_runs = max(table2array(unique(sg((sg.group_id == group_id) & ...
                    (sg.fast == 0), 16))));   %16->run_id
figure;
for run_id = 1 : 1 : 1
   t = sg((sg.group_id == group_id) & (sg.run_id==run_id) & (sg.fast == 0), :);
   
   sf1 = fit([t.cc, t.p],t.throughput,'cubicinterp');
    plot(sf1,[t.cc,t.p], t.throughput );
    
   hold on;
end
xlabel('cc');
ylabel('p');
zlabel('throughput');

%% take uniform sampling over 32 X 32 surface

% take 6 samples for each dimension
 x_samples = 1:1:32;
 y_samples = 1:1:32;

 i = 1;
 for x_sample=1:1:32
     j = 1;
     for y_sample = 1:1:32
        sample_grid(i,j) = sf1(x_sample,y_sample);
        j = j + 1; 
     end
     i = i + 1;
 end
clear i j;

[argvalue argmax] = max(sample_grid(:))
[cc pp] = ind2sub(size(sample_grid), argmax)
%% find bitonic max of curves parallel to x axis : here : cc 
% for i = 1 : 1 : 32
%    sgrid = sample_grid(:,i)';
%    max_elem(i) = find_max_bitonic(sgrid);
%    
% end
% x_samples = 1:1:32;
%  y_samples = 1:1:32;
% clear i;
% for i = 1 : 1 : 32
%     max_val(i) = x_samples(max_elem(i));
% end

%% fit a spline curve through the previously computed max values:






%% Compute error: exhaustive searche - bitonic search 





%% reason about running time bounds



%% Find the sampling region: 



%% Online test phase : 

% pick a test sample: from group 1 :
run_id = 8;















