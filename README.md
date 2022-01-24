# How to Set Up and Run an Ubuntu VM in QEMU.

Set up and launch Ubuntu VirtualBox virtual machine. These instructions were inspired by
[this article](https://www.andreafortuna.org/2019/10/24/how-to-create-a-virtualbox-vm-from-command-line/).

## Install VirtualBox and Extensions

```sh
$ brew install --cask virtualbox
```

You will see a dialog to allow an extension to be authorized in System Preferences. Do it. 

You will be encouraged to reboot. Do it.

Log back into the host and install the extensions

```sh
$ brew install --cask virtualbox-extension-pack
```

## Set Up VM

### Download Ubuntu ISO

```sh
wget https://releases.ubuntu.com/20.04/ubuntu-20.04.3-desktop-amd64.iso
```

### Create the VM and Install Ubuntu

Once the ISO is downloaded, it is time to create the VM and install Ubuntu.

```sh
$ ./create-vm.sh
```

Using Microsoft Remote Desktop, connect to `localhost:10001` and login with the username `ubuntu`
and password `ubuntu`.

Select the minimal install options and create your user account using the GUI. Restart the VM.

The VM graphics may not work properly after the restart. If so, open `VirtualBox`, edit the settings
for the VM and make sure that the graphics controller is `VMSVGA`.

### Install ssh on VM

Launch the VM if it is not already running. To launch the VM, run the start script.

```sh
$ ./start-ubuntu.sh
```

Using Microsoft Remote Desktop, connect to `localhost:10001`. Open a Terminal window and install
ssh.

```sh
$ sudo apt-get install ssh
```

Log out of the RDP session.


### Set Up SSH Config on the Host

On the host, add a `Host` entry to the host `~/.ssh/config`.

```ssh-config
Host ubuntu-vm
    HostName localhost
    Port 10022
```

Also, be sure that a catch-all entry exists for SSH key usage. The entire SSH config should look
something like the following:

```ssh-config
IgnoreUnknown UseKeychain

Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/personal_id_rsa
  ForwardAgent yes

Host ubuntu-vm
  HostName localhost
  Port 10022
```

You should be able to SSH into the VM by running the following on the host:

```sh
$ ssh chuck@ubuntu-vm
```

Logout of the SSH session.

Copy your public key to the VM. On the host, run the following:

```sh
$ ssh-copy-id -i ~/.ssh/personal_id_rsa chuck@ubuntu-vm
```

When complete, try logging into the VM again. You should not be prompted for a password.


```sh
$ ssh chuck@ubuntu-vm
```


### Install the stuff we need: tmux, git

In the VM, run the following to install git, vim, zsh and related packages:

```sh
sudo apt-get install tmux git vim zsh powerline fonts-powerline
```

Run the following to change the default shell:

```sh
chsh -s /bin/zsh
```

Log out of the SSH session and log back into the server.


### Set up the machine for development

```sh
mkdir -p code/cgrindel
cd code/cgrindel
git clone git@github.com:cgrindel/dev-machine.git
cd dev-machine
./setup
```


## Run VM

To launch the VM, run the start script.

```sh
$ ./start-ubuntu.sh
```

To SSH into the VM, run the following:

```sh
$ ssh chuck@ubuntu-vm
```

## Set Up Swift

[Reference](https://linuxconfig.org/how-to-install-swift-on-ubuntu-20-04)

### Download Swift and the dependencies

Check for [the latest release](https://www.swift.org/download/) when installing.

```sh
# Update the index and upgrade installed packages.
$ sudo apt update && sudo apt upgrade

# Install pre-requisites
$ sudo apt install binutils git gnupg2 libc6-dev libcurl4 libedit2 libgcc-9-dev libpython2.7 \
    libsqlite3-0 libstdc++-9-dev libxml2 libz3-dev pkg-config tzdata zlib1g-dev

# Download Swift
cd ~/Downloads
wget https://swift.org/builds/swift-5.3.3-release/ubuntu2004/swift-5.3.3-RELEASE/swift-5.3.3-RELEASE-ubuntu20.04.tar.gz

```

### Install Swift

Extract the tarball.

```sh
tar -xvzf swift-5.3.3-RELEASE-ubuntu20.04.tar.gz -C ~
```

Add the Swift executables to the path in your init script. The following will add it for bash.

```sh
$ echo "PATH=~/swift-5.3.3-RELEASE-ubuntu20.04/usr/bin:$PATH" >> ~/.bashrc
$ . ~/.bashrc
```

Verify all is well.

```sh
$ swift --version
```

## Set Up Bazelisk

Check for [the latest version of Baselisk](https://github.com/bazelbuild/bazelisk/releases).

Download the binary and install it in `/usr/local/bin`.

```sh
cd ~/Downloads
wget https://github.com/bazelbuild/bazelisk/releases/download/v1.11.0/bazelisk-linux-amd64
sudo chmod +x bazelisk-linux-amd64
sudo mv bazelisk-linux-amd64 /usr/local/bin/bazelisk
sudo ln -s /usr/local/bin/bazelisk /usr/local/bin/bazel
```


