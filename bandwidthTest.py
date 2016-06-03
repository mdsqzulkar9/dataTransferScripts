#!/usr/bin/env python
# Script : xfer_version1.py
# It basically uses globus-url-copy command to transfer data from one node to another
# Create a folder with same name of dataset that you want to transfer
# Version 1.0   05 Feb 2016
# Author   MD S Q Zulkar Nine

import os
import sys, time
import datetime
import math

# Controlling variables :
source = 'stampede'   # can be : stampede or gordon
source_directory_name = 'scratch'  # can be home or scratch
dataset_folder_name = 'myFirst'
destination = 'gordon'  # can be : stampede or gordon
destination_directory_name = 'scratch'  # can be home or scratch
log_file_dir = 'TransferLogFiles'
link_bandwidth = 10   # Giga-bit per second
round_trip_time = 0.5
buffer_size = 32   # Mega byte

# Defined variables:
stampede_url = "gsiftp://gridftp.stampede.tacc.xsede.org:2811"
gordon_url = "gsiftp://gridftp.psc.xsede.org:2811"

stampede_home_dir = "/home1/03644/zulkar9/"
stampede_scratch_dir = "/scratch/03644/zulkar9/"

gordon_home_dir = "/home/mdsqzulk/"
gordon_scratch_dir = "/oasis/scratch/mdsqzulk/temp_prject/"


# Log file : where transfer information will be saved!
# File name is based on source destination and date time of execution
# so no file will be overridden
current_date_time = datetime.datetime.now()
current_date_time_str = current_date_time.strftime('%m_%d_%Y_%H_%M')
log_file_name = 'log_'+source+'_'+destination+'_'+'date'+current_date_time_str+'.txt'
log_file = open(log_file_name,'w')


# Setting up source based on your information:
if source == 'stampede':
    source_url = stampede_url
    if source_directory_name == 'scratch':
        source_directory = stampede_scratch_dir
    else:
        source_directory = stampede_home_dir

elif source == 'gordon':
    source_url = gordon_url
    if source_directory_name == 'scratch':
        source_directory = gordon_scratch_dir
    else:
        source_directory = gordon_home_dir


# Setting up destination based on your information:
if destination == 'stampede':
    destination_url = stampede_url
    if destination_directory_name == 'scratch':
        destination_directory = stampede_scratch_dir
    else:
        destination_directory = stampede_home_dir
elif destination == 'gordon':
    destination_url = gordon_url
    if destination_directory_name == 'scratch':
        destination_directory = gordon_scratch_dir
    else:
        destination_directory = gordon_home_dir


def end_to_end_transfer(current_source_dir, current_destination_dir, parallelism, concurrency, pipelining, fast):
    # Directory size calculation :
    temp_var1 = os.popen("du -shb "+current_source_dir).read()
    temp_var2= temp_var1.split()
    size_of_current_source_dir = int(temp_var2)   # size in byte

    # Number of files calculation:
    temp_var3 = os.popen("ls "+current_source_dir+" | wc -l").read()
    temp_var4= (str(temp_var3).split())[0]
    nmbr_of_files_current_source_dir = int(temp_var4)

    # Average file size :
    average_file_size = size_of_current_source_dir / nmbr_of_files_current_source_dir

    transfer_start_time = time.time()  # in seconds
    # Executing Globus-url-copy with given parameters : with fast command ON
    if fast == 1:
        globus_url_copy_command = 'globus-url-copy -st 9999 -fast -p='+str(parallelism)+' -cc='  \
                             + str(concurrency) + ' -ppq=' + str(pipelining) + ' ' + current_source_dir + ' ' \
                                        + current_destination_dir
    else:
        globus_url_copy_command = 'globus-url-copy -st 9999 -p='+str(parallelism)+' -cc='  \
                             + str(concurrency) + ' -ppq=' + str(pipelining) + ' ' + current_source_dir + ' ' \
                                        + current_destination_dir
    os.system(globus_url_copy_command)
    transfer_finish_time = time.time()  # in seconds

    # Achieved throughput : computation:
    time_required = transfer_finish_time - transfer_start_time
    throughput = (size_of_current_source_dir *8) / time_required      # in bit per seconds

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

    temp_var1 = os.system("ls " + dataset_path)
    list_of_folders = temp_var1.split()
    for folder in list_of_folders:
        current_source_dir = dataset_path + folder + "/"
        current_destination_dir = dataset_path + folder + "/"
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
multiple_dir_transfer_with_varied_param(start, increment, finish)


































