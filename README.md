# galacticus-docker
Docker containers to run the Galacticus model

## Pre-Requisites

Docker engine installed and running on your system

## Quick Start

* Download the Galacticus image from the Docker repository:
  * docker pull galacticus/galacticus:source-centos6

* Start a container from the image:
  * docker run --rm --name galacticus -it galacticus:source-centos6 /bin/bash

* Once inside the container, run the model with sample parameters:
  * ./Galacticus.exe parameters/quickTest.xml

* Copy the output file from the Docker container to the local host, using another terminal window:
  * docker cp galacticus:/usr/local/galacticus/galacticus.hdf5 .

* Exit the container, loosing all data inside the container:
  * from the docker window: 
    * exit

