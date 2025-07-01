#!/bin/bash
echo "" > imports.tf

RESOURCES=$(find . -depth 1 -name '*.tf' -exec grep -E '^resource .* {' {} \;)

IFS=$'\n'
for resource in $RESOURCES; do
  TYPE=$(echo "$resource" | sed 's/resource "\(.*\)" "tfer--.*".*/\1/g')
  NAME=$(echo "$resource" | sed 's/resource ".*" "\(tfer--.*\)".*/\1/g')
  ID=$(echo "$NAME" | sed 's/^tfer--//g')
  echo "Importing ${TYPE}.${NAME} with ID ${ID}"
  echo -e "import {\n  to = ${TYPE}.${NAME}\n  id = \"${ID}\"\n}\n" >> imports.tf
done