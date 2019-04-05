# galacticus-docker
Docker containers to run the Galacticus model

# DISCLAIMER: THIS IS A WORK IN PROGRESS AND ABSOLUTELY NOT SUPPORTED AT THIS TIME. 
# USAGE OF THE SOFTWARE ACCESSIBLE FROM THIS REPOSITORY IS NOT RECOMMENDED TO ANYONE OUTSIDE OF THE CORE DATA SCIENCE PROJECT TEAM.

## Pre-Requisites

Docker engine installed and running on your system

## Quick Start

* Download the Galacticus image from the Docker repository:
  * docker pull galacticus/galacticus:latest

* Start a container from the image:
  * docker run --rm --name galacticus -it galacticus/galacticus:latest bash

* Once inside the container, run the model with sample parameters. This will generate a file named 'galacticus.hdf5' in the local directory
  * ./Galacticus.exe parameters/quickTest.xml

* Copy the output file from the Docker container to the local host. Start another terminal window:
  * docker cp galacticus:/usr/local/galacticus/galacticus.hdf5 .

* Exit the container, loosing all data inside the container. Back from inside the container window:
  * exit

