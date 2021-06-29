#Base Image
FROM ubuntu:18.04

#Install some commands.
RUN apt-get update && apt-get install -y \
    bear \
    build-essential \
    bc \
    kmod \
    libncurses-dev \
    python \
    wget \
    xxd \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/linaro
RUN wget http://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz \
 && tar xf gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz \
 && rm *.xz

WORKDIR /workspace2
WORKDIR /workspace

ENV CROSS_COMPILE=/opt/linaro/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu- \
    LOCALVERSION=-tegra \
    TEGRA_KERNEL_OUT=tegra_kernel_out

