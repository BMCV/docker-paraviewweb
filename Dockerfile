FROM ubuntu:16.10

MAINTAINER Thomas Wollmann <thomas.wollmann@bioquant.uni-heidelberg.de>

RUN apt-get -q update && \

    apt-get -q -y install build-essential software-properties-common \
    curl git python python-dev make libosmesa6-dev libglu1-mesa-dev && \
    curl -s https://bootstrap.pypa.io/get-pip.py | python2

RUN apt-get -q -y install cmake

ENV PARAVIEW_VERSION=5.2.0 \
    PARAVIEW_VERSHORT=5.2
	
# Compile 
RUN mkdir -p /root/build && cd /root/build && \
    curl "http://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v${PARAVIEW_VERSHORT}&type=source&os=all&downloadFile=ParaView-v${PARAVIEW_VERSION}.tar.gz" | tar xz && \
    rm -R ParaView-v${PARAVIEW_VERSION}/Plugins/* && \
    mkdir -p /root/build/pv-bin && cd /root/build/pv-bin && \
    cmake \
        -D CMAKE_BUILD_TYPE=Release \
        -D BUILD_TESTING:BOOL=OFF \
        -D BUILD_DOCUMENTATION:BOOL=OFF \
	-D BUILD_EXAMPLES:BOOL=OFF \
	-D PARAVIEW_BUILD_QT_GUI:BOOL=OFF \
        -D PARAVIEW_ENABLE_PYTHON:BOOL=ON \
	-D PARAVIEW_ENABLE_WEB:BOOL=ON \
        -D PARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=OFF \
        -D VTK_USE_X:BOOL=OFF \
	-D VTK_USE_OFFSCREEN:BOOL=ON \
        -D VTK_OPENGL_HAS_OSMESA:BOOL=ON \
        -D OSMESA_INCLUDE_DIR=/usr/include \
        -D OSMESA_LIBRARY=/usr/lib/x86_64-linux-gnu/libOSMesa.so \
        ../ParaView-v${PARAVIEW_VERSION} && \
    make -j4 && make install && \
    rm -rf ParaView-v${PARAVIEW_VERSION} && rm -rf /root/build
    
# Proxy
RUN apt-get -q -y install nginx
ADD nginx.conf /etc/nginx/sites-available/paraviewweb
RUN ln -s /etc/nginx/sites-available/paraviewweb /etc/nginx/sites-enabled/paraviewweb && \
    rm /etc/nginx/sites-enabled/default

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
