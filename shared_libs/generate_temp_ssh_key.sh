#@IgnoreInspection BashAddShebang
#shellcheck disable=SC2148
#
# This function creates a temporary ssh key-pair and erases it with a trap
# function hooked into the exit signal.
# Usage:
#         source ./generate_temp_ssh_key.sh   # Pretend this file's contents are in your script
#         generate_temp_ssh_key <filename>    # Generate a key-pair with the given filename
#
# Note: The filename is optional and will default to 'temp_ssh'
# Warning: This function hooks into the exit trap signal to remove the
#          temporary keys.

function remove_temp_keys() {
  echo "Removing SSH key-pair (${1})"
  rm "${1}.pem" "${1}.pub"
}

function generate_temp_ssh_key() {
  local filename
  filename="${1:-'temp_ssh'}"

  ssh-keygen -q -N '' -t rsa -C 'Packer' -f "${filename}"
  mv "${filename}" "${filename}.pem"

  #shellcheck disable=SC2064
  trap "remove_temp_keys ${filename}" EXIT
}