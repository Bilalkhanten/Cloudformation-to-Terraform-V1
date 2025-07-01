#!/bin/bash
set -e
find . -depth 1 -name '*.tf' -exec sed -i '' 's/\${data\.terraform_remote_state\..*\-\-\([^_]*\)\(_[^}]*\)}/\1/g' {} \;
tofu validate
[ ! -f imports.tf ] && bash import.sh
tofu apply
echo "" > imports.tf
[ ! -f moved.tf ] && bash rename.sh
tofu apply
echo "" > moved.tf
bash match_properties.sh
tofu plan