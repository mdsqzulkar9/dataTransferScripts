function [n_cc, n_param] = find_closest_sample(cc, param, samples)
%FIND_CLOSEST_SAMPLE computes the nearest original sample point of the given 
%   sample point.
%   input : 
%       cc - concurrency value - a single value
%       param - parallism or pipelining dependin on file size
%       samples - original sampling points (historically 1,2,4,8,16,32)
%
%   Output:
%       n_cc = original sampling point closest to given cc.
%       n_param = original sampling point closest to given param.
%
%   Example: if CC = 25, PARAM = 15, and SAMPLES = [1,2, 4, 8, 16, 32]
%   then [A,B] = find_closest_sample(CC, PARAM, SAMPLES) outputs A=32,B=16 
%       
%   Author : MD S Q ZULKAR NINE           Date: October 27, 2016

    for i = 1:1:size(samples,2)
       ccs(i) = cc;
       params(i) = param;
    end
    
    cc_diff = abs(ccs-samples);
    param_diff = abs(params-samples);
    
    [min_diff_cc, min_index_cc] = min(cc_diff);
    [min_diff_param, min_index_param] = min(param_diff);
    
    n_cc = samples(min_index_cc);
    n_param = samples(min_index_param);
end