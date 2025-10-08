#!/bin/bash

set -e
set -u
set -o pipefail
#set -x

_tmpdir=$(mktemp --directory)
myjq='jq --exit-status'


## 3az
cp .components/3az_new-vpc.json 3az_new-vpc.json
##

## 2az

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
  .Resources.DiscrimiNATRouteAssociation3
  )' \
  3az_new-vpc.json > ${_tmpdir}/2za_01.json

$myjq '
  .Resources.DiscrimiNATAutoScalingGroup.Properties.DesiredCapacity = "2" |
  .Resources.DiscrimiNATAutoScalingGroup.Properties.MaxSize = "3" |
  .Resources.DiscrimiNATAutoScalingGroup.Properties.MinSize = "2"
  ' \
  ${_tmpdir}/2za_01.json > ${_tmpdir}/2za_02.json

$myjq '.Description = (.Description | gsub("trio"; "pair"))' \
  ${_tmpdir}/2za_02.json > ${_tmpdir}/2za_03.json

$myjq --sort-keys . ${_tmpdir}/2za_03.json > ${_tmpdir}/2za_04.json

cp ${_tmpdir}/2za_04.json 2az_new-vpc.json
##


## demo

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
