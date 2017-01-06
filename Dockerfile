FROM nginx

MAINTAINER Thomas Wollmann <thomas.wollmann@bioquant.uni-heidelberg.de>

ENV PATH /miniconda/bin:$PATH

RUN apt-get update && apt-get install -y wget bzip2 && \
	wget -q http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
	bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b && \
	rm Miniconda3-latest-Linux-x86_64.sh && \
	rm -rf /var/lib/apt/lists/* && \
	apt-get purge -y wget && \
	conda install paraview -c bioconda -c conda-forge -y

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
