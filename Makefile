USER=lmestar
CONTAINER_NAME=tvm
IMAGE=$(USER)/$(CONTAINER_NAME):0.0.6

all: up

build:
	docker build -t $(IMAGE) .

up:
	docker run -it --rm \
	-v $(PWD)/models/:/src/models/ \
	-v $(PWD)/Quantization_PJ2/main.py:/src/main.py \
	-v $(PWD)/quantization_utils.py:/app/tvm/python/tvm/relay/utils/quantization_utils.py \
	--name $(CONTAINER_NAME) $(IMAGE) \
	bash -c "cd /src && bash"

go:
	docker exec -it $(CONTAINER_NAME) bash