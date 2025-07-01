#!/bin/bash

if ! command -v tofu &> /dev/null; then
    terraform init
else
    tofu init
    ln -s .terraform/plugins/registry.opentofu.org .terraform/plugins/registry.terraform.io
fi


# This is just an example what to import. Change it to your needs!

terraformer import aws -r vpc,subnet,route_table \
 --filter="Type=vpc;Name=id;Value=vpc-06789abcdef123456" \
 --filter="Type=subnet;Name=vpc_id;Value=vpc-06789abcdef123456" \
 --filter="Type=route_table;Name=vpc_id;Value=vpc-06789abcdef123456"

mv generated/aws/route_table/route_table.tf .
mv generated/aws/route_table/route_table_association.tf .
mv generated/aws/vpc/vpc.tf .
mv generated/aws/subnet/subnet.tf .
rm -r generated