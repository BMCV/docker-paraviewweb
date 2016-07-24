FROM ubuntu:16.04

MAINTAINER Thomas Wollmann <thomas.wollmann@bioquant.uni-heidelberg.de>

RUN apt-get -q update && \
    apt-get -q -y upgrade && \
    apt-get -q -y install build-essential software-properties-common \
    curl wget git python python-dev make libosmesa6-dev libglu1-mesa-dev && \
    curl -s https://bootstrap.pypa.io/get-pip.py | python2

RUN apt-get -q -y install cmake

# Compile 
RUN mkdir -p /root/build && cd /root/build && \
    git clone git://paraview.org/ParaView.git pv-git && cd pv-git && \
    git checkout v5.1.0 && git submodule init && git submodule update && \

    mkdir -p /root/build/pv-bin && cd /root/build/pv-bin && \
    cmake \
        -D CMAKE_BUILD_TYPE=Release \
        -D BUILD_TESTING:BOOL=OFF \
        -D PARAVIEW_BUILD_QT_GUI:BOOL=OFF \
        -D PARAVIEW_ENABLE_PYTHON:BOOL=ON \
        -D PARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=OFF \
        -D OPENGL_INCLUDE_DIR=/usr/include \
        -D OPENGL_gl_LIBRARY="" \
        -D OPENGL_glu_LIBRARY=/usr/lib/x86_64-linux-gnu/libGLU.so \
        -D VTK_USE_X:BOOL=OFF \
        -D VTK_OPENGL_HAS_OSMESA:BOOL=ON \
        -D OSMESA_INCLUDE_DIR=/usr/include \
        -D OSMESA_LIBRARY=/usr/lib/x86_64-linux-gnu/libOSMesa.so \
        ../pv-git && \
    make -j4 && make install && \
    cd / && rm -rf /root/build

RUN mkdir /input
RUN mkdir /export
WORKDIR /input

ENV DEBUG=false \
    GALAXY_WEB_PORT=10000 \
    NOTEBOOK_PASSWORD=none \
    CORS_ORIGIN=none \
    DOCKER_PORT=none \
    API_KEY=none \
    HISTORY_ID=none \
    REMOTE_HOST=none \
    GALAXY_URL=none

EXPOSE 8777

ADD startup.sh /
RUN chmod +x /startup.sh
CMD /startup.sh
