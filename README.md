```bash
MekongAI ComfyUI Docker
```

## Config

### Tạo cặp khóa SSH cho mỗi người dùng
```bash
ssh-keygen -t rsa -b 2048 -f ~/.ssh/user1_key
ssh-keygen -t rsa -b 2048 -f ~/.ssh/user2_key
# Lặp lại cho từng người dùng
```


### Lưu trữ các khóa công khai
```bash
mkdir -p storage/ssh_keys
cp ~/.ssh/user1_key.pub storage/ssh_keys/user1_key.pub
cp ~/.ssh/user2_key.pub storage/ssh_keys/user2_key.pub
```


### Tạo thư mục lưu trữ cho từng người dùng
```bash
mkdir -p storage/user1/data
mkdir -p storage/user2/data
# Lặp lại cho từng người dùng
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
  pvbang/mekongai-comfyui:latest
```


### Docker Compose
```bash
docker-compose up --build
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
docker build -t pvbang/mekongai-comfyui:latest .
docker push pvbang/mekongai-comfyui:latest
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
docker rmi pvbang/mekongai-comfyui:latest
```
