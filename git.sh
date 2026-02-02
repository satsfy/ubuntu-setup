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
