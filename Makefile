BASE_IMAGE_NAME=rocker/tidyverse

IMAGE_NAME=tidyverse
CONTAINER_NAME=$(IMAGE_NAME)-container

PORT_EXPOSED_BY_CONTAINER=8787
PORT_EXPOSED_TO_HOST=8787

build: pull
	docker build -t $(IMAGE_NAME) .

pull:
	docker pull $(BASE_IMAGE_NAME)

# -- if your host port is taken, do a `make run PORT_EXPOSED_TO_HOST=<some_open_port>`
run:
	docker run -d \
    --name $(CONTAINER_NAME) \
    -p $(PORT_EXPOSED_TO_HOST):$(PORT_EXPOSED_BY_CONTAINER) \
    -v $(PWD):/host \
    $(IMAGE_NAME) \
    start-notebook.sh \
    --NotebookApp.iopub_data_rate_limit=10000000 \
    --NotebookApp.token=''

stop:
	docker stop $(CONTAINER_NAME) -t 1 && docker rm $(CONTAINER_NAME)

clean: stop
	docker rmi $(IMAGE_NAME)
