#!/usr/bin/env bash

set -e

# build.sh
# Builds an AMI based on the IAG SOE.
#
# Takes no input but determine local vs Jenkins via the 'BUILD_NUMBER'
# environment variable.
# When run locally, the AMI will be built in the 'dev' VPC. The build
# number will also be a timestamp instead of a build number.
# NOTE: To override the AMI for testing, set the environment variable
#       'AMI_OVERRIDE' with the ami id to use instead.

# FUNCTIONS
function check_err() {
  if [[ -z "${1}" || "${1}" == "null" ]]; then
    >&2 echo "Error: ${2}"
    exit 1
  fi
}

clean_up() {
  remove_temp_keys ${ssh_file_name}
  remove_templated_file
  echo "Cleaning up temporary credentials"
}

source shared_libs/generate_temp_ssh_key.sh
source shared_libs/template_ssh_to_user_data.sh

# CONSTANTS
readonly NOW=$(date "+%Y%m%d%H%M%S")
echo 'Generating a temporary SSH key-pair for packer . . .'
ssh_file_name="db2-packer-${NOW}"

  ssh-keygen -q -N '' -t rsa -C 'Packer' -f $ssh_file_name
  
#generate_temp_ssh_key "${ssh_file_name}"
echo "$?"
ls -l
sleep 10
template_ssh_to_user_data "${ssh_file_name}.pub" "./packer/user_data"
echo "$?"
ls -l
trap "clean_up" EXIT

echo 'Beginning bake process . . .'

packer build -machine-readable -debug \
  -var "ssh_private_key_file=${ssh_file_name}.pem" \
  -var "user_data_file=user_data_templated" \
  packer/template.json
