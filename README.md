# RUNTIME FABRIC TERRAFORM PROJECT

This project aims to provide a configurable tool to install runtime fabric into alibaba cloud.


## INSTALL 

Make sure to install alibaba cloud CLI. [link](https://partners-intl.aliyun.com/help/doc-detail/139508.htm).

Make sure to install terraform. [link](https://learn.hashicorp.com/tutorials/terraform/install-cli).


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


## COMMON ERRORS

Sometimes the deployment takes a little bit of time to create all the stack and some elements take more time than others which can provoke a timeout kind of error that makes the deployment fail. 

**Resource not ready**
```bash
Error: [ERROR] terraform-provider-alicloud/alicloud/resource_alicloud_instance.go:428: Resource alicloud_instance RunInstances Failed!!! [SDK alibaba-cloud-sdk-go ERROR]:
SDK.ServerError
ErrorCode: IncorrectVSwitchStatus
Recommend: https://error-center.aliyun.com/status/search?Keyword=IncorrectVSwitchStatus&source=PopGw
RequestId: EE42C3F4-F222-4E3C-A9DC-76F644031264
Message: The current status of vSwitch does not support this operation.
```
```bash
ErrorCode: IncorrectStatus.cbnStatus
Recommend: https://error-center.aliyun.com/status/search?Keyword=IncorrectStatus.cbnStatus&source=PopGw
RequestId: 7FBF738E-C773-42FA-B7CC-38E26D885255
Message: Current CBN status does not support this operation.
```

This is provoked by the fact that the resource is not completely ready and its status is not the one terraform is hoping for. 

In order to correct that, just re execute the apply or destroy (depending on what you were performing) once again. Terraform will automatically detect that you already have some elements of the stack and will react accordingly.

**OperationConflict**
```bash
ErrorCode: OperationConflict
Recommend: https://error-center.aliyun.com/status/search?Keyword=OperationConflict&source=PopGw
RequestId: CF02F11B-6CFA-40D6-8CF8-CC47C1F5EFF3
Message: The operation against this instance is too frequent, please try again later.
```

This is provoked by the fact that terraform is performing operation too quickly for alicloud to absorb so it fails. This happens usually when you try to destroy your terraform formation. Just re-run the command in this situation, Terraform is smart enough to pick it up where it left.  


## Links

- List of Alibaba regions (codes): [link](https://www.alibabacloud.com/help/doc-detail/40654.htm)
- List of Alibaba Zones (codes): [link](https://www.alibabacloud.com/help/doc-detail/89155.htm)
- Runtime Fabric install guide for AWS: [link](https://docs.mulesoft.com/runtime-fabric/latest/install-aws)
- Product Comparison AWS vs Alibaba: [link](http://docs-aliyun.cn-hangzhou.oss.aliyun-inc.com/pdf/comparison-AlicloudlvsAWS-intl-en-2018-03-26.pdf)
