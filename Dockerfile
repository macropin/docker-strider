FROM node:latest

MAINTAINER Andrew Cutler <andrew@panubo.io> 

ENV STRIDER_GIT_SRC=https://github.com/Strider-CD/strider.git

RUN useradd --comment "Strider CD" --home /data strider && mkdir -p /data && chown strider:strider /data
VOLUME ["/data"]

RUN cd /opt && \
    git clone $STRIDER_GIT_SRC && \
    cd strider && npm install && \
    rm -rf /tmp/*

ENV PATH /opt/strider/bin:$PATH

COPY entry.sh /
USER strider
ENTRYPOINT ["/entry.sh"]
CMD ["strider"]

EXPOSE 3000

