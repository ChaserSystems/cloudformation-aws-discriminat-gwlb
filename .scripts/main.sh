#!/bin/bash

set -e
set -u
set -o pipefail
# set -x

_tmpdir=$(mktemp --directory)
myjq='jq --exit-status'


## 3az new vpc
cp .components/3az_new-vpc.json 3az_new-vpc.json
##


## 2az new vpc
$myjq 'del(
  .Metadata."AWS::CloudFormation::Interface".ParameterGroups[0].Parameters[7],
  .Metadata."AWS::CloudFormation::Interface".ParameterGroups[0].Parameters[4],
  .Parameters.PublicSubnetAZ3,
  .Parameters.PrivateSubnetAZ3,
  .Resources.DiscrimiNATAutoScalingGroup.Properties.VPCZoneIdentifier[2],
  .Resources.DiscrimiNATLoadBalancer.Properties.Subnets[2],
  .Resources.EC2VPCEndpoint.Properties.SubnetIds[2],
  .Resources.SubnetPublic3,
  .Resources.SubnetPrivate3,
  .Resources.PrivateSubnet3DefaultRoute,
  .Resources.PrivateRouteTable3,
  .Resources.InternetGatewayRouteAssociation3,
  .Resources.EIP4,
  .Resources.DiscrimiNATVPCEndpoint3,
  .Resources.DiscrimiNATRouteAssociation3,
  .Outputs.DiscrimiNATLoadBalancerEndpointAZ3
  )' \
  3az_new-vpc.json > ${_tmpdir}/2az_01.json

$myjq '
  .Resources.DiscrimiNATAutoScalingGroup.Properties.DesiredCapacity = "2" |
  .Resources.DiscrimiNATAutoScalingGroup.Properties.MaxSize = "3" |
  .Resources.DiscrimiNATAutoScalingGroup.Properties.MinSize = "2"
  ' \
  ${_tmpdir}/2az_01.json > ${_tmpdir}/2az_02.json

$myjq '.Description = (.Description | gsub("trio"; "pair"))' \
  ${_tmpdir}/2az_02.json > ${_tmpdir}/2az_03.json

$myjq --sort-keys . ${_tmpdir}/2az_03.json > ${_tmpdir}/2az_04.json

cp ${_tmpdir}/2az_04.json 2az_new-vpc.json
##


## demo 2az
$myjq --slurp '
  .[0] * .[1]
  ' \
  2az_new-vpc.json .components/demo.json > ${_tmpdir}/demo_01.json

$myjq --slurp '
  .[0].Metadata."AWS::CloudFormation::Interface".ParameterGroups + .[1].Metadata."AWS::CloudFormation::Interface".ParameterGroups
  ' \
  .components/demo.json 2az_new-vpc.json > ${_tmpdir}/demo_02.json

$myjq --slurpfile xfile ${_tmpdir}/demo_02.json '
  .Metadata."AWS::CloudFormation::Interface".ParameterGroups = $xfile[0]
  ' ${_tmpdir}/demo_01.json > ${_tmpdir}/demo_03.json

$myjq --sort-keys . ${_tmpdir}/demo_03.json > ${_tmpdir}/demo_04.json

cp ${_tmpdir}/demo_04.json 2az_demo.json
##


## 3az retrofit
$myjq '
  .Parameters.PublicSubnetAZ1 = {"Type": "AWS::EC2::Subnet::Id"} |
  .Parameters.PrivateSubnetAZ1 = {"Type": "AWS::EC2::Subnet::Id"} |
  .Parameters.PublicSubnetAZ2 = {"Type": "AWS::EC2::Subnet::Id"} |
  .Parameters.PrivateSubnetAZ2 = {"Type": "AWS::EC2::Subnet::Id"} |
  .Parameters.PublicSubnetAZ3 = {"Type": "AWS::EC2::Subnet::Id"} |
  .Parameters.PrivateSubnetAZ3 = {"Type": "AWS::EC2::Subnet::Id"} |
  .Parameters.VPC = {"Type": "AWS::EC2::VPC::Id"} |
  .Parameters.NewEIPs.Default = "no"
  ' \
  3az_new-vpc.json > ${_tmpdir}/3az_r_01.json

