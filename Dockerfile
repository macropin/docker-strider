FROM node:latest
MAINTAINER Andrew Cutler <andrew@panubo.io> 


COPY entry.sh /
EXPOSE 3000

ENV STRIDER_VERSION=master STRIDER_GIT_SRC=https://github.com/Strider-CD/strider.git STRIDER_HOME=/data STRIDER_SRC=/opt/strider

RUN mkdir -p $STRIDER_SRC

ENV NODE_ENV production

RUN useradd --comment "Strider CD" --home ${STRIDER_HOME} strider && mkdir -p ${STRIDER_HOME} && chown strider:strider ${STRIDER_HOME}
CMD chown -R strider:strider /opt/strider
USER strider

VOLUME [ "$STRIDER_HOME" ]

RUN cd $STRIDER_SRC && \
    # Checkout into $STRIDER_SRC
    git clone $STRIDER_GIT_SRC . && \
    [ "$STRIDER_VERSION" != 'master' ] && git checkout tags/$STRIDER_VERSION || git checkout master && \
  #  rm -rf .git && \ optional: switch to another code base
    # Install NPM deps
    npm install && \
    # Generate API Docs
    npm install apidoc && npm run gendocs && \
    # Create link to strider home dir so the modules can be used as a cache
    mv node_modules node_modules.cache && ln -s ${STRIDER_HOME}/node_modules node_modules && \
    # Allow strider user to update .restart file
    chown strider:strider ${STRIDER_SRC}/.restart && \
    # Cleanup Upstream cruft
    rm -rf /tmp/*

ENV PATH ${STRIDER_SRC}/bin:$PATH

ENTRYPOINT ["/entry.sh"]
CMD ["strider"]
