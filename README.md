```bash
MekongAI ComfyUI Docker
```


### Docker Run
```bash
mkdir -p storage

docker run -it \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -v "$(pwd)"/storage:/home/runner \
  -e CLI_ARGS="" \
  pvbang/mekongai-comfyui-docker:latest
```


## Option

### SSH Key
```bash
ssh-keygen -t rsa -b 2048 -f comfyui-1.pem
```


### Docker Compose
```bash
git clone https://github.com/pvbang/ComfyUI-Docker.git
cd ComfyUI-Docker
docker compose up --detach
```


### Build Docker
```bash
docker build -t pvbang/mekongai-comfyui-docker:latest .
docker push pvbang/mekongai-comfyui-docker:latest
```


### Update Docker
```bash
git pull
docker compose pull
docker compose up --detach --remove-orphans
docker image prune
```


### Delete Docker
```bash
dockerr ps
docker stop comfyui
docker rm comfyui

docker images
docker rmi pvbang/mekongai-comfyui-docker:latest
```
