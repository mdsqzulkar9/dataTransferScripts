import os

import sys, time
import datetime
#import subprocess





#dir_arr = ["3G"]

dir_arr = ["0.25_1000", "0.25_128" , "0.25_256" , "0.25_512" , "0.5_1000"  ,"0.5_128",  "0.5_256",  "0.5_512",  "1_1000",  "1_128",  "1_256",  "1_512"]



source = "gsiftp://gridftp.stampede.tacc.xsede.org:2811/scratch/02933/kgubcse/"

destination = "gsiftp://gridftp.psc.xsede.org:2811/brashear/kgubcse/"


#destination = "gsiftp://oasis-dm.sdsc.xsede.org:2811/oasis/scratch/kgubcse/temp_project/"




sourcedir = "/scratch/02933/kgubcse/"



#sgfile_name = "sg0"
#f = open(sgfile_name, "a")

f = open('sb0.25-1M', 'a')



for k in range(5):

	for dir_name in dir_arr:

		cur_src_dir = source + dir_name + "/"

		cur_dst_dir = destination + dir_name + "/"

		p = 1

		for i in range(6):	# create dummy files in count times

			cc= 1

			for j in range(6):      # create dummy files in count times

				ppq= 1

				for k in range(6):      # create dummy files in count times

					start = time.time()
					current_time = datetime.datetime.now()
					#command = "ls "+sourcedir+dir_name+"/ | wc -l"
					#fileNumber = Popen([command, ""], stdout=PIPE).communicate()[0]
					totalSize = os.popen("du -shb "+sourcedir+dir_name).read()	
					filenumber = os.popen("ls "+sourcedir+dir_name+"/ | wc -l").read()
					fileNumber = (str(filenumber).split())[0]
					tot  = totalSize.split()
					fileSize = int(tot[0])/int(fileNumber)
					#print sourcedir+dir_name+"\t"+str(fileNumber)+"\t"+str(fileSize)
					#print fileSize
					bw = 10*1000*1000*1000
					rtt = 0.050
					bs = 32*1024*1024
					os.system("globus-url-copy -st 9999 -fast -p " + str(p) + " -cc " + str(cc) + " -ppq " +str(ppq)+ " " + cur_src_dir + " " +cur_dst_dir)
					thr = (int(tot [0])*8)/((time.time()-start)*1024*1024)
					temp = str(fileSize)+"\t"+ str(fileNumber)+"\t"+ str(bw)+"\t"+ str(rtt)+"\t"+ str(bs) +"\t" + str(p) + "\t" + str(cc) + "\t" + str(ppq) +"\t" +"1\t"+str(thr)+"\t"+str(time.time()-start)

					#temp = "filesize=" + dir_name + " fast=1 p=" + str(p) + " cc=" + str(cc) + " pp=" + str(ppq) +" time=" +str(time.time()-start)
					temp = temp+"\t"+str(current_time)
					print temp
					f.write(temp+"\n")
					f.flush()
					#os.system("echo " + temp) 
					
					start = time.time()
					current_time = datetime.datetime.now()
					os.system("globus-url-copy -st 9999 -p " + str(p) + " -cc " + str(cc) + " -ppq " +str(ppq)+ " " + cur_src_dir + " " +cur_dst_dir)

					#temp = dir_name + "\t"+"0\t" + str(p) + "\t" + str(cc) + "\t" + str(ppq) +"\t" +str(time.time()-start)

					#temp = "filesize=" + dir_name + " fast=0 p=" + str(p) + " cc=" + str(cc) + " pp=" + str(ppq) +" time=" +str(time.time()-start)
					thr = (int(tot [0])*8)/((time.time()-start)*1024*1024)
					temp = str(fileSize)+"\t"+ str(fileNumber)+"\t"+ str(bw)+"\t"+ str(rtt)+"\t"+ str(bs) +"\t" + str(p) + "\t" + str(cc) + "\t" + str(ppq) +"\t" +"0\t"+str(thr)+"\t"+str(time.time()-start)

					temp = temp+"\t"+str(current_time)
					print temp
					f.write(temp+"\n")
					f.flush()


					ppq = ppq * 2

				cc = cc * 2

			p = p*2

		f.write("*****\n")	
		f.flush()


#def myscript(iteration_number):
#   def main(unused_command_line_args):
#       for i in range(4):
#           myscript(i)
#       return 0

#   if __name__ == '__main__':
#      sys.exit(main(sys.argv))
