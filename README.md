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
  pvbang/comfyui-docker:latest
```

### Delete Docker
```bash
docker stop ...
docker rm ...
docker rmi pvbang/comfyui-docker:latest
```