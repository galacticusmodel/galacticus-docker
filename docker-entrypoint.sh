#!/bin/sh
# Script to run Galacticus at container startup

# run the model
./Galacticus.exe parameters/quickTest.xml

# move the output to another location 
# where it can be accessed before the container exits
mv galacticus.hdf5 /data/galacticus.hdf5
