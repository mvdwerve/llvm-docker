FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y gpgv2 wget software-properties-common
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
RUN apt update && apt install -y build-essential cmake git ninja-build python3
RUN git clone --depth 1 https://github.com/llvm/llvm-project.git
RUN cd /llvm-project/ && git checkout -b release/10.x
RUN mkdir /llvm-project/build && cd /llvm-project/build && cmake -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" -DLLVM_USE_LINKER=gold -DCMAKE_BUILD_TYPE=Release -DLLVM_STATIC_LINK_CXX_STDLIB=ON -G Ninja ../llvm
RUN cd /llvm-project/build && ninja clang-tidy && cp /llvm-project/build/bin/clang-tidy /usr/bin/
 
WORKDIR /llvm-project/build