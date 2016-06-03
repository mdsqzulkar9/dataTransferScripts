#!/usr/bin/env python
# Script: fileGenerator.py
# This script takes care of the first part of the data transfer 
# experiment. 
# It creates the dataset. reads the specification files. and creates
# dataset in appropriate location. 
# you need directory level execution access to both source and destination
# nodes. 
# provide your user name and password in a seperate file.
# username
# password 
# Script will auto distruct the password file, after it gets the credintial from 
# the file.




import paramiko


#user control:
server = "stampede.tacc.xsede.org"
username = "zulkar9"
password = "S7ealth@123"

# get user name and password:
credintial = []
user_file = open('user.txt','r')
for line in user_file:
    credintial.append(line)

print(credintial[0])
print(credintial[1])
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(
    paramiko.AutoAddPolicy())
ssh.connect(server, username=credintial[0], password=credintial[1])
ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command("mkdir ~/funny")


ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command("ls")
data = ssh_stdout.read().splitlines()
for line in data:
    print (line)