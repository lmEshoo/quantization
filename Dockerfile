# FROM python:3.7
  
FROM ubuntu:18.04

LABEL Lini Mestar <liniMestar@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive
# RUN \
#   ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
#   apt-get install -y tzdata && \
#   dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get clean && apt-get update && apt-get install -y \
        build-essential checkinstall libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev \
        libgdbm-dev libc6-dev libbz2-dev zlib1g-dev openssl libffi-dev libjpeg-dev \
        python3-dev python3-setuptools python3-pip wget gcc \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /tmp/Python37; \
    cd /tmp/Python37; \
    wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tar.xz; \
    tar xvf Python-3.7.4.tar.xz; \
    cd /tmp/Python37/Python-3.7.4; \
    ./configure; \
    make install; \
    cd /; \
    rm -rf /tmp/Python37

RUN \
  apt-get -y update && \
  apt-get install -y \
    python-pip \
    python-dev \
    python-tk \
    python-setuptools \
    gcc \
    libtinfo-dev \
    zlib1g-dev \
    build-essential \
    cmake \
    curl \
    wget \
    ocl-icd-opencl-dev \
    libxml2-dev \
    libopencv-dev

RUN \
  apt-get install -y \
    libsm6 \
    libxrender1 \
    libfontconfig1 \
    python-opencv

RUN \  
  pip3 install --upgrade \
    https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-0.10.0-py3-none-any.whl && \
  pip3 install -U \
    decorator \
    antlr4-python3-runtime \
    attrs \
    numpy \
    scipy \
    scikit-learn \
    sklearn \
    torch \
    torchvision \
    plotly \
    tensorflow==1.15 \
    keras \
    h5py \
    matplotlib \
    onnx==1.5.0 \
    onnxruntime==1.0.0 \
    future \
    opencv-python \
    ipdb && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir /app && cd /app


ENV TVM_HOME=/app/tvm
ENV PYTHONPATH=$TVM_HOME/python:$TVM_HOME/topi/python:$TVM_HOME/nnvm/python

# RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.3.0-Linux-x86_64.sh -O ~/anaconda.sh && \
#     /bin/bash ~/anaconda.sh -b -p /opt/conda && \
#     rm ~/anaconda.sh && \
#     ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
#     echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc 
#     # echo "conda activate base" >> ~/.bashrc

ADD Quantization_PJ2 /app/Quantization_PJ2

ADD tvm /app/tvm

RUN cd /app/Quantization_PJ2 && \
    sh patch.sh && \
    cd $TVM_HOME && \
    cp cmake/config.cmake .

ENV LLVM_LINK=clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-16.04

RUN \
  wget http://releases.llvm.org/9.0.0/$LLVM_LINK.tar.xz && \
  tar xvf $LLVM_LINK.tar.xz 

RUN \
  apt-get -y update && \
  apt-get install -y \
    vim

RUN \
  cd $TVM_HOME && \
  sed -i.bak '121d' config.cmake && \
  sed -i.bak '121 i\
  set(USE_LLVM /app/tvm/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-16.04/bin/llvm-config)' config.cmake

RUN \
  cd $TVM_HOME && \
  mkdir build && \
  cd build && \
  cmake .. && \
  make -j4

# # Add NVIDIA package repositories
# RUN \ 
#   wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.0.130-1_amd64.deb && \
#   dpkg -i cuda-repo-ubuntu1804_10.0.130-1_amd64.deb && \
#   apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub && \
#   apt-get -y update && \
#   wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb && \
#   apt install ./nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb && \
#   apt-get -y update && \
#   apt-get install --no-install-recommends -y nvidia-driver-418 & \
#   apt-get install -y --no-install-recommends libnvinfer5=5.1.5-1+cuda10.0 \
#     libnvinfer-dev=5.1.5-1+cuda10.0

WORKDIR /src