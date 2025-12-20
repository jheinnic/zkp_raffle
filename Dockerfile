FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
apt install -y adduser git curl build-essential && \
adduser appuser

USER appuser

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
echo >> /root/.bashrc && \
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /root/.bashrc && \
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" 

RUN brew install gcc rust jq

RUN curl -L https://raw.githubusercontent.com/noir-lang/noirup/refs/heads/main/install | bash && \
source ~/.bashrc && \
noirup && \
curl -L https://raw.githubusercontent.com/AztecProtocol/aztec-packages/refs/heads/next/barretenberg/bbup/install | bash && \
source ~/.bashrc && \
bbup
