#@IgnoreInspection BashAddShebang
#shellcheck disable=SC2148
#
# This function templates out a given user data file with the given public key.
# The key being replaced in the file is 'KEY_PAIR'
#
# Usage:
#         source ./template_ssh_to_user_data.sh                         # Pretend this file's contents are in your script
#         template_ssh_to_user_data <public key file> <user data file>  # Template out the contents
#
# Note: The templated user data file is 'user_data_templated'
# Warning: This function hooks into the exit trap signal to remove the
#          templated file.

function remove_templated_file() {
  echo "Removing templated user_data"
  rm user_data_templated
}

function template_ssh_to_user_data() {
  local public_key_file
  local public_key
  local user_data_template_file
  public_key_file="${1}"
  public_key=$(<"${public_key_file}")
  user_data_template_file="${2}"

  sed "s|KEY_PAIR|'${public_key}'|" "${user_data_template_file}" > user_data_templated

  trap "remove_templated_file" EXIT
}