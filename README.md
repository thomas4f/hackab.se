# hackab.se (HAB-01)

## Introduction

These are the project files for the Hack AB (HAB) Capture the Flag platform.
The purpose of the platform is to give people interested in cyber- and information security
an opportunity to learn more about security assessments and penetration testing.

Check out [hackab.se](http://www.hackab.se/) for an online demo.
Or download a pre-built VirtualBox VM from [Google Drive](https://drive.google.com/drive/u/0/folders/1ZadAQU4Uun4fExfwXAsnHc9MKgZ4Mtjp).

This file describes (roughly) how to provision HAB-01 from scratch. 

## Requirements

* [VirtualBox](https://www.virtualbox.org/)
* [Packer](https://www.packer.io/)

## Directory structure

```
ansible_playbook/		Ansible playbook and project files
d-i/					The DebianInstaller preseed configuration used when building Base Box
packer_input/			The directory where Packer looks for Debian "netinst" .iso or VirtualBox .ova
packer_output/			The directory where the Packer artifacts are output to
packer_basebox.json		Packer configuration file used to build Debian Base Box
packer_HAB-01.json		Packer configuration file used to provision the VM
Vagrantfile.template	Vagrant template that is packaged with the box by Packer
```

## Instructions

### Download and install Packer:
```bash
wget https://releases.hashicorp.com/packer/1.3.3/packer_1.3.3_linux_amd64.zip
sudo unzip packer_1.3.3_linux_amd64.zip -d /usr/local/bin/
rm packer_1.3.3_linux_amd64.zip
```
### Download Debian netinst ISO

```bash
wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.9.0-amd64-netinst.iso -P ./packer_input
```
### Modify packer_basebox.json
Most relevant settings are:
```
template_version
iso_url
iso_checksum
```

### Build Debian Base Box
```bash
packer validate packer_basebox.json
packer build packer_basebox.json
mv ./packer_output/HAB-01-amd64-basebox.ova ./packer_input/
rm -r ./packer_output/
```

### Modify packer_HAB-01.json
Relevant settings are:
```
template_version
```

### Create SSH key
Create a SSH key pair.
```bash
ssh-keygen -o -t ed25519 -f ~/.ssh/admin@hackab  -N ""
# Insert the contents of ~/.ssh/admin@hackab.pub to the ssh_key variable in ./ansible_playbook/main.yml (see below).
```

### Modify main.yml
You MUST modify these:
```
admin_password
admin_key
```

### Provision VM
```bash
packer validate ./packer_HAB-01.json
ansible-playbook ./ansible_playbook/main.yml --syntax-check
packer build ./packer_HAB-01.json
```

### Import VM to VirtualBox
Via GUI (File -> Import Appliance), or:
```bash
vboxmanage import ./packer_output/HAB-01-amd64.ova
```
### Configure bridged networking
Via GUI (Settings > Network > Adapter 1), or:
```bash
vboxmanage modifyvm HAB-01-amd64 --nic1 bridged --bridgeadapter1=$(route | grep -m1 '^default' | awk '{print $8}')
```

### Start VM
Via GUI, or:
```
VBoxManage startvm HAB-01-amd64 --type headless
```
### Edit hosts-file
The IP address of the VM will be shown at the login prompt. Edit your hosts-file to reflect this.
```
x.x.x.x hackab.se www.hackab.se bugbounty.hackab.se api.hackab.se
```

### Perform administrative tasks
To perform administrative tasks, connect to the machine via SSH as the "admin" user.
Do not login as "root" since this session may be exposed by certain challenges and potentially sidetrack candidates.
```
ssh admin@hackab.se
```

Example `~/.ssh/config` entry:
```
Host hackab.se
  HostName hackab.se
  StrictHostKeyChecking no
  Port 22
  User admin
  IdentityFile ~/.ssh/admin@hackab
```

### Halt and remove VM
```bash
VBoxManage controlvm HAB-01 acpipowerbutton
VBoxManage unregistervm HAB-01 --delete
```

### TODO/ROADMAP

* Adjust flag points
* Internationalization
* Per-event Bug Bounty database
* Create tests for most recent flags
* Create clear instructs for VirtualBox import
* Create more flags :P
