```bash
MekongAI ComfyUI Docker
```


## Config
### Docker Run
```bash
mkdir -p storage

docker run -it \
  --name comfyui \
  --gpus all \
  -p 7861:7861 \
  -v "$(pwd)"/storage:/home/runner \
  -e CLI_ARGS="" \
  pvbang/mekongai-comfyui:latest
  
# mkdir -p mekongai_comfyui_docker/storage && cd mekongai_comfyui_docker && docker run -it --name comfyui --gpus all -p 7861:7861 -v "$(pwd)"/storage:/home/runner -e CLI_ARGS="" pvbang/mekongai-comfyui:latest
```


### Docker Compose
```bash
docker-compose up --build
```


## Option
### Docker Compose
```bash
git clone https://github.com/pvbang/ComfyUI-Docker.git
cd ComfyUI-Docker
docker compose up --detach
```


### Build Docker
```bash
docker build -t pvbang/mekongai-comfyui:latest .
docker push pvbang/mekongai-comfyui:latest
```


### Delete Docker
```bash
dockerr ps
docker stop comfyui
docker rm comfyui

docker images
docker rmi pvbang/mekongai-comfyui:latest
```
