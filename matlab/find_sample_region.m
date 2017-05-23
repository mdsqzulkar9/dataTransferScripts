function [p_x, p_y] = find_sample_region(sf, ...
                                     x_sample, ...
                                     y_sample, ...
                                     num_runs, ...
                                     num_sample_regions ...
                                    )
%FIND_SAMPLE_REGION finds the best regions that are suitable for sampling.
%  We should find max-min of the difference of the samples. 
%
%   arguments of the function are:
%       sf - cell array of surface fitting objects. it should 
%       contain all the surface of the runs.
%       x_sample - number uniform samples in x axis (x - param)
%       x_sample - number uniform samples in x axis (x - param)
%       num_runs - # of runs for the specific transfer
%       num_sample_regions - number of suitable regions you want to sample.
%
%   Outputs:
%       P_x - x cordinate of the region (historically cc)
%       p_y - y cordinate of the region (historically p/pp)
 
 for x = 1:x_sample:32
     for y = 1:y_sample:32
        % find throughput for each run
        for r = 1:1:num_runs
            sft = sf{1,r};
            thr(r) = sft(x,y);
        end
        % sort them in descending order
        [sorted_th, th_index] = sort(thr, 'descend');
        
        % compute the difference:
        for i = 1 : 1 : size(thr,2)-1
           diff_th(i) = sorted_th(i) - sorted_th(i+1); 
        end
        
        % compute min difference
        min_vals(x,y) = min(diff_th);
     end                         
 end

 
 % find the max of min_vals:
 
 % find 10 sample regions 
 for sample = 1 : 1 : num_sample_regions
    [argvalue argmax] = max(min_vals(:));
    [cc param] = ind2sub(size(min_vals), argmax);
    p_x(sample) = cc;
    p_y(sample) = param; 
    min_vals(cc, param) = 0;
 end
 
%  % here is the first one:
%  [argvalue argmax] = max(min_vals(:));
%  [cc param] = ind2sub(size(min_vals), argmax);
%  p_x(1) = cc;
%  p_y(1) = param;
%  
%  % put zero into first max value:
%  min_vals(cc, param) = 0;
%  
%  % here is the second one:
%  [argvalue argmax] = max(min_vals(:));
%  [cc param] = ind2sub(size(min_vals), argmax);
%  p_x(2) = cc;
%  p_y(2) = param;
 
 
 
 