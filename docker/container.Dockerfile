ARG BASE_IMAGE=pytorch/pytorch:1.12.1-cuda11.3-cudnn8-devel
# docker pull pytorch/pytorch:1.12.1-cuda11.3-cudnn8-devel
FROM ${BASE_IMAGE}

ARG USER_NAME=zed
ARG USER_ID=1000


# Prevent anything requiring user input
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=linux

ENV TZ=America
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Basic packages
RUN apt-get -y update \
    && apt-get -y install \
      python3-pip \
      sudo \
      vim \
      wget \
      curl \
      software-properties-common \
      doxygen \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y lsb-release && apt-get clean all
# Install ROS noetic (desktop full)
# RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
# RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

# RUN apt-get -y update \
#     && apt-get -y install ros-noetic-desktop-full \
#     && rm -rf /var/lib/apt/lists/*  

# # Auxillary ROS installs
# RUN apt-get -y update \
#     && apt-get -y install \ 
#       python3-rosdep \
#       python3-rosinstall \
#       python3-rosinstall-generator \
#       python3-wstool \
#       build-essential \
#       python3-catkin-tools \
#       ros-noetic-ros-numpy \
#       ros-noetic-derived-object-msgs \
#       ros-noetic-ackermann-msgs \
#       ros-noetic-hector-trajectory-server \
#     && rm -rf /var/lib/apt/lists/*  

# # Extra misc installs
# RUN apt-get -y update \
#     && sudo apt-get -y install \ 
#       libomp-dev \
#       mesa-utils \
#       apt-utils \
#     && rm -rf /var/lib/apt/lists/*  

# # Cloner-specific installs
COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install -r /tmp/requirements.txt \
#      && pip3 install opencv-python pykitti \
#      && pip3 install --user git+https://github.com/DanielPollithy/pypcd.git \
#      && pip3 install rospkg \
#      && pip3 install pycryptodomex \
#      && pip3 install gnupg \
#      && pip3 install opencv-python==4.5.5.64 \
#      && pip3 install open3d \
#      && pip3 install autopep8 \
#      && pip3 install torch_tb_profiler \
#      && pip3 install torchviz \
#      && pip3 install --upgrade typing-extensions \
#      && pip3 install more_itertools \
#      && pip3 install pymesh \
#      && pip3 install trimesh \
     && rm /tmp/requirements.txt

# Install tiny-cuda-nn
# RUN ldconfig && pip3 install git+https://github.com/NVlabs/tiny-cuda-nn/#subdirectory=bindings/torch || \
#     (echo "Note: Unable find Cuda. See the README Build Section for details on fixing" && false)

# RUN ldconfig && pip3 install "git+https://github.com/facebookresearch/pytorch3d.git@v0.7.2"

# RUN apt update && apt install -y libsm6 libxext6 && rm -rf /var/lib/apt/lists/*
# RUN apt-get install -y libxrender-dev && rm -rf /var/lib/apt/lists/*
# RUN apt-get update && apt-get -y install cmake protobuf-compiler
# RUN apt remove --purge --auto-remove cmake

# RUN sudo apt update && \
#     sudo apt install -y software-properties-common lsb-release && \
#     sudo apt clean all \
#     && rm -rf /var/lib/apt/lists/*

# RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null 

# RUN sudo apt update && \
#     sudo apt install -y software-properties-common lsb-release && \
#     sudo apt clean all \
#     && rm -rf /var/lib/apt/lists/*

# RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main'

# RUN sudo apt update
# RUN sudo apt install kitware-archive-keyring
# RUN sudo rm /etc/apt/trusted.gpg.d/kitware.gpg

# RUN sudo apt update
# RUN sudo apt install cmake

RUN apt-get update \
  && apt-get -y install build-essential \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/* \
  && wget https://github.com/Kitware/CMake/releases/download/v3.24.1/cmake-3.24.1-Linux-x86_64.sh \
      -q -O /tmp/cmake-install.sh \
      && chmod u+x /tmp/cmake-install.sh \
      && mkdir /opt/cmake-3.24.1 \
      && /tmp/cmake-install.sh --skip-license --prefix=/opt/cmake-3.24.1 \
      && rm /tmp/cmake-install.sh \
      && ln -s /opt/cmake-3.24.1/bin/* /usr/local/bin

RUN useradd -m -l -u ${USER_ID} -s /bin/bash ${USER_NAME} \
    && usermod -aG video ${USER_NAME}

# Give them passwordless sudo
RUN echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch to user to run user-space commands
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

# RUN sudo rosdep init && rosdep update

# # finish ROS setup
# RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc

# This overrides the default CarlaSim entrypoint, which we want. Theirs starts the simulator.
COPY ./entrypoint.sh /entrypoint.sh
RUN sudo chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]