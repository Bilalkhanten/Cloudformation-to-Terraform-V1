#!/bin/bash
RESOURCES_WITH_COMMENTS=$(grep -B1 -ohE '^resource ".*" ".*" {' *.tf)
RES_ID_TO_ADDR=$(echo "$RESOURCES_WITH_COMMENTS" | sed -E '/^\/\/ .*/N;s/^\/\/ (.*)\nresource "(.*)" "(.*)" {/\1::\2.\3\n/g')
RES_ID_TO_ADDR=($(echo "$RES_ID_TO_ADDR" | grep -oE '^.*::.*\..*$'))

for res_id_addr in ${RES_ID_TO_ADDR[@]}; do
  ID=$(echo "$res_id_addr" | cut -d':' -f1)
  ADDR=$(echo "$res_id_addr" | cut -d':' -f3-)
  find . -depth 1 -name '*.tf' -exec sed -i '' -E "s/([[:blank:]]*.+[[:blank:]]*=[[:blank:]]*)\"$ID\"/\1$ADDR.id/g" {} \;
done
