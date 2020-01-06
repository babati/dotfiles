FROM fedora:latest

# Package install
RUN yum install -y \
    less \
    htop \
    lsof \
    which \
    file \
    sudo \
    man-db \
    dstat \
    tig \
    bzip2 \
    net-tools \
    procps-ng \
    zip \
    unzip

RUN yum install -y \
    boost \
    boost-devel \
    gcc \
    gdb \
    llvm \
    llvm-libs \
    llvm-devel \
    clang \
    clang-analyzer \
    clang-devel \
    clang-libs \
    clang-tools-extra \
    rapidjson-devel \
    valgrind \
    zlib-devel

RUN yum install -y \
    automake \
    cmake \
    make \
    global \
    bash-completion \
    git \
    subversion \
    tmux \
    neovim \
    python-devel \
    the_silver_searcher

RUN yum install -y \
    texlive \
    texlive-algorithmicx \
    texlive-dblfloatfix \
    texlive-multirow \
    texlive-stix \
    texlive-sttools \
    texlive-ulem \
    texlive-wrapfig

RUN yum clean all

# Variables
ARG MOUNT_DIR=/local
ARG USER=devel

# Common settings
ENTRYPOINT /bin/bash
RUN mkdir -p $MOUNT_DIR/data
RUN mkdir -p $MOUNT_DIR/build

# Create user
RUN useradd -ms /bin/bash $USER
RUN chown -R $USER:$USER $MOUNT_DIR

# Switch to user
USER $USER
WORKDIR /home/$USER

# Link config files
RUN mkdir -p ~/.config/nvim
RUN ln -s $MOUNT_DIR/data/dotfiles/init.vim /home/$USER/.config/nvim/init.vim
RUN ln -s $MOUNT_DIR/data/dotfiles/tmux.conf /home/$USER/.tmux.conf
RUN ln -f -s $MOUNT_DIR/data/dotfiles/bashrc /home/$USER/.bashrc

# Bash history
RUN ln -f -s $MOUNT_DIR/data/env/bash/history /home/$USER/.bash_history

# SSH keys
RUN mkdir -p ~/.ssh
RUN ln -f -s $MOUNT_DIR/data/env/ssh/id_rsa /home/$USER/.ssh/id_rsa
RUN ln -f -s $MOUNT_DIR/data/env/ssh/id_rsa.pub /home/$USER/.ssh/id_rsa.pub
RUN ln -f -s $MOUNT_DIR/data/env/ssh/known_hosts /home/$USER/.ssh/known_hosts

# Volumes
RUN ln -f -s $MOUNT_DIR/data /home/$USER/data
RUN ln -f -s $MOUNT_DIR/build /home/$USER/build

# Rust
RUN ln -s $MOUNT_DIR/data/env/cargo .cargo
RUN ln -s $MOUNT_DIR/data/env/rustup .rustup
