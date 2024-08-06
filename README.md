```bash
MekongAI ComfyUI Docker
```

## Config

### Tạo cặp khóa SSH cho mỗi người dùng
```bash
ssh-keygen -t rsa -b 2048 -f ~/.ssh/user1_key -N ""
ssh-keygen -t rsa -b 2048 -f ~/.ssh/user2_key -N ""
ssh-keygen -t rsa -b 2048 -f ~/.ssh/user3_key -N ""
ssh-keygen -t rsa -b 2048 -f ~/.ssh/user4_key -N ""
ssh-keygen -t rsa -b 2048 -f ~/.ssh/user5_key -N ""
ssh-keygen -t rsa -b 2048 -f ~/.ssh/user6_key -N ""
ssh-keygen -t rsa -b 2048 -f ~/.ssh/user7_key -N ""
ssh-keygen -t rsa -b 2048 -f ~/.ssh/user8_key -N ""

```


### Lưu trữ các khóa công khai
```bash
mkdir -p storage/user{1..8}/data storage/user{1..8}/ssh

# Copy each user's public key to their respective directory
cp ~/.ssh/user1_key.pub storage/user1/ssh/authorized_keys
cp ~/.ssh/user2_key.pub storage/user2/ssh/authorized_keys
cp ~/.ssh/user3_key.pub storage/user3/ssh/authorized_keys
cp ~/.ssh/user4_key.pub storage/user4/ssh/authorized_keys
cp ~/.ssh/user5_key.pub storage/user5/ssh/authorized_keys
cp ~/.ssh/user6_key.pub storage/user6/ssh/authorized_keys
cp ~/.ssh/user7_key.pub storage/user7/ssh/authorized_keys
cp ~/.ssh/user8_key.pub storage/user8/ssh/authorized_keys

# Set permissions for each user's directories
chown -R $(whoami):$(whoami) storage/user{1..8}
chmod 700 storage/user{1..8}/ssh
chmod 600 storage/user{1..8}/ssh/authorized_keys
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
  
 # User 1
docker run -d \
  --name comfyui_user1 \
  --gpus '"device=0"' \
  -p 5656:22 \        
  -p 8181:8188 \      
  -v "$(pwd)/storage/user1/data:/home/runner/data" \
  -v "$(pwd)/storage/user1/ssh/authorized_keys:/home/runner/.ssh/authorized_keys:ro" \
  pvbang/mekongai-comfyui:latest

# User 2
docker run -d \
  --name comfyui_user2 \
  --gpus '"device=1"' \
  -p 5657:22 \        
  -p 8182:8188 \      
  -v "$(pwd)/storage/user2/data:/home/runner/data" \
  -v "$(pwd)/storage/user2/ssh/authorized_keys:/home/runner/.ssh/authorized_keys:ro" \
  pvbang/mekongai-comfyui:latest

# User 3
docker run -d \
  --name comfyui_user3 \
  --gpus '"device=2"' \
  -p 5658:22 \        
  -p 8183:8188 \      
  -v "$(pwd)/storage/user3/data:/home/runner/data" \
  -v "$(pwd)/storage/user3/ssh/authorized_keys:/home/runner/.ssh/authorized_keys:ro" \
  pvbang/mekongai-comfyui:latest

# User 4
docker run -d \
  --name comfyui_user4 \
  --gpus '"device=3"' \
  -p 5659:22 \        
  -p 8184:8188 \      
  -v "$(pwd)/storage/user4/data:/home/runner/data" \
  -v "$(pwd)/storage/user4/ssh/authorized_keys:/home/runner/.ssh/authorized_keys:ro" \
  pvbang/mekongai-comfyui:latest

# User 5
docker run -d \
  --name comfyui_user5 \
  --gpus '"device=4"' \
  -p 5660:22 \        
  -p 8185:8188 \      
  -v "$(pwd)/storage/user5/data:/home/runner/data" \
  -v "$(pwd)/storage/user5/ssh/authorized_keys:/home/runner/.ssh/authorized_keys:ro" \
  pvbang/mekongai-comfyui:latest

# User 6
docker run -d \
  --name comfyui_user6 \
  --gpus '"device=5"' \
  -p 5661:22 \        
  -p 8186:8188 \      
  -v "$(pwd)/storage/user6/data:/home/runner/data" \
  -v "$(pwd)/storage/user6/ssh/authorized_keys:/home/runner/.ssh/authorized_keys:ro" \
  pvbang/mekongai-comfyui:latest

# User 7
docker run -d \
  --name comfyui_user7 \
  --gpus '"device=6"' \
  -p 5662:22 \        
  -p 8187:8188 \      
  -v "$(pwd)/storage/user7/data:/home/runner/data" \
  -v "$(pwd)/storage/user7/ssh/authorized_keys:/home/runner/.ssh/authorized_keys:ro" \
  pvbang/mekongai-comfyui:latest

# User 8
docker run -d \
  --name comfyui_user8 \
  --gpus '"device=7"' \
  -p 5663:22 \        
  -p 8188:8188 \      
  -v "$(pwd)/storage/user8/data:/home/runner/data" \
  -v "$(pwd)/storage/user8/ssh/authorized_keys:/home/runner/.ssh/authorized_keys:ro" \
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
