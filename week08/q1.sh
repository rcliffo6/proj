#! bin/sh

# uses a loop to move a set of files from one directory to another

# set up destination directory
mkdir -p ~/new_directory

# go to origin directory
cd ~/old_directory

# move files

for i in *; do mv $i ~/new_directory; done
