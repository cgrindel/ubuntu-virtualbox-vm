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

### Create the Hard Drive File





### Start the VM and Install Ubuntu

Once the ISO is downloaded and the hard drive file are created, it is time to launch the VM and
install Ubuntu.

```sh
$ ./start-ubuntu.sh --install
```

The above command should create a GUI window where the Ubuntu installer should be visible.

Select the minimal install options.


### Set Up SSH Config on the Host

Add a `Host` entry to the host `~/.ssh/config`.

```ssh-config
Host ubuntu-qemu-vm
    HostName localhost
    Port 10022
```

Also, be sure that a catch-all entry exists for SSH key usage. The entire SSH config should look
something like the following:

```ssh-config
IgnoreUnknown UseKeychain

Host ubuntu-qemu-vm
    HostName localhost
    Port 10022

Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/personal_id_rsa
```

## Run VM

To launch the VM, run the start script.

```sh
$ ./start-ubuntu.sh
```

To SSH into the VM, run the following:

```sh
$ ssh chuck@ubuntu-qemu-vm
```

## Set Up Swift

[Reference](https://linuxconfig.org/how-to-install-swift-on-ubuntu-20-04)

### Download Swift and the dependencies

```sh
# Update the index and upgrade installed packages.
$ sudo apt update && sudo apt upgrade

# Install pre-requisites
$ sudo apt install binutils git gnupg2 libc6-dev libcurl4 libedit2 libgcc-9-dev libpython2.7 \
    libsqlite3-0 libstdc++-9-dev libxml2 libz3-dev pkg-config tzdata zlib1g-dev

# Download Swift
$ wget https://swift.org/builds/swift-5.3.3-release/ubuntu2004/swift-5.3.3-RELEASE/swift-5.3.3-RELEASE-ubuntu20.04.tar.gz

```

### Install Swift

Extract the tarball.

```sh
$ tar -xvzf swift-5.3.3-RELEASE-ubuntu20.04.tar.gz -C ~
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

Download the binary and install it in `/usr/local/bin`.

```sh
$ wget https://github.com/bazelbuild/bazelisk/releases/download/v1.10.1/bazelisk-linux-amd64
$ sudo chmod +x bazelisk-linux-amd64
$ sudo mv bazelisk-linux-amd64 /usr/local/bin/bazelisk
$ sudo ln -s /usr/local/bin/bazelisk /usr/local/bin/bazel
```


