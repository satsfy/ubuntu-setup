# install the bashrc

echo "source /home/renato/Desktop/ubuntu-setup/.bashrc" >> ~/.bashrc

# ===========================

# vscode as default text editor
xdg-mime default visual-studio-code.desktop text/plain
xdg-mime default code.desktop text/markdown
xdg-mime default code.desktop application/json
xdg-mime default code.desktop application/xml

# ===========================

# setup gpg for git commit signing using local gpg key
cat pubkey.asc | gpg --import
# curl https://github.com/satsfy.gpg | gpg --import
gpg --list-keys
gpg-connect-agent "scd serialno" "learn --force" /bye
gpg --list-secret-keys --keyid-format LONG
git config --global user.signingkey CFF7F2EB27DA75FA
git config --global commit.gpgsign true
git config --global user.name "Renato Britto"
git config --global user.email "renatobritto@protonmail.com"
git config --global init.defaultBranch master
git config --global pull.rebase true
git config --global diff.tool vscode
git config --global difftool.vscode.cmd 'code --wait --diff "$LOCAL" "$REMOTE"'
git config --global difftool.prompt false

# ===========================

# browser configs
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
