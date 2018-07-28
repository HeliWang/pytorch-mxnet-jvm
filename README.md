## Dockerized Model Conversion Environment
#### Running environment for converting a deep learning model (PyTorch -> ONNX -> MxNet Python -> MxNet Scala)
#### Source code of the docker image [h379wang/pytorch-mxnet-jvm](https://hub.docker.com/r/h379wang/pytorch-mxnet-jvm/)

----------
### Build the docker image:
sudo docker build --tag h379wang/pytorch-mxnet-jvm .

### Run a docker container:
sudo docker run -it h379wang/pytorch-mxnet-jvm:latest /bin/bash

### Push the docker image:
sudo docker push h379wang/pytorch-mxnet-jvm

```
The running environment is built with:
  ubuntu:16.04
  default-jre 2:1.8-56ubuntu2
  default-jdk 2:1.8-56ubuntu
  maven 3.3.9-3
  scala 2.11.6-6
  python 3.5
  numpy 1.13.3
  incubator-mxnet python/scala (commit 35fb9ea / May 10, 2018)
  mkl 2018.2.199
  torch 0.4.0 (Apr 24, 2018)
  torchtext (commit caf9256)
```
