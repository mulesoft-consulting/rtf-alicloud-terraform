# RUNTIME FABRIC TERRAFORM PROJECT

This project aims to provide a configurable tool to install runtime fabric into alibaba cloud.


## INSTALL 

Make sure to install alibaba cloud CLI. [link](https://partners-intl.aliyun.com/help/doc-detail/139508.htm).

Make sure to install terraform. [link](https://learn.hashicorp.com/tutorials/terraform/install-cli).

## ENVIRONMENT

You need to provide alibaba cloud credentials `ALICLOUD_ACCESS_KEY`, `ALICLOUD_SECRET_KEY` and `ALICLOUD_REGION` as environment variables. 

usage : 

```
$ export ALICLOUD_ACCESS_KEY="anaccesskey"
$ export ALICLOUD_SECRET_KEY="asecretkey"
$ export ALICLOUD_REGION="cn-beijing"
```

## ENCODE MULE LICENSE KEY

To install Runtime Fabric, your Mule license key must be Base64 encoded. Locate your organization’s Mule Enterprise license key file (license.lic) and perform the following according to your operating system.

#### Linux
To encode your license file on Linux, run the following:
```bash
base64 -w0 license.lic
```

#### MacOS
To encode your license file on MacOS, run the following from the terminal:
```bash
base64 -b0 license.lic
```

#### Windows
To encode your license file on Windows, a shell terminal emulator (such as cygwin) or access to a Unix-based computer is required to follow these steps:

1. Find your organization’s Mule Enterprise license key file (license.lic) and transfer to your Unix environment if necessary.
1. Run the following command to Base64 encode the license key:

```bash
base64 -w0 license.lic
```

## Run

**List of Parameters**

| Name                | Description           | Example   |
| --------------------|:----------------------|-----------|
| activation_data     | The encoded Runtime Fabric activation data. You can access this data by viewing your Runtime Fabric in Runtime Manager. | NzdlMzU1YTktMzAxMC00OGE0LWJlMGQtMDdxxxx |
| key_pair            | The name of the keypair that is going to be created in the Alicloud region you are deploying to.|   my-keypair |
| public_key          | The public key that will be stored. You should create a key pair localy using `ssh-keygen -t rsa -b 4096` and use the public here.|    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCiMk7m user@example.com|
| enable_public_ips   | specifies whether the installer creates public IP addresses for each VM. Public IPs enable you to ssh directly to the VMs from your network. If this value is set to false(default) each VM only has access to the private network configured by its VPC. If you specify false, ensure you have consulted with your network administrator on how to obtain shell/SSH access to VMs.| true |
| controllers         | the number of controller VMs to provision.|  1 |
| workers             | the number of worker VMs to provision.    |  2 |
| mule_license        | the base64 encoded contents of your organization’s Mule Enterprise license key (license.lic).| |

**Steps**

1. Navigate to the project root directory. You must run Terraform from this directory.
2. Initialize Terraform
```bash
$ terraform init
```
3. Copy the following script to a text editor:
```bash
$ terraform apply \
    -var activation_data='' \
    -var key_pair='' \
    -var public_key='' \
    -var enable_public_ips='' \
    -var controllers='1' \
    -var workers='2' \
    -var mule_license='' \
    -state=tf-data/rtf.tfstate
```

4. Modify this using the data in the environment variables tables above.
5. Ensure your terminal has access to the Alicloud-specific environment variables required as described above.
6. Run the script.


## Links

- List of Alibaba regions: [link](https://www.alibabacloud.com/help/doc-detail/40654.htm)
- Runtime Fabric install guide for AWS: [link](https://docs.mulesoft.com/runtime-fabric/latest/install-aws)
- Product Comparison AWS vs Alibaba: [link](http://docs-aliyun.cn-hangzhou.oss.aliyun-inc.com/pdf/comparison-AlicloudlvsAWS-intl-en-2018-03-26.pdf)
