# DiscrimiNAT OTF instances in high-availability and auto-scaling with a Gateway Load Balancer

HTTPS, TLS, SSH, SFTP least-privilege Outbound Traffic Filtering (OTF) to monitor and filter VPC egress by domain names. Architecture with Gateway Load Balancer (GWLB) VPC Endpoints for Private Subnets' route table entries to the internet. See [reference architectures here](https://chasersystems.com/docs/discriminat/aws/reference-architectures/).

## CloudFormation Stacks

`2az_demo.json`: A pair of DiscrimiNAT instances in high-availability with auto-scaling and load-balancing, a test VM in a Private Subnet with only some FQDNs allowed on egress, and another test VM with its egress traffic being monitored & logged. Login to the test VMs by clicking Connect in the web console and choosing the Session Manager option. Then try an allowed domain name with this command: `curl https://api.github.com/` . Full, self-service demo guide is at https://chasersystems.com/docs/discriminat/aws/quick-start/ .

`3az_new-vpc.json`: A trio of DiscrimiNAT instances in high-availability with auto-scaling and load-balancing across three AZs in a completely new VPC (also deployed by this stack).

`2az_new-vpc.json`: A pair of DiscrimiNAT instances in high-availability with auto-scaling and load-balancing across two AZs in a completely new VPC (also deployed by this stack).

`3az_retrofit.json`: A trio of DiscrimiNAT instances in high-availability with auto-scaling and load-balancing across three AZs in an existing VPC.

`2az_retrofit.json`: A pair of DiscrimiNAT instances in high-availability with auto-scaling and load-balancing across two AZs in an existing VPC.

For single AZ deployment, see https://github.com/ChaserSystems/cloudformation-aws-discriminat-eni .

## Map of AMI IDs

The templates include a `Region2PaygAmi` key (or `Region2ByolAmi` if using a licence key) under `Mappings`. This includes a map of AMI IDs to AWS Regions, and will be updated as per [our updates policy](https://chasersystems.com/discriminat/faq/#what-about-images-security-updates).

> [!IMPORTANT]\
> If you wish to always run the latest version of DiscrimiNAT, please subscribe to changes in this repository by clicking Watch -> Custom -> Releases -> Apply.

## Documentation

https://chasersystems.com/docs/discriminat/aws/installation-overview/

## Support

`devsecops@chasersystems.com`
