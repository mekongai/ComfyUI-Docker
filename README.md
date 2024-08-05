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
  pvbang/comfyui-docker:latest-v1
```


## Option
### Docker Compose
```bash
git clone https://github.com/YanWenKun/ComfyUI-Docker.git

cd ComfyUI-Docker

docker compose up --detach
```


### Build Docker
```bash
docker build -t pvbang/comfyui-docker:latest-v1 .

docker push pvbang/comfyui-docker:latest-v1
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
docker stop ...
docker rm ...
docker rmi pvbang/comfyui-docker:latest
```