# Setup

## Local
- Install ruby
- Install postgresql
- Get the app running locally by running these commands from your terminal:
```
$ bin/setup
$ bin/dev
```

## Nix

### Update the distro and install basic tools
```
sudo apt update
sudo apt-get install -y ca-certificates curl git jq
```

### Install [Nix Package Manager](https://nixos.org/download/)
```
# https://nix.dev/tutorials/install-nix
curl -L https://nixos.org/nix/install | sh -s -- --daemon
## open a new terminal and type to verify the install
nix --version
```

### Install [Direnv](https://direnv.net/)
```
sudo apt install -y direnv
```
Hook it into the shell (https://direnv.net/docs/hook.html)
```
echo "eval \"\$(direnv hook bash)\"" >> ~/.bashrc
```

### Install [Just](https://github.com/casey/just)
Prebuilt-MPR set up
```
curl -q 'https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub' | gpg --dearmor | sudo tee /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg 1> /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] https://proget.makedeb.org prebuilt-mpr $(lsb_release -cs)" | sudo tee /etc/apt/sources.list.d/prebuilt-mpr.list
sudo apt update
sudo apt install -y just
```

### Run Setup
```
direnv allow .
cp .env.example .env.development.local
cp .env.example .env.test.local
just bootstrap
```

### Subsequent starts
To start all services:
```
just start
```

## WSL2 Setup (if using WSL2)
#### Enable systemd flag in your WSL distro
edit wsl.conf (https://learn.microsoft.com/en-us/windows/wsl/wsl-config#wslconf)
```
sudo tee -a /etc/wsl.conf > /dev/null <<EOT
[boot]
systemd=true
EOT
```

from PowerShell run wsl.exe --shutdown  to restart your WSL instances
```
wsl.exe --shutdown
```
