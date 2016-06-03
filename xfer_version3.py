
#!/usr/bin/env python
# Script : xfer_version2.py
# It basically uses globus-url-copy command to transfer data from one node to another
# Create a folder with same name of dataset that you want to transfer
# Version 1.0   05 Feb 2016
# Author   MD S Q Zulkar Nine
# updates : buffer size updated !!!
################################################################################
# Tasks before running the script:
#(1) - run fileGen.sh from fileGen folder
#(2) - check whether files are created in the defined directory
#(3) - Prepare both Source and Destination : See data-transfer-commands.txt
#(4) - In this script update the source_key and destination-key : according to your need
#(5) - create a directory for the log files and put the name in log_file_dir variable in Control variables
#(6) - Check the round trip time, bandwidth and buffer size in the control variable 
#(7) - 




################################################################################

import os
import sys, time
import datetime
import math

#####################################################################
## User Control variables :

# valid source values : 
#        stampede
#        gordon
source = 'stampede'   
source_partition = 'scratch'   # can be scratch or home 
# valid destination_key values:
#        stampede
#        gordon    
destination = 'gordon'  # can be : stampede or gordon
destination_partition = 'scratch' # can be scratch or home 

# Dataset folder name :
dataset_folder_name = 'medium'

# directory for log file: 
log_file_dir = 'TransferLogFiles'

# Measure those values or gather information about it : 
link_bandwidth = 10   # Giga-bit per second
round_trip_time = 39 # milisecond
buffer_size = (link_bandwidth*1024*39*1000)/8   # byte


# Defined variables:
site_name_to_url_dict ={
    'stampede':'gsiftp://gridftp.stampede.tacc.xsede.org:2811',
    'gordon':'gsiftp://oasis-dm2.sdsc.xsede.org:2811',
}

name_to_directory_dict = {
    'stampede-home':'/home1/03644/zulkar9/',
    'stampede-scratch':'/scratch/03644/zulkar9/',
    'gordon-home':'/home/mdsqzulk/',
    'gordon-scratch':'/oasis/scratch/mdsqzulk/temp_project/'   
}


if(source == destination):
    print('Check control variables. Source and destination have same keys!')
    sys.exit();


# setup source url : 
source_url = site_name_to_url_dict[source]
destination_url = site_name_to_url_dict[destination]


# setup source and destination directory: 
source_key = source+"-"+source_partition
destination_key = destination+"-"+destination_partition

if (source_key == 'stampede-scratch'):
    source_directory = name_to_directory_dict[source_key]
elif (source_key =='stampede-home'):
    source_directory = name_to_directory_dict[source_key]
elif (source_key == 'gordon-home'):
    source_directory = name_to_directory_dict[source_key]
elif (source_key == 'gordon-scratch'):
    source_directory = name_to_directory_dict[source_key]

if (destination_key == 'stampede-scratch'):
    destination_directory = name_to_directory_dict[destination_key]
elif (destination_key =='stampede-home'):
    destination_directory = name_to_directory_dict[destination_key]
elif (destination_key == 'gordon-home'):
    destination_directory = name_to_directory_dict[destination_key]
elif (destination_key == 'gordon-scratch'):
    destination_directory = name_to_directory_dict[destination_key]







