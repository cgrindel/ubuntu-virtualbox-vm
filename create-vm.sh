#!/usr/bin/env zsh

script_dir="${0:A:h}"

source "${script_dir}/shared.sh"
machine_name="${default_machine_name}"

while [[ $# -gt 0 ]]; do
  case "${1}" in
    "--name")
      machine_name="${2}"
      shift 2
      ;;
    "--iso")
      linux_iso="${2}"
      shift 2
      ;;
    *)
      echo >&2 "Unrecognized argument: ${1}" 
      exit 1
      ;;
  esac
done

rdp_port=10001

vm_path="${output_dir}/${machine_name}"
if [[ -d "${vm_path}" ]]; then
  echo >&2 "The specified virtual machine (${machine_name}) already exists. ${vm_path}" 
  exit 1
fi

# Create the VM
VBoxManage createvm \
   --name "${machine_name}" \
   --ostype "Ubuntu_64" \
   --register \
   --basefolder "${output_dir}"

# Required for 64-bit VMs (https://www.virtualbox.org/manual/ch03.html#intro-64bitguests)
VBoxManage modifyvm $machine_name --ioapic on

# Set the memory in MB
VBoxManage modifyvm $machine_name --memory 6144

# Specify network settings
VBoxManage modifyvm $machine_name --nic1 nat

# Create the HD and its controller
hdd_path="${vm_path}/${machine_name}_disk.vdi"
VBoxManage createmedium --filename "${hdd_path}" --size 100000 
VBoxManage storagectl "${machine_name}" --name "${hdd_controller_name}" --add sata --controller IntelAhci
VBoxManage storageattach "${machine_name}" --storagectl "${hdd_controller_name}" --port 0 --device 0 --type hdd --medium "${hdd_path}"

# Attach the ISO as a DVD
linux_iso_path="${output_dir}/${linux_iso}"
VBoxManage storagectl $machine_name --name "${ide_controller_name}" --add ide --controller PIIX4
VBoxManage storageattach $machine_name --storagectl "${ide_controller_name}" --port 1 --device 0 --type dvddrive --medium "${linux_iso_path}"

# Configure the boot order
VBoxManage modifyvm $machine_name --boot1 dvd --boot2 disk --boot3 none --boot4 none

# Enable Remote Desktop Extension
VBoxManage modifyvm $machine_name --vrde on
VBoxManage modifyvm $machine_name --vrdemulticon on --vrdeport "${rdp_port}"

# Enable port forwarding from host to VM
VBoxManage modifyvm $machine_name --natpf1 "ubuntu-vm-ssh,tcp,,10022,,22"

# Launch the VM 
# VBoxManage startvm $machine_name --type gui
echo "Connect to the headless VM using Microsoft Remote Desktop at localhost:${rdp_port}"
VBoxManage startvm $machine_name --type headless
