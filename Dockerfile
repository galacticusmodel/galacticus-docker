# Galacticus Docker image
# code downloads: https://users.obs.carnegiescience.edu/abenson/galacticus/versions/
# Uses Docker multi-stage build to first build the Galacticus executable,
# then copies it to the final Docker image

##############################################
# Stage 1 build
##############################################
FROM centos:6 as build

RUN yum -y update &&\
    yum -y install vim wget make 
    
ENV INSTALL_PATH /usr/local
    
# Must install latest version of gcc from source
RUN cd /opt &&\
    wget ftp://ftp.gnu.org/gnu/gcc/gcc-8.2.0/gcc-8.2.0.tar.gz &&\
    tar xvfz gcc-8.2.0.tar.gz &&\
	cd gcc-8.2.0 &&\
	./contrib/download_prerequisites &&\
	sed -i~ -r s/"gfc_internal_error \(\"new_symbol\(\): Symbol name too long\"\);"/"printf \(\"new_symbol\(\): Symbol name too long\"\);"/ gcc/fortran/symbol.c
RUN yum install -y gcc-c++
RUN cd /opt &&\
    mkdir gcc-8.2.0-build &&\
    cd gcc-8.2.0-build &&\
    ../gcc-8.2.0/configure --prefix=$INSTALL_PATH --enable-languages=c,c++,fortran --disable-multilib &&\
    make &&\
    make install

# use this gcc compiler from now on
ENV PATH=$INSTALL_PATH:$PATH

# install GSL v1.15 
RUN yum install -y texinfo
RUN cd /opt &&\
    wget http://ftp.gnu.org/pub/gnu/gsl/gsl-1.15.tar.gz &&\
    tar xvfz gsl-1.15.tar.gz &&\
    cd gsl-1.15 &&\
    ./configure --prefix=$INSTALL_PATH --disable-static &&\
	make &&\
	make check &&\
	make install
	
# install FGSL v0.9.4
RUN cd /opt &&\
    wget https://www.lrz.de/services/software/mathematik/gsl/fortran/download/fgsl-0.9.4.tar.gz &&\
    tar -vxzf fgsl-0.9.4.tar.gz &&\
    cd fgsl-0.9.4 &&\
    ./configure --gsl $INSTALL_PATH --f90 gfortran --prefix $INSTALL_PATH &&\
    make &&\
    make test &&\
    make install
    
# install fortran
RUN yum install -y gcc-gfortran
    
# install HDF5 v1.8.20
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/usr/local/lib64
RUN cd /opt &&\
    wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-1.8.20/src/hdf5-1.8.20.tar.gz &&\
    tar -vxzf hdf5-1.8.20.tar.gz &&\
    cd hdf5-1.8.20 &&\
    F9X=gfortran ./configure --prefix=$INSTALL_PATH --enable-fortran --enable-production &&\
    make &&\
    make install
   
# install FoX v4.1.0
RUN cd /opt &&\
    wget https://github.com/andreww/fox/archive/4.1.0.tar.gz &&\
    tar xvfz 4.1.0.tar.gz &&\
    cd fox-4.1.0 &&\
    FC=gfortran ./configure &&\
    make &&\
    make install
    
# install BLAS and LAPACK
RUN yum install -y blas blas-devel lapack

# install FFTW 3.3.4 (optional)
RUN cd /opt &&\
    wget ftp://ftp.fftw.org/pub/fftw/fftw-3.3.4.tar.gz &&\
    tar xvfz fftw-3.3.4.tar.gz &&\
    cd fftw-3.3.4 &&\
    ./configure --prefix=$INSTALL_PATH &&\
    make &&\
    make install
    
# install ANN 1.1.2 (optional)
RUN cd /opt &&\
    wget http://www.cs.umd.edu/~mount/ANN/Files/1.1.2/ann_1.1.2.tar.gz &&\
    tar xvfz ann_1.1.2.tar.gz &&\
    cd ann_1.1.2 &&\
    make linux-g++  &&\
    cp bin/* /usr/local/bin/.
    
# install Perl modules
RUN yum install -y expat-devel
RUN yum install -y perl &&\
    yum install -y cpan
ENV PERL_MM_USE_DEFAULT=1
RUN cpan -i YAML
RUN cpan -i Cwd
RUN cpan -i DateTime
RUN cpan -i Data::Dumper
RUN cpan -i File::Copy
RUN cpan -i File::Slurp
RUN cpan -i LaTeX::Encode
RUN cpan -i NestedMap
RUN cpan -i Scalar::Util
RUN cpan -i Term::ANSIColor
RUN cpan -i Text::Table
RUN cpan -i XML::SAX::ParserFactory
RUN cpan -i XML::Simple
RUN cpan -i XML::Validator::Schema
RUN cpan -i Sort::Topological
RUN cpan -i Text::Template
RUN cpan -i List::Uniq
RUN cpan -i XML::SAX::Expat
RUN cpan -i XML::Simple
RUN cpan -i DateTime
RUN cpan -i Regexp::Common
RUN cpan -i File::Next
RUN cpan -i XML::Validator::Schema
RUN cpan -i List::MoreUtils
 

# install Galacticus
RUN yum install -y patch zlib-devel
RUN yum install -y mercurial openssh-clients

RUN cd /usr/local &&\
    hg clone https://hg@bitbucket.org/galacticusdev/galacticus &&\
    cd galacticus &&\
    hg pull && hg update workflow
#    hg update v0.9.6
    
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/usr/lib64:/usr/local/lib
#RUN ln -s /usr/lib64/libblas.so.3 /usr/lib64/libblas.so

RUN cd /usr/local/galacticus &&\
    export GALACTICUS_EXEC_PATH=`pwd` &&\
    make Galacticus.exe   
    
# install matheval v1.1.11 (optional)
#RUN yum install -y guile-2.0 guile-2.0-dev
#RUN cd /opt &&\
#    wget https://ftp.gnu.org/gnu/libmatheval/libmatheval-1.1.10.tar.gz &&\
#    tar xvfz libmatheval-1.1.10.tar.gz &&\
#    cd libmatheval-1.1.10 &&\
#    ./configure --prefix=$INSTALL_PATH/
##############################################
# Stage 2 build
##############################################
FROM centos:6

# install system libraries that are needed at runtime
RUN yum -y update &&\
    yum -y install vim wget patch gcc-gfortran

# copy the full installation directory, including the executable
COPY --from=build /usr/local/galacticus /usr/local/galacticus 

# copy dynamically linked libraries
COPY --from=build /usr/local/lib64 /usr/local/lib64
COPY --from=build /usr/lib64 /usr/lib64
COPY --from=build /usr/local/lib /usr/local/lib
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/usr/local/lib64:/usr/lib64:/usr/local/lib
    
# download datasets
RUN cd /usr/local &&\
    wget http://users.obs.carnegiescience.edu/abenson/galacticus/versions/galacticus_datasets.tar.bz2 &&\
    tar xvfj galacticus_datasets.tar.bz2 &&\
    rm galacticus_datasets.tar.bz2
    
# setup for running
ENV GALACTICUS_EXEC_PATH=/usr/local/galacticus/
ENV GALACTICUS_DATA_PATH=/usr/local/galacticus_datasets
WORKDIR /usr/local/galacticus

# copy parameters template
COPY parameters/quickTest.xml /usr/local/galacticus/parameters/quickTest.xml

# script to execute the model with input arguments
COPY scripts/run_galacticus.sh /usr/local/galacticus/run_galacticus.sh

ENTRYPOINT /usr/local/galacticus/run_galacticus.sh