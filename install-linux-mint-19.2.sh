
################################################################################
# Post-install Initialisation script
# (Script compatible with Linux Mint 19.2)
################################################################################

################################################################################
# preliminary checks
ping -q -w 1 -c 1 www.google.fr  > /dev/null 2>&1 && echo -e "Internet connection [\e[32mOK\e[39m]" || exit 1

################################################################################
# DEPENDANCIES
source /etc/os-release
sudo apt update && sudo apt upgrade -y
sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/brave-browser-release-${UBUNTU_CODENAME}.list

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker-release-${UBUNTU_CODENAME}.list

read -n 1 -s -r -p "Press any key to continue"
################################################################################
# Post Dependancies installation update
sudo apt update && sudo apt upgrade -y

## Install Docker, Guake, GIT, VLC, Calibre, Brave, Chromium
sudo apt install -y docker-ce docker-ce-cli containerd.io guake git vlc calibre brave-browser chromium-browser

## GOLANG
curl -sSL "https://dl.google.com/go/go1.13.linux-amd64.tar.gz" | sudo tar -v -C /usr/local -xz

## Jetbrains tool
mkdir -p $USER/bin && curl -sSL "https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.15.5796.tar.gz" | tar -v -C $USER/bin -xz

read -n 1 -s -r -p "Press any key to continue"
################################################################################
# INSTALL MY_DOTFILES
git clone https://github.com/xjuery/dotfiles.git ~/dotfiles
echo "" >> ~/.bashrc
echo "source ~/dotfiles/my_bashrc" >> ~/.bashrc
echo "" >> ~/.bashrc
ln -s ~/dotfiles/face.jpg ~/.face

################################################################################
# FINISH & CLEAN
sudo apt autoremove
sudo apt autoclean
sudo apt clean

################################################################################
# POST INSTALL COMMANDS
chown -R $USER:$(id -gn $USER) /home/xavier
