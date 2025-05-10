### Ensure the code is working and resource gets create ###

We have to init the workspace. 

```sh
$ terraform init 
Initializing the backend...
╷
│ Error: Terraform encountered problems during initialisation, including problems
│ with the configuration, described below.
│ 
│ The Terraform configuration must be valid before initialization so that
│ Terraform can determine which modules and providers need to be installed.
│ 
│ 
╵
╷
│ Error: Unsupported block type
│ 
│   on tf-challenge-2.tf line 48:
│   48:  egress {
│ 
│ Blocks of type "egress" are not expected here.
╵
╷
│ Error: Unsupported block type
│ 
│   on tf-challenge-2.tf line 48:
│   48:  egress {
│ 
│ Blocks of type "egress" are not expected here.
```

The "egress" brloc was outside of the aws_security_group bloc and that generate error. 
After we replace the "egress" bloc in the aws_security_group bloc, we re-do the init commande :

```sh
$ terraform init
Initializing the backend...
Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Installing hashicorp/aws v2.70.4...
- Installed hashicorp/aws v2.70.4 (signed by HashiCorp)
Terraform has made some changes to the provider dependency selections recorded
in the .terraform.lock.hcl file. Review those changes and commit them to your
version control system if they represent changes you intended to make.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

From now, we need to verify the syntax of the code. 

```sh
$ terraform validate
╷
│ Error: "domain": this field cannot be set
│ 
│   with aws_eip.example,
│   on tf-challenge-2.tf line 56, in resource "aws_eip" "example":
│   56: resource "aws_eip" "example" {
│ 
╵
```

With the version of the AWS provider the eip resource hate to use vpc = true, so we have to change it in the code. 

```terraform 
resource "aws_eip" "example" {
  #  domain = "vpc"
  vpc = true
}
```

We recheck the syntax of the code. Here normaly the code is good. 

Now we have to make the plan of our code. 

```terraform 
$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_eip.example will be created
  + resource "aws_eip" "example" {
      + allocation_id     = (known after apply)
      + association_id    = (known after apply)
      + customer_owned_ip = (known after apply)
      + domain            = (known after apply)
      + id                = (known after apply)
      + instance          = (known after apply)
      + network_interface = (known after apply)
      + private_dns       = (known after apply)
      + private_ip        = (known after apply)
      + public_dns        = (known after apply)
      + public_ip         = (known after apply)
      + public_ipv4_pool  = (known after apply)
      + vpc               = true
    }

  # aws_security_group.security_group_payment_app will be created
  + resource "aws_security_group" "security_group_payment_app" {
      + arn                    = (known after apply)
      + description            = "Application Security Group"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 8088
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8088
                # (1 unchanged attribute hidden)
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = (known after apply)
              + from_port        = 8443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8443
                # (1 unchanged attribute hidden)
            },
          + {
              + cidr_blocks      = [
                  + "172.31.0.0/16",
                ]
              + from_port        = 443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 443
                # (1 unchanged attribute hidden)
            },
          + {
              + cidr_blocks      = [
                  + "172.31.0.0/16",
                ]
              + from_port        = 8080
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8080
                # (1 unchanged attribute hidden)
            },
        ]
      + name                   = "payment_app"
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + vpc_id                 = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

We can apply the code.
Now we have to check on the aws console that the services are up. 
Don't forget to destroy the infrastructure after the exercice. 

### Do not delete the existing .terrafirl.lock.hcl file. File is free to be modified based on requirements. ###

### Demonstrate ability to modify variable "splunk" from 8088 to 8089 without modifying the Terraform code ###

To modify the "splunk" variable without modifying the terraform code, we have to do :

```terraform 
$ terraform plan -var='splunk="8089"'

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_eip.example will be created
  + resource "aws_eip" "example" {
      + allocation_id     = (known after apply)
      + association_id    = (known after apply)
      + customer_owned_ip = (known after apply)
      + domain            = (known after apply)
      + id                = (known after apply)
      + instance          = (known after apply)
      + network_interface = (known after apply)
      + private_dns       = (known after apply)
      + private_ip        = (known after apply)
      + public_dns        = (known after apply)
      + public_ip         = (known after apply)
      + public_ipv4_pool  = (known after apply)
      + vpc               = true
    }

  # aws_security_group.security_group_payment_app will be created
  + resource "aws_security_group" "security_group_payment_app" {
      + arn                    = (known after apply)
      + description            = "Application Security Group"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 8089
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8089
                # (1 unchanged attribute hidden)
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = (known after apply)
              + from_port        = 8443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8443
                # (1 unchanged attribute hidden)
            },
          + {
              + cidr_blocks      = [
                  + "172.31.0.0/16",
                ]
              + from_port        = 443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 443
                # (1 unchanged attribute hidden)
            },
          + {
              + cidr_blocks      = [
                  + "172.31.0.0/16",
                ]
              + from_port        = 8080
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8080
                # (1 unchanged attribute hidden)
            },
        ]
      + name                   = "payment_app"
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + vpc_id                 = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

Here we can look that the port on the egress bloc are changed. 