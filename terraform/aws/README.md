# Encryption IAC Terraform AWS

```text
  The information in this article should be used as a guide only. If you are deploying this method into a production environment, we recommend that you also follow all security and configuration best practices.
```

This terraform will create the following:

* 4 [KMS](./kms.tf) keys
* [subnet](./subnet.tf)
* [EBS volume](./volume.tf)
* [EC2 instance](./instance.tf)

## Volume

The EBS volume is optional, although recommended for production environments.

## Userdata

The [userdata](./userdata.tftpl) will install corsa's pii package from [https://deb.corsa.finance](https://deb.corsa.finance) and automount the volume at `/var/lib/corsa-pii`

## Variables

| Variable         | Description                                                           | Default                              | Required |
| ---------------- | --------------------------------------------------------------------- | ------------------------------------ | -------- |
| `vpc_id`         | The ID of the VPC                                                     | -                                    | Yes      |
| `nat_gateway_id` | The ID of the NAT Gateway                                             | -                                    | Yes      |
| `ami_owner`      | The owner of the AMI                                                  | `"324011078465"`                     | No       |
| `key_name`       | The name of the key pair                                              | `"bastion-ssh-key"`                  | No       |
| `package_name`   | The package name, defaults to corsa-pii if PACKAGE_VERSION is not set | `"corsa-pii"`                        | No       |
| `corsa_jwks`     | JWT key service url                                                   | `"https://jwks.corsa.finance/"`      | No       |
| `auth0_audience` | auth0 jwt audience                                                    | `"EfoTQJf4D14Mkuqhmn46OtvtcC16otdA"` | No       |
| `cidr`           | subnet cidr                                                           | -                                    | Yes      |
| `zone`           | availability zone                                                     | `"us-east-1a"`                       | No       |


## Ingress

**NOTE** this terraform does not include a ALB, TLS certificate (ACM) or a DNS record. This is required for application deployment. Our [SDK](https://docs.corsa.finance/update/docs/sdk#/) and browser web [app](https://app.corsa.finance) needs TLS access to this application, without it, sensitive data will not be decrypted.
