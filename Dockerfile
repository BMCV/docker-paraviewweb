FROM ubuntu:16.10

MAINTAINER Thomas Wollmann <thomas.wollmann@bioquant.uni-heidelberg.de>

RUN apt-get -q update && \
    apt-get -q -y upgrade && \
    apt-get -q -y install paraview nginx && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /input && mkdir /output

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
