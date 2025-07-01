CloudFormation to Terraform Migration Example
=============================================

In this project, I explored all the steps required in order to move from using
CloudFormation as the default IaC to Terraform. This is especially tricky when
there are stacks dependent on the current one. 

For drifts, also those undetected by CloudFormation, this does not guarantee no changes. 
As we want to get rid of the stack, we need to set `DeletionPolicy: Retain` on each resource.