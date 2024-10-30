FROM nikolaik/python-nodejs:python3.12-nodejs22-slim

RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    wget \
    git \
    vim \
    tmux \
    openssl \
    libssl-dev \
    gcc \
    unzip \
    fontconfig \
    make \
    lua5.1 \
    lua5.1-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash tcotts
RUN echo "tcotts ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/tcotts

WORKDIR /home/tcotts
COPY usersetup.sh /home/tcotts
RUN ./usersetup.sh tcotts

USER tcotts

ENV PATH="/home/tcotts/.local/bin:${PATH}"

CMD ["/bin/bash"]
