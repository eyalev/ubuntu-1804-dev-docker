
# Python

FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    less \
    python3-distutils \
    python3-dev \
    python-minimal \
    software-properties-common \
    build-essential \
    vim \
    wget \
    tmux \
    git

RUN update-ca-certificates

# make sure ALL python commands lead to the same python version (3.6), thus calling python/python3/python3.6
# result in calling the same binary
RUN rm /usr/bin/python && \
    ln -s /usr/bin/python3 /usr/bin/python

# install pip. after that installation pip can be used as pip, pip3 and pip3.6, all point to pip3.6
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip install --upgrade pip==19.1

# RUN echo 'HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "' >> ~/.bashrc

# Install fzf: https://github.com/junegunn/fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
RUN ~/.fzf/install --all

# Update PATH
ENV PATH /root/.local/bin:$PATH

# Make bash commands written to ~/.bash_history immediately
RUN bash -c 'shopt -s histappend'
ENV PROMPT_COMMAND 'history -a;history -n'

WORKDIR /root

# Setup configs
COPY configs /root/configs
RUN echo 'source ~/configs/bashrc_ext' >> ~/.bashrc

# Setup shell-commnads
ARG UPDATE_SHELL_HISTORY
RUN curl -L https://github.com/eyalev/shell-history/raw/master/setup_bash_commands.sh | bash

CMD ["tmux"]
