#!/bin/bash
NAMES_IDS=$(grep -E '^\|(?:\s+.*\s+\|){2}' example-vpc-resources.txt)
NAMES_IDS=$(echo "$NAMES_IDS" | sed -E 's/\|[[:blank:]]+([^[:blank:]]+)[[:blank:]]+\|[[:blank:]]+([^[:blank:]]+)[[:blank:]]+\|/\2 \1/g')

echo "" > moved.tf

for f in *.tf; do
  # Get all resource IDs found in this Terraform file, extract the ID and type
  RESOURCES=$(grep -oE '^resource ".*" ".*" {' $f)
  RESOURCE_IDS=($(echo "$RESOURCES" | grep -oE '"tfer--.*"' | tr -d \" | cut -d- -f3-))
  RESOURCE_TYPES=($(echo "$RESOURCES" | cut -d' ' -f2 | tr -d \"))
  # Iterate over all resources using integer index
  i=0
  while [ $i -lt ${#RESOURCE_IDS[@]} ]; do
    res_id=${RESOURCE_IDS[$i]}
    res_type=${RESOURCE_TYPES[$i]}
    # If the specified resource ID is in the dump
    if echo "$NAMES_IDS" | grep -qE "^$res_id "; then
      RES_NAME=$(echo "$NAMES_IDS" | grep -E "^$res_id " | cut -d' ' -f2)
      echo "Found $res_id -> $RES_NAME"
      sed -i '' -E "s#^(resource \".*\" )\"tfer\-\-${res_id}\"#// ${res_id}\n\1\"${RES_NAME}\"#g" $f
      echo -e "moved {\n  from = ${res_type}.tfer--${res_id}\n  to = ${res_type}.${RES_NAME}\n}\n" >> moved.tf
    fi
    i=$((i + 1))
  done
done