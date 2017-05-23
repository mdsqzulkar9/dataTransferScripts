% This is the master script for Throughput optimization by
% Cubic spline interpolation of data and fine tuned online 
% tuning by identifying the appropriate sampling region.

% The summary of the approach:
    % (1) Add all data into matlab. 
    
    % (2) perform cubic spline interpolation
    
    % (3) Use bitonic search to find max.
    
    % (4) Perform $ max min (th_{i} - th_{j})^{2} $  
    
    % (5) Identify the region from where we sample
    
    % (6) Perform baseline approach : nearest neighbor to predict {params}.
    
% Details:

    % (1) Add all data into matlab. 
        % Data structue : creating a dataset class. 
        % dataset.test(i).filesize
        %                .num_files
        %                .bandwidth
        %                .rtt
        %                .buffer_size
        %                .p
        %                .cc
        %                .pp
        
        
    % (2) perform cubic spline interpolation
    
    % (3) Use bitonic search to find max.
    
    % (4) Perform $ max min (th_{i} - th_{j})^{2} $  
    
    % (5) Identify the region from where we sample
    
    % (6) Perform baseline approach : nearest neighbor to predict {params}.


   %% here I am doing it in a crude way : to first check
  load('param_rows.mat') 
 
load('/Users/mds/Dropbox/gits/dataTransferScripts/matlab/XCEDEPart1/XCEDE_Part1_THsOfGroup.mat')
load('/Users/mds/Dropbox/gits/dataTransferScripts/matlab/XCEDEPart1/XCEDE_Part1_inputSettingsOptTH.mat')

input_setting = inputSettingsOptTH(:,1:5)
fit_obj_array = cell(12,12)
k = 1
for j = 1 : 216 : (216*12)  % for all input settings
    start = j;
    finish = (j - 1) + 216;
    figure;
    for i = 1 : 1 : 12 
        th = THsOfGroup(start:finish,i);
        sft = fit([cc, p],th,'cubicinterp');
        fit_obj_array{k,i} = sft;
        plot(sft,[cc,p],th );
        hold on
    end
        xlabel('cc');
        ylabel('p');
        zlabel('throughput');
        title_str = strcat( 'filesize-' , ...
                            num2str( input_setting(k,1)/1000000 ), ...
                            'MB-', ...
                            '-num-files-', ...
                            num2str( input_setting(k,2) )  );
        title(title_str)
        filename = strcat('fitted_curves/', title_str,'.fig')
        savefig(filename)
        k = k + 1;
end

%% Bitonic search to find max : 









  
   
   
   
   

   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
