#output "webserver_instance_id" {
#  value = aws_instance.my_ubuntu.id
#}
#
#output "webserver_public_ip" {
#  value = aws_eip.my_elastic_ip.public_ip
#}
#
#output "webserver_sg_id" {
#  value = aws_security_group.terraform-SG.id
#}
#
#output "webserver_sg_arn" {
#  value = aws_security_group.terraform-SG.arn
#}
#
#output "data_aws_availability_zones" {
#  value = data.aws_availability_zones.working.names
#}
#output "data_aws_caller_identity" {
#  value = data.aws_caller_identity.current.account_id
#}
#
#output "data_aws_region" {
#  value = data.aws_region.current.name
#}
#
#output "data_aws_region_description" {
#  value = data.aws_region.current.description
#}
#
##output "prod_vpc_id" {
##  value =data.aws_vpc.prod_vpc.id
##}
##
##output "prod_vpc_cider" {
##  value = data.aws_vpc.prod_vpc.cidr_block
##}
#
#output "aws_vpcs" {
#  value = data.aws_vpcs.my_vpcs.ids
#}