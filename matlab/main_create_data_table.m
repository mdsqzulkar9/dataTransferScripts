% This is a simple script for making tabluar form of data:
% Before running this scrip make sure the following things: 
% (1) add run_id in your dataset to identify each specific run
% (2) Add background column also (if background present put 1 , otherwise 0)
% (3) change date colum to mm/dd/yyyy format.
% (4) then load those files.
% (5) Make sure to change variable names in script below.


clc;
clear all;

load('/Users/mds/Dropbox/gits/data/ThOpt/kemal/xsede/sg_kemal.mat')

sg = vertcat(sg_small,sg_msmall,sg_medium,sg1G,sg3G);
clear sg_small sg_msmall sg_medium sg1G sg3G;
%% find groups:

transfer_table = table(sg.file_size, ...
                     sg.number_of_files, ...
                     sg.bandwidth, ...
                     sg.rtt, ...
                     sg.buffer_size);

[group_id, groups] = findgroups(transfer_table);
clear transfer_table;

sg = [sg array2table(group_id)];
clear group_id;
save('data/table_sg_kemal.mat','sg','groups');
clear all;
disp('data is saved in data folder of current directory!')