def end_to_end_transfer(current_source_dir, current_destination_dir, parallelism, concurrency, pipelining, fast):
    # Directory size calculation :
    temp_var1 = os.popen("du -shb "+current_source_dir).read()
    temp_var2= temp_var1.split()
    size_of_current_source_dir = int(temp_var2[0])   # size in byte

    # Number of files calculation:
    temp_var3 = os.popen("ls "+current_source_dir+" | wc -l").read()
    temp_var4= (str(temp_var3).split())[0]
    nmbr_of_files_current_source_dir = int(temp_var4)

    # Average file size :
    average_file_size = size_of_current_source_dir / nmbr_of_files_current_source_dir

    transfer_start_time = time.time()  # in seconds
    # Executing Globus-url-copy with given parameters : with fast command ON
    if fast == 1:
        globus_url_copy_command = 'globus-url-copy -st 9999 -fast -tcp-bs '+str(buffer_size)+' -p '+str(parallelism)+' -cc '  \
                             + str(concurrency) + ' -ppq ' + str(pipelining) + ' ' + source_url+ current_source_dir + ' ' \
                                           + destination_url + current_destination_dir
        print (globus_url_copy_command)
    else:
        globus_url_copy_command = 'globus-url-copy -st 9999 -tcp-bs '+str(buffer_size)+' -p '+str(parallelism)+' -cc '  \
                             + str(concurrency) + ' -ppq ' + str(pipelining) + ' '+ source_url + current_source_dir + ' ' \
                                        + destination_url + current_destination_dir
        print (globus_url_copy_command)
    os.system(globus_url_copy_command)
    transfer_finish_time = time.time()  # in seconds

    # Achieved throughput : computation:
    time_required = transfer_finish_time - transfer_start_time
    throughput = (size_of_current_source_dir *8) / time_required      # in bit per seconds

    #throughput in MByte per second:
    throughput = throughput /(8*1024*1024)    # in MBps

    # log entry generation :
    # log entry format:
    # <avg.file size> <#ofFiles> <bandwidth> <RTT> <Buffer Size> <-p> <-cc> <-pp> <fast> <throughput> <time required>
    #                                                                                                   <now-date-time>
    temp_date_time = datetime.datetime.now()
    now_date_time_str = temp_date_time.strftime('%m:%d:%Y-%H:%M')

    if fast == 1:
        log_entry = str(average_file_size) + "\t" + str(nmbr_of_files_current_source_dir)+ "\t" + str(link_bandwidth)  \
                + "\t" + str(round_trip_time) + "\t" + str(buffer_size) + "\t" + str(parallelism) + "\t" +  \
                str(concurrency) + "\t" + str(pipelining) + "\t" + "1\t" + str(throughput) + "\t" + str(time_required) \
                + "\t" + now_date_time_str
    else:
        log_entry = str(average_file_size) + "\t" + str(nmbr_of_files_current_source_dir) + "\t" + str(link_bandwidth) \
                + "\t" + str(round_trip_time) + "\t" + str(buffer_size) + "\t" + str(parallelism) + "\t" +  \
                str(concurrency) + "\t" + str(pipelining) + "\t" + "0\t" + str(throughput) + "\t" + str(time_required) \
                + "\t" + now_date_time_str

    print(log_entry)

    # Writing entry to log file:
    log_file.write(log_entry+"\n")
    log_file.flush()


# This method is responsible for varying the parameters :
# start means - starting point of parameters
# increment means - multiplicative increment
# finish means - upper limit of parameters
def transfer_with_varied_parameters(current_source_dir, current_destination_dir, start, increment, finish):
    steps = math.log(finish,increment)
    # initializing the parameters :
    parallelism = start
    for i in range(steps+1):
        concurrency = start
        for j in range(steps+1):
            pipelining = start
            for k in range(steps+1):
                fast = 0
                end_to_end_transfer(current_source_dir, current_destination_dir, parallelism, concurrency, pipelining, fast)
                fast = 1
                end_to_end_transfer(current_source_dir, current_destination_dir, parallelism, concurrency, pipelining, fast)

                # increase pipelining
                pipelining = pipelining * increment

            # end of for with k increment variable

            #increment concurrency
            concurrency = concurrency * increment
        # end of for with j increment variable

        #increment parallelism
        parallelism = parallelism * increment


# This method is responsible for sending different level one directories in the
# destination.
def multiple_dir_transfer_with_varied_param(start, increment, finish):
    # Listing all the level one folders
    dataset_path = source_directory + dataset_folder_name + "/"
    destination_dataset_path = destination_directory + dataset_folder_name + "/"
    
    temp_var1 = os.listdir(dataset_path)	
    #temp_var1 = os.system("ls " + dataset_path)
    print("temp_var1")
    print(temp_var1)
    type(temp_var1)
    #list_of_folders = temp_var1.split()
    #for folder in list_of_folders:
    for folder in temp_var1:
        current_source_dir = dataset_path + folder + "/"
        current_destination_dir = destination_dataset_path + folder + "/"
        transfer_with_varied_parameters(current_source_dir, current_destination_dir, start, increment, finish)
    # end of:  for folder in list_of_folders


################################################################################
###############################################################################
#########     MAIN EXECUTION POINT #############################################
###############################################################################
################################################################################
start = 1
increment = 2
finish = 32

# Log file : where transfer information will be saved!
# File name is based on source destination and date time of execution
# so no file will be overridden
current_date_time = datetime.datetime.now()
current_date_time_str = current_date_time.strftime('%m_%d_%Y_%H_%M')
log_file_name = 'log_'+source_key+'_'+destination_key+'_'+'date'+current_date_time_str+'.txt'
log_file = open(log_file_name,'w')



# call the function: 
multiple_dir_transfer_with_varied_param(start, increment, finish)


































