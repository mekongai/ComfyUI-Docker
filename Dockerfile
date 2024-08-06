################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:cu121'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
# Using CUDA 12.1 & Python 3.11
################################################################################

FROM opensuse/tumbleweed:latest

LABEL maintainer="code@pvbang.fun"

# Install necessary packages including SSH server
RUN --mount=type=cache,target=/var/cache/zypp \
    zypper addrepo --check --refresh --priority 90 \
        'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/' packman-essentials \
    && zypper --gpg-auto-import-keys install --no-confirm \
        openssh openssh-server python311 python311-pip python311-wheel python311-setuptools \
        python311-devel python311-Cython gcc-c++ python311-py-build-cmake \
        python311-numpy python311-opencv \
        python311-ffmpeg-python ffmpeg x264 x265 \
        python311-dbm \
        google-noto-sans-fonts google-noto-sans-cjk-fonts google-noto-coloremoji-fonts \
        shadow git aria2 \
        Mesa-libGL1 libgthread-2_0-0 \
    && rm /usr/lib64/python3.11/EXTERNALLY-MANAGED \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 100

# Upgrade pip and install necessary Python packages
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        --upgrade pip wheel setuptools

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        xformers torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu121 \
        --extra-index-url https://pypi.org/simple

# Install additional dependencies for ComfyUI
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        -r https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/requirements.txt \
        -r https://raw.githubusercontent.com/crystian/ComfyUI-Crystools/main/requirements.txt \
        -r https://raw.githubusercontent.com/cubiq/ComfyUI_essentials/main/requirements.txt \
        -r https://raw.githubusercontent.com/Fannovel16/comfyui_controlnet_aux/main/requirements.txt \
        -r https://raw.githubusercontent.com/jags111/efficiency-nodes-comfyui/main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Impact-Pack/Main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Impact-Subpack/main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Inspire-Pack/main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/requirements.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        -r https://raw.githubusercontent.com/cubiq/ComfyUI_FaceAnalysis/main/requirements.txt \
        -r https://raw.githubusercontent.com/cubiq/ComfyUI_InstantID/main/requirements.txt \
        -r https://raw.githubusercontent.com/Fannovel16/ComfyUI-Frame-Interpolation/main/requirements-no-cupy.txt \
        cupy-cuda12x \
        -r https://raw.githubusercontent.com/FizzleDorf/ComfyUI_FizzNodes/main/requirements.txt \
        -r https://raw.githubusercontent.com/kijai/ComfyUI-KJNodes/main/requirements.txt \
        -r https://raw.githubusercontent.com/melMass/comfy_mtb/main/requirements.txt \
        -r https://raw.githubusercontent.com/MrForExample/ComfyUI-3D-Pack/main/requirements.txt \
        -r https://raw.githubusercontent.com/storyicon/comfyui_segment_anything/main/requirements.txt \
        -r https://raw.githubusercontent.com/ZHO-ZHO-ZHO/ComfyUI-InstantID/main/requirements.txt \
        compel lark torchdiffeq fairscale \
        python-ffmpeg

# Fix ONNX Runtime "missing CUDA provider" and Mediapipe dependencies
RUN --mount=type=cache,target=/root/.cache/pip \
    pip uninstall --break-system-packages --yes \
        onnxruntime-gpu \
    && pip --no-cache-dir install --break-system-packages \
        onnxruntime-gpu \
        --index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/ \
        --extra-index-url https://pypi.org/simple \
    && pip install --break-system-packages \
        mediapipe

# Set library paths for CUDA and other dependencies
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}\
:/usr/local/lib64/python3.11/site-packages/torch/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cuda_cupti/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cuda_runtime/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cudnn/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cufft/lib"

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}\
:/usr/local/lib/python3.11/site-packages/nvidia/cublas/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cuda_nvrtc/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/curand/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cusolver/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cusparse/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/nccl/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/nvjitlink/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/nvtx/lib"

# Create a low-privilege user and set up SSH
RUN printf 'CREATE_MAIL_SPOOL=no' >> /etc/default/useradd \
    && mkdir -p /home/runner /home/scripts /home/runner/.ssh \
    && groupadd runner \
    && useradd runner -g runner -d /home/runner \
    && chown runner:runner /home/runner /home/scripts \
    && chmod 700 /home/runner/.ssh

COPY --chown=runner:runner scripts/. /home/scripts/

USER root

# Configure SSH server
RUN mkdir -p /var/run/sshd && \
    echo 'runner:password' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22 8188
CMD ["/usr/sbin/sshd", "-D"]
