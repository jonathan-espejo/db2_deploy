#!/usr/bin/env bash
set -e

# Inputs (convert to all to lower case)
env=$( echo "$1" | tr '[:upper:]' '[:lower:]')
action=$( echo "$2" | tr '[:upper:]' '[:lower:]')

# Constants
declare -A accounts
accounts=( ["non_prd_acc_num"]=749397145246
           ["mgmt_acc_num"]=863861149601
           ["stg_acc_num"]=448247800550
           ["prd_acc_num"]=303627379544
           ["749397145246"]="Non-prd"
           ["863861149601"]="Mgmt"
           ["448247800550"]="Stg"
           ["303627379544"]="Prd")
red_bold_format="\\033[1;31m"
reset_all_format="\\033[0m"
error_str="\\n${red_bold_format}ERROR:${reset_all_format}"

# Input validation
if [[ $# -lt 2 ]]; then
    echo "Usage: deploy.sh <environment> <action>"
    echo "  <environment>            : Can be dev,tst,int,bat or prd"
    echo "  <action>                 : Terraform action to take (Apply will auto approve)"
    exit 1
fi
if [[ "${env}" != "dev" ]] && [[ "${env}" != "tst" ]] && [[ "${env}" != "int" ]]  && [[ "${env}" != "bat" ]] && [[ "${env}" != "prd" ]] ; then
    echo "Environment not recognized, use dev,tst,int,bat or prd"
    exit 1
fi

# AWS account check
if ! current_identity=$(aws sts get-caller-identity --no-verify-ssl)
then
  exit $?
fi

current_acc_num=$(echo "${current_identity}" | jq -r '.Account')
if [[ "${env}" = "dev" ]] || [[ "${env}" = "tst" ]] && [[ "${current_acc_num}" != "${accounts['non_prd_acc_num']}" ]] ; then
    echo -e "${error_str} Can not deploy '${env}' environment into ${accounts[$current_acc_num]} account (${current_acc_num})."
    echo -e "       Please assume a role in Non-prd (${accounts['non_prd_acc_num']})"
    exit 2
elif [[ "${env}" = "int" ]] || [[ "${env}" = "bat" ]]  && [[ "${current_acc_num}" != "${accounts['stg_acc_num']}" ]] ; then
    echo -e "${error_str} Can not deploy '${env}' environment into ${accounts[$current_acc_num]} account (${current_acc_num})."
    echo -e "       Please assume a role in Stg (${accounts['stg_acc_num']})"
    exit 2
elif [[ "${env}" = "prd" ]]  && [[ "${current_acc_num}" != "${accounts['prd_acc_num']}" ]] ; then
    echo -e "${error_str} Can not deploy '${env}' environment into ${accounts[$current_acc_num]} account (${current_acc_num})."
    echo -e "       Please assume a role in Prd (${accounts['prd_acc_num']})"
    exit 2
fi

cd platform

# Initialise terraform
rm -f .terraform/environment
terraform init
terraform workspace new "crods-db2-${env}" || true
terraform workspace select "crods-db2-${env}"

# # Auto approve Apply
# if [[ "$action" = "apply" ]] ; then
#     action="apply -auto-approve"
# fi

# terraform validate \
#   -var-file=${env}.tfvars

# terraform ${action} \   
#   -var-file=vars/${env}.tfvars

terraform ${action} \   
  -var-file=${env}.tfvars