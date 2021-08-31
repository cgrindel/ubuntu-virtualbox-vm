#!/usr/bin/env zsh

default_machine_name="ubuntu-vm"
linux_iso="ubuntu-20.04.3-desktop-amd64.iso"
output_dir="${script_dir}"
hdd_controller_name="SATA Controller"
ide_controller_name="IDE Controller"

# Host port which can be used to connect to Remote Desktop Extension
# using Microsoft Remote Desktop.
rdp_port=10001
