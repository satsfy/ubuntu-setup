
sudo apt update
sudo apt upgrade -y
sudo apt install --reinstall gnome-control-center
sudo apt install -y\
    git\
    terminator\
    gh\
    curl\
    build-essential\
    libgtk-3-dev\
    plocate\
    htop\
    python3-pip\
    python3-dev\
    python3-venv\
    curl\
    wget\
    git\
    vim\
    build-essential\
    software-properties-common\
    gnupg\
    scdaemon\
    pcscd\
    python3\
    python-is-python3\
    python3-pip\
    python3.10-venv\
    calibre\
    vlc\
    gcc\
    docker-compose-plugin\
    make\
    xclip

sudo snap install --classic \
    obsidian 

# Install act
cd /tmp
wget https://github.com/nektos/act/releases/latest/download/act_Linux_x86_64.tar.gz
tar -xzf act_Linux_x86_64.tar.gz
sudo mv act /usr/local/bin/act
act --version
