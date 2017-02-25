# DEPENDANCIES
apt update && apt -y upgrade
add-apt-repository ppa:webupd8team/unstable
add-apt-repository ppa:webupd8team/java
curl -fsSL https://apt.dockerproject.org/gpg | apt-key add -
add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"

echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

# Import the Google Chrome public key
curl https://dl.google.com/linux/linux_signing_key.pub | apt-key add -

apt update

# INSTALL GUAKE
apt install -y guake

# INSTALL GIT
apt install -y git

# INSTALL DOCKER
apt install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

apt install -y docker-engine

# INSTALL NVM
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/creationix/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" origin`
) && . "$NVM_DIR/nvm.sh"

nvm install node

# INSTALL atom
wget -O atom.deb https://atom.io/download/deb
dpkg -i atom.deb
apt -f install
rm -f atom.deb

# INSTALL GOOGLE CHROME
apt install -y google-chrome-stable

# INSTALL JAVA 9
apt install -y oracle-java9-installer

# INSTALL keeweb
wget -O keeweb.deb https://github.com/keeweb/keeweb/releases/download/v1.4.0/KeeWeb-1.4.0.linux.x64.deb
dpkg -i keeweb.deb
apt -f install
cleanFile keeweb.deb

# INSTALL WEBSTORM
wget https://download.jetbrains.com/webstorm/WebStorm-2016.3.3.tar.gz
mkdir -p $HOME/bin
tar -C $HOME/bin -xzf WebStorm-2016.3.3.tar.gz
cleanFile WebStorm-2016.3.3.tar.gz

# FINISH & CLEAN
apt autoremove
apt autoclean
apt clean

# UTILITY FUNCTIONS
cleanFile(){
	local name=$1
  if [ -f "$name" ]
  then
  	rm -f $name
  fi
}