$myjq '
  .Metadata."AWS::CloudFormation::Interface".ParameterGroups[0].Parameters =
  .Metadata."AWS::CloudFormation::Interface".ParameterGroups[0].Parameters[0:2] +
  ["VPC"] +
  .Metadata."AWS::CloudFormation::Interface".ParameterGroups[0].Parameters[2:]
  ' \
  ${_tmpdir}/3az_r_01.json > ${_tmpdir}/3az_r_02.json

$myjq 'del(
  .Resources.VPC,
  .Resources.SubnetPublic1,
  .Resources.SubnetPrivate1,
  .Resources.SubnetPublic2,
  .Resources.SubnetPrivate2,
  .Resources.SubnetPublic3,
  .Resources.SubnetPrivate3,
  .Resources.InternetGateway,
  .Resources.InternetGatewayAttachment,
  .Resources.InternetGatewayRouteAssociation1,
  .Resources.InternetGatewayRouteAssociation2,
  .Resources.InternetGatewayRouteAssociation3,
  .Resources.PrivateRouteTable1,
  .Resources.PrivateRouteTable2,
  .Resources.PrivateRouteTable3,
  .Resources.PublicRoute,
  .Resources.PublicRouteTable,
  .Parameters.VpcCidr.Default,
  .Parameters.VpcCidr.Description,
  .Resources.DiscrimiNATRouteAssociation1,
  .Resources.DiscrimiNATRouteAssociation2,
  .Resources.DiscrimiNATRouteAssociation3,
  .Resources.PrivateSubnet1DefaultRoute,
  .Resources.PrivateSubnet2DefaultRoute,
  .Resources.PrivateSubnet3DefaultRoute
  )' \
  ${_tmpdir}/3az_r_02.json > ${_tmpdir}/3az_r_03.json

$myjq 'walk(if type == "object" and has("VpcId") then .VpcId = {"Ref": "VPC"} else . end)' \
  ${_tmpdir}/3az_r_03.json > ${_tmpdir}/3az_r_04.json

$myjq '
  .Resources.DiscrimiNATAutoScalingGroup.Properties.VPCZoneIdentifier[0].Ref = "PublicSubnetAZ1" |
  .Resources.DiscrimiNATAutoScalingGroup.Properties.VPCZoneIdentifier[1].Ref = "PublicSubnetAZ2" |
  .Resources.DiscrimiNATAutoScalingGroup.Properties.VPCZoneIdentifier[2].Ref = "PublicSubnetAZ3" |
  .Resources.DiscrimiNATLoadBalancer.Properties.Subnets[0].Ref = "PrivateSubnetAZ1" |
  .Resources.DiscrimiNATLoadBalancer.Properties.Subnets[1].Ref = "PrivateSubnetAZ2" |
  .Resources.DiscrimiNATLoadBalancer.Properties.Subnets[2].Ref = "PrivateSubnetAZ3" |
  .Resources.DiscrimiNATVPCEndpoint1.Properties.SubnetIds[0].Ref = "PrivateSubnetAZ1" |
  .Resources.DiscrimiNATVPCEndpoint2.Properties.SubnetIds[0].Ref = "PrivateSubnetAZ2" |
  .Resources.DiscrimiNATVPCEndpoint3.Properties.SubnetIds[0].Ref = "PrivateSubnetAZ3" |
  .Resources.EC2VPCEndpoint.Properties.SubnetIds[0].Ref = "PrivateSubnetAZ1" |
  .Resources.EC2VPCEndpoint.Properties.SubnetIds[1].Ref = "PrivateSubnetAZ2" |
  .Resources.EC2VPCEndpoint.Properties.SubnetIds[2].Ref = "PrivateSubnetAZ3"
  ' \
  ${_tmpdir}/3az_r_04.json > ${_tmpdir}/3az_r_05.json

$myjq --sort-keys . ${_tmpdir}/3az_r_05.json > ${_tmpdir}/3az_r_06.json

cp ${_tmpdir}/3az_r_06.json 3az_retrofit.json
##
