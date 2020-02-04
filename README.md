# tvm
Model Quantization

### Requirements
- Installing Docker
There’s a graphical installer for Windows and Mac that makes installing Docker easy. Here are instructions for each OS:

    [Windows](https://docs.docker.com/docker-for-windows/install/)

    [Mac OS](https://docs.docker.com/docker-for-mac/install/)

    [Linux](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/)

- Clone Project

```
git clone git@github.com:lmEshoo/Quantization_PJ2.git
```

## Build
Pull Docker image
```
docker pull lmestar/tvm:0.0.6
```

## Implement 
Start a container with `quantization_utils.py` mounted into the container.
```
make
```