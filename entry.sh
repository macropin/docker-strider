#!/usr/bin/env bash

set -e

# These are the variables from a linked MongoDB container
# MONGO_ENV_MONGO_MAJOR=3.0
# MONGO_ENV_MONGO_VERSION=3.0.3
# MONGO_NAME=/strider-app/mongo
# MONGO_PORT=tcp://172.17.0.15:27017
# MONGO_PORT_27017_TCP=tcp://172.17.0.15:27017
# MONGO_PORT_27017_TCP_ADDR=172.17.0.15
# MONGO_PORT_27017_TCP_PORT=27017
# MONGO_PORT_27017_TCP_PROTO=tcp

# Create a DB_URI from linked container. See variables above.
if [ -z "$DB_URI" ]; then
    export DB_URI="mongodb://${MONGO_PORT_27017_TCP_ADDR-localhost}:${MONGO_PORT_27017_TCP_PORT-27017}/strider"
    echo 'export DB_URI="mongodb://${MONGO_PORT_27017_TCP_ADDR-localhost}:${MONGO_PORT_27017_TCP_PORT-27017}/strider"' > $HOME/.bashrc
    echo "$(basename $0) >> Set DB_URI=$DB_URI"
fi

# Update npm cache if no modules exist
if [ ! -d "/data/node_modules" ]; then
    echo "$(basename $0) >> Copying node_modules from cache..."
    mkdir -p /data/node_modules
    cp -r --preserve=mode,timestamps,links,xattr /opt/strider/node_modules.cache/* /data/node_modules/
fi

# Create admin user if variables defined
if [ ! -z "$STRIDER_ADMIN_EMAIL" -a ! -z "$STRIDER_ADMIN_PASSWORD" ]; then
    echo "$(basename $0) >> Running addUser"
    strider addUser --email $STRIDER_ADMIN_EMAIL --password $STRIDER_ADMIN_PASSWORD --admin true
    echo "$(basename $0) >> Created Admin User: $STRIDER_ADMIN_EMAIL, Password: $STRIDER_ADMIN_PASSWORD"
fi

echo "Exec'ing command $@"
exec "$@"
