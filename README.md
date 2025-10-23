# DiscrimiNATs in High Availability and Auto Scaling with a GatewayLoadBalancer

HTTPS, TLS, SSH, SFTP micro-segmentation firewall to monitor and filter VPC egress by hostnames. Architecture with Gateway Load Balancer (GWLB) VPC Endpoints for Private Subnets' route table entries to the Internet.

`2az_demo.json`: A pair of DiscrimiNAT instances in High Availability with Auto Scaling and Load Balancing, a test VM in a Private Subnet with only some FQDNs allowed on egress, and another test VM with its egress traffic being monitored & logged. Login to the test VMs by clicking Connect in the web console and choosing the Session Manager option. Then try an allowed domain name with this command: `curl https://api.github.com/` . Full, self-service demo guide is at https://chasersystems.com/docs/discriminat/aws/quick-start/ .

`3az_new-vpc.json`: A trio of DiscrimiNAT instances in High Availability with Auto Scaling and Load Balancing across three AZs in a completely new VPC (also deployed by this stack).

`2az_new-vpc.json`: A pair of DiscrimiNAT instances in High Availability with Auto Scaling and Load Balancing across two AZs in a completely new VPC (also deployed by this stack).

`3az_retrofit.json`: A trio of DiscrimiNAT instances in High Availability with Auto Scaling and Load Balancing across three AZs in an existing new VPC.

`2az_retrofit.json`: A pair of DiscrimiNAT instances in High Availability with Auto Scaling and Load Balancing across two AZs in an existing new VPC.

## The Region2AMI JSON key

The templates include a `Region2PaygAmi` key (or `Region2ByolAmi` if using an enterprise licence) under `Mappings`. This includes a map of AMI IDs to AWS Regions, and will be updated from time to time.

> [!IMPORTANT]\
> If you wish to always run the latest version of DiscrimiNAT, please subscribe to the changes in this repository by clicking Watch -> Custom -> Releases -> Apply.

## Documentation

https://chasersystems.com/docs/discriminat/aws/installation-overview/

## Support

`devsecops@chasersystems.com`
