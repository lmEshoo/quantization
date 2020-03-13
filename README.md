# Model Quantization

For this example, we are using a pretrained [mobilenet v2](https://github.com/tensorflow/models/tree/master/research/slim/nets/mobilenet) model.

## Quantize

### Requirements
- Installing Docker
There’s a graphical installer for Windows and Mac that makes installing Docker easy. Here are instructions for each OS:

    [Windows](https://docs.docker.com/docker-for-windows/install/)

    [Mac OS](https://docs.docker.com/docker-for-mac/install/)

    [Linux](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/)

### Build
```
docker pull lmestar/tvm:0.1.1
```

### Run 
```
make
```

## Evaluation

Evaluation was done using [Google Colab](https://colab.research.google.com/). 

- Once you opened the notebook, upload all `./eval/` into the Colab enviroment and run.
