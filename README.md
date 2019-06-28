# galacticus-docker
Docker containers to run the Galacticus model

# DISCLAIMER: THIS SOFTWARE IS PROVIDED WITH ABSOLUTELY NO SUPPORT OR RESPONSABILITY.

## Quick Start

The following instructions show how to quickly execute a Galacticus run using the Galacticus Docker image. For a more in-depth discussion of Galacticus functionality and configuration, please see the Galacticus wiki: https://bitbucket.org/galacticusdev/galacticus/wiki/Home

* Pre-requisite: you must have a Docker engine installed and running on your system

* Download the Galacticus image from the Docker repository:
  * docker pull galacticus/galacticus:latest
  
* Start a container from the image:
  * docker run --rm --name galacticus -it galacticus/galacticus:latest bash

* Once inside the container, run the model with sample parameters. This will generate a file named 'galacticus.hdf5' in the local directory. For example:
  * ./Galacticus.exe parameters/quickTest.xml
    * (will complete in about a minute).
  * ./Galacticus.exe parameters/snapshotExampleMPI_193.xml
    * (will take around 15 minutes)

* Copy the output file from the Docker container to the local host. Start another terminal window:
  * docker cp galacticus:/usr/local/galacticus/galacticus.hdf5 .

* Exit the container, loosing all data inside the container. Back from inside the container window:
  * exit
  
* Note: if you need to rebuild the container (typically not necessary):
  * git clone https://github.com/galacticusmodel/galacticus-docker.git (this repository)
  * docker build -f Dockerfile-binary -t galacticus/galacticus .

