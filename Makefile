docker_tag 	= macropin/strider

UNAME_S         := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    APP_HOST            := localhost
endif
ifeq ($(UNAME_S),Darwin)
    APP_HOST            := $(shell docker-machine ip)
endif

build:
	docker build -t $(docker_tag) .

nocache:
	docker build --no-cache=true -t $(docker_tag) .

bash:
	docker run --rm -it $(docker_tag) bash

run:
	$(eval MONGO_ID := $(shell docker run -p 3000:3000 --name strider-mongo -d mongo))
	$(eval STRIDER_ID := $(shell docker run --env STRIDER_ADMIN_EMAIL=admin@example.com --env STRIDER_ADMIN_PASSWORD=password --name strider-app --link strider-mongo:mongo -d ${docker_tag}))
	$(eval STRIDER_IP := $(shell docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${STRIDER_ID}))
	@echo "Running ${STRIDER_ID} @ http://${STRIDER_IP}:3000"
	@echo "Running ${MONGO_ID} MongoDB"
	@docker attach ${STRIDER_ID}
	@docker kill ${STRIDER_ID} ${MONGO_ID}
	@docker rm ${STRIDER_ID} ${MONGO_ID}

clean:
	@docker ps -a | grep strider | awk '{ print $$1 }' | xargs -r docker rm -f
