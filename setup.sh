
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
        neovim\
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
            gnupg scdaemon pcscd
    python3\
    python-is-python3
    python3-pip
    python3.10-venv
    calibre vlc
    gcc\
    make\

sudo snap install obsidian --classic


# curl https://github.com/natobritto.gpg | gpg --import
cat pubkey.asc | gpg --import
gpg --list-keys
gpg-connect-agent "scd serialno" "learn --force" /bye
gpg --list-secret-keys --keyid-format LONG
git config --global user.signingkey CFF7F2EB27DA75FA
git config --global commit.gpgsign true
git config --global user.name "Renato Britto"
git config --global user.email "renatobritto@protonmail.com"
git config --global init.defaultBranch master
git config --global pull.rebase true


sudo apt install curl
curl -fsS https://dl.brave.com/install.sh | sh

sudo snap remove firefox
sudo apt purge firefox
sudo add-apt-repository ppa:mozillateam/ppa
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
sudo apt update
sudo apt install firefox
which firefox
firefox & disown
