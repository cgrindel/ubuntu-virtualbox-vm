#!/usr/bin/env zsh

script_dir="${0:A:h}"

source "${script_dir}/shared.sh"

start_type=headless

args=()
while [[ $# -gt 0 ]]; do
  case "${1}" in
    "--gui")
      start_type=gui
      shift 1
      ;;
    *)
      args+=("${1}")
      shift 1
      # echo >&2 "Unrecognized argument: ${1}" 
      # exit 1
      ;;
  esac
done

machine_name="${args[0]:-$default_machine_name}"

# Make sure that the DVD is no longer attached
# VBoxManage storageattach $machine_name --storagectl "${ide_controller_name}" --port 1 --device 0 --type dvddrive --medium none 

# Launch headless 
echo "Starting ${machine_name} as ${start_type}."
VBoxManage startvm $machine_name --type "${start_type}"

