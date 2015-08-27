#!/usr/bin/env bash

set -e

# Create a DB_URI from linked container. See variables above.
if [ -z "$DB_URI" ]; then
    export DB_URI="mongodb://${MONGO_PORT_27017_TCP_ADDR:-localhost}:${MONGO_PORT_27017_TCP_PORT:-27017}/strider"
    echo 'export DB_URI="mongodb://${MONGO_PORT_27017_TCP_ADDR:-localhost}:${MONGO_PORT_27017_TCP_PORT:-27017}/strider"' > $HOME/.bashrc
    echo "$(basename $0) >> Set DB_URI=$DB_URI"
fi

# Update npm cache if no modules exist
if [ ! -d "${STRIDER_HOME}/node_modules" ]; then
    echo "$(basename $0) >> Copying node_modules from cache..."
    mkdir -p ${STRIDER_HOME}/node_modules
    cp -r --preserve=mode,timestamps,links,xattr ${STRIDER_SRC}/node_modules.cache/* ${STRIDER_HOME}/node_modules/
fi

# Create admin user if variables defined
if [ ! -z "$STRIDER_ADMIN_EMAIL" -a ! -z "$STRIDER_ADMIN_PASSWORD" ]; then
    echo "$(basename $0) >> Running addUser"
    strider addUser --email $STRIDER_ADMIN_EMAIL --password $STRIDER_ADMIN_PASSWORD --admin true
    echo "$(basename $0) >> Created Admin User: $STRIDER_ADMIN_EMAIL, Password: $STRIDER_ADMIN_PASSWORD"
fi

echo "Exec'ing command $@"
exec "$@"
