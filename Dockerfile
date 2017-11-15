FROM nginx

MAINTAINER Thomas Wollmann <thomas.wollmann@bioquant.uni-heidelberg.de>

ENV CONDA /miniconda/
ENV PATH $CONDA/bin:$PATH

RUN apt-get update && \
    apt-get install -y wget bzip2 curl && \
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
    
RUN     apt-get install -y nodejs && \
	wget -q http://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh && \
	bash Miniconda2-latest-Linux-x86_64.sh -p /miniconda -b && \
	rm Miniconda2-latest-Linux-x86_64.sh && \
	rm -rf /var/lib/apt/lists/* && \
	apt-get purge -y wget && \
	echo "export PATH=\"$CONDA/bin:\$PATH\"" >> ~/.bash_rc && \
	echo "export LD_LIBRARY_PATH=\"$LD_LIBRARY_PATH:/miniconda/lib/paraview-5.2\""  >> ~/.bash_rc && \
	source ~/.bash_rc


RUN conda install paraview==5.4.1 -c bioconda -c conda-forge -y && \
    npm install -g pvw-visualizer@2.0.18

RUN echo $CONDA/lib/paraview-5.2/ > /etc/ld.so.conf.d/paraview.conf && \
    ldconfig && \
    mkdir /usr/local/opt/ && \
    mkdir /Applications

ADD nginx.conf /etc/nginx/nginx.conf

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
