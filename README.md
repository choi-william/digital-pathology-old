# README #

The entry point to running the software is to call:

pathology_analysis(0) %for single image selection analysis
run_all_files(0); %to batch process images in a directory

There are lots of files in the src/ that are not necessary for running
the project, but are for behind the scenes file manipulation, classification
training, etc. 

To accompany the project, there is a directory of brain slides we were given
from the lab. Certain functions in src/ are programmed to pull from this data
which lived in /data/output/ . For access to these data files, please email
adkyriazis@gmail.com