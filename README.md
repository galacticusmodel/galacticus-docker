# galacticus-docker
Docker containers to run Galacticus model

## Pre-Requisites

Docker engine installed and running on your system

## Quick Start

docker pull galacticus/galacticus:source-centos6

docker run --rm --name galacticus -it galacticus:source-centos6 /bin/bash

./Galacticus.exe parameters/quickTest.xml

from another window: docker cp galacticus:/usr/local/galacticus/galacticus.hdf5 .

from the docker window: exit

