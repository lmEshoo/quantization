USER=lmestar
CONTAINER_NAME=tvm
IMAGE=$(USER)/$(CONTAINER_NAME):0.1

all: quantize

build:
	docker build -t $(IMAGE) .

up:
	docker run -it --rm \
	-v $(PWD)/models/:/src/models/ \
	-v $(PWD)/eval/:/src/eval/ \
	-v $(PWD)/Quantization_PJ2/main.py:/src/main.py \
	-v $(PWD)/Quantization_PJ2/ILSVRC2012_val_00001110.JPEG:/src/ILSVRC2012_val_00001110.JPEG \
	-v $(PWD)/quantization_utils.py:/app/tvm/python/tvm/relay/utils/quantization_utils.py \
	--name $(CONTAINER_NAME) $(IMAGE) \
	bash -c "cd /src && bash"

quantize:
	docker run -it --rm \
	-v $(PWD)/models/:/src/models/ \
	-v $(PWD)/eval/:/src/eval/ \
	-v $(PWD)/Quantization_PJ2/main.py:/src/main.py \
	-v $(PWD)/Quantization_PJ2/ILSVRC2012_val_00001110.JPEG:/src/ILSVRC2012_val_00001110.JPEG \
	-v $(PWD)/quantization_utils.py:/app/tvm/python/tvm/relay/utils/quantization_utils.py \
	--name $(CONTAINER_NAME) $(IMAGE) \
	bash -c "cd /src && python3 main.py \
		--input models/mobilenet_v2_1.0_224.pb \
		--input_shape 1 224 224 3 \
		--output_dir ./eval/tmp_mobile_quant \
		--gen_pb --gen_fx_pb \
		--reference_input ILSVRC2012_val_00001110.JPEG \
		--dump --preprocess tf_mobilenet && bash"

go:
	docker exec -it $(CONTAINER_NAME) bash