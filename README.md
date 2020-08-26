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

## Run

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
    -var enable_public_ips='' \
    -var controllers='3' \
    -var workers='3' \
    -var mule_license='' \
    -state=tf-data/rtf.tfstate
```


## Links

- List of Alibaba regions: [link](https://www.alibabacloud.com/help/doc-detail/40654.htm)
- Runtime Fabric install guide for AWS: [link](https://docs.mulesoft.com/runtime-fabric/latest/install-aws)
