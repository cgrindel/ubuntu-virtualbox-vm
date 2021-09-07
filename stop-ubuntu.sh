#!/usr/bin/env zsh

script_dir="${0:A:h}"

source "${script_dir}/shared.sh"

args=()
while [[ $# -gt 0 ]]; do
  case "${1}" in
    *)
      args+=("${1}")
      shift 1
      ;;
  esac
done

machine_name="${args[0]:-$default_machine_name}"

# Launch headless 
echo "Stopping ${machine_name}..."
VBoxManage controlvm $machine_name poweroff soft
