FROM ubuntu:16.04
MAINTAINER Heli Wang "h379wang@edu.uwaterloo.ca"

RUN apt-get update
RUN apt-get install -y default-jre
RUN apt-get install -y default-jdk
RUN apt-get install dialog apt-utils -y
RUN apt-get -y install curl
RUN apt-get -y install wget

# Install Dependencies
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y build-essential git
RUN apt-get install -y libatlas-base-dev
RUN apt-get install -y libopenblas-dev liblapack-dev
RUN apt-get install -y libopencv-dev
RUN update-alternatives --config java
RUN apt-get install -y maven
RUN apt-get install -y scala

# Install ccache
RUN apt install -y ccache --assume-yes
RUN /usr/sbin/update-ccache-symlinks
RUN echo 'export PATH="/usr/lib/ccache:$PATH"' | tee -a ~/.bashrc
RUN export PATH="/usr/lib/ccache:$PATH"

# Install MKL
WORKDIR /app/
RUN wget -O l_mkl_2018.2.199.tgz http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/12725/l_mkl_2018.2.199.tgz
RUN tar -xzf l_mkl_2018.2.199.tgz
WORKDIR /app/l_mkl_2018.2.199
RUN apt-get install -y cpio
COPY ./l_mkl_2018.2.199/silent.cfg /app/l_mkl_2018.2.199/silent.cfg
RUN rm -f l_mkl_2018.2.199.tgz
RUN ./install.sh -s silent.cfg
COPY ./l_mkl_2018.2.199/libiomp5.so /opt/intel/compilers_and_libraries_2018/linux/lib/intel64/libiomp5.so

# Install MXNet
COPY ./incubator-mxnet /app/incubator-mxnet
WORKDIR /app/
WORKDIR /app/incubator-mxnet
RUN apt-get autoclean
RUN apt-get clean

RUN apt install -y libjemalloc-dev
RUN /bin/bash -c "source /opt/intel/bin/compilervars.sh intel64 ; make -j ${nproc} ; echo 'Finished!'"
RUN /bin/bash -c "source /opt/intel/bin/compilervars.sh intel64 ; make scalapkg ; echo 'Finished!'"
RUN /bin/bash -c "source /opt/intel/bin/compilervars.sh intel64 ; make scalainstall ; echo 'Finished!'"

# Install Python2/3
#RUN sudo add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update
RUN apt-get install -y python-dev python-setuptools python-pip libgfortran3 python3.5 python3-pip --assume-yes
RUN pip3 install numpy==1.13.3

# Install Mxnet (Python)
WORKDIR python
RUN pip3 install -e .
RUN apt-get install graphviz --assume-yes
RUN pip3 install graphviz==0.8.1
WORKDIR /

# Install Protobuf
COPY ./installprotobuf.sh /app/installprotobuf.sh
RUN bash /app/installprotobuf.sh

# Install ONNX
COPY ./onnx /app/onnx
WORKDIR /app/
RUN pip3 install --upgrade pybind11
RUN python3 -m pybind11 --includes
RUN pip3 install -e onnx/

# Install Torch
RUN pip3 install torch==0.3.1
RUN pip3 install torchtext==0.2.3
