This repo consists of terraform code which will provision underlying infrastructure on AWS platform to host 3 microservices (viz. frontend, quotes and newsfeed) which would be highly available and scalable. Each component would be hosted on a separate autoscaling group and load-balanced through dedicated Application Load Balancer. The application would get installed through bootstrap script and should be available as soon as the instance completes boot process.

Pre-requisites to run this code:
--------------------------------
1) Terraform binaries available and executable from any local path.

2) AWS Account under which resources would be created and IAM user with relevant permissions to create resources.

3) AWS CLI installed on local machine from where this code will be executed. By following steps at https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html, access key, secret key (of IAM User mentioned in above point) and aws region values should be saved in ~/.aws directory

Assumptions:
------------
1) Resources to be created in AWS account's default VPC. Further infrastructure code can be developed to create the resources in a dedicated VPC to follow best practice like public and private subnets for front-end and back-end apps respectively.

2) Build process given at https://github.com/ThoughtWorksInc/infra-problem to be followed (one-time manual effort) to extract JAR files which are uploaded in a S3 bucket named 'thoughtworks-jar-files'. frontend/public folder (for static css utility) is also copied in same S3 bucket.

3) S3 bucket named 'thoughtworks.terraformstate' and Dynamodb table named 'terraformtestenv' is created under AWS account within same region as other resources would be created. This is needed to remotely save terraform state files so that more than one person can use the code and state of infrastructure is uniquely referred by everyone using the code. 


Steps to create resources:
-------------------------
1) Clone the Git repo in to a suitable local directory.

2) Run 'aws configure' to setup access key, secret key and region name (this is only needed first time)

3) The repo contains 2 folders viz. 'environments' and 'modules'. cd to 'environments/test' folder.

4) Run 'terraform init' (To initialise terraform binaries and compile the code)

5) Parameters specific to particular component can be amended as necessary i.e. app_port, asg_desired, asg_max values. There are certain default values set so if 'terraform plan' is executed, it would display resource list that will be created/modified.

6) Run 'terraform apply' (To trigger creation or amendment of those resources)
