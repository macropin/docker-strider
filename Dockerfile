FROM node:latest

MAINTAINER Andrew Cutler <andrew@panubo.io> 

EXPOSE 3000

ENV STRIDER_GIT_SRC=https://github.com/Strider-CD/strider.git

RUN useradd --comment "Strider CD" --home /data strider && mkdir -p /data && chown strider:strider /data
VOLUME ["/data"]

RUN cd /opt && \
    git clone $STRIDER_GIT_SRC && \
    cd strider && npm install && \
    # Create link to strider home dir so the modules can be used as a cache
    mv node_modules node_modules.cache && ln -s /data/node_modules node_modules && \
    # Allow strider user to update .restart file
    chown strider:strider /opt/strider/.restart && \
    # Cleanup Upstream cruft
    rm -rf /tmp/*

ENV PATH /opt/strider/bin:$PATH

COPY entry.sh /
USER strider
ENTRYPOINT ["/entry.sh"]
CMD ["strider"]
