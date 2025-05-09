### Create Infrastructure using the provided code (without modification on code) ###

In the code we can see that the terraform version we need is the 0.12.31 version. 
So we need to install the good version. 
Here the link where we can download the binary : https://releases.hashicorp.com/terraform

To install the binary : 
We need to check the PATH of our OS. 
I'm on macbook, I check the PATH like this : echo $PATH

I have to put my binary on the directory : /usr/local/bin 
I have to do : mv terraform /usr/local/bin

And now, I have to make the binary executable : chmod +x /usr/local/bin/terraform

Now to verify the version : terraform version 
This commande will responde : Terraform v0.12.31

To make this code work, i have to change the provider's region. 

Without modification on code, we can lunch :
terraform init (init the work directory)
terraform fmt (reformate the space on the code)
terraform validate (validate the syntaxte of the code)
terraform plan (make the plan of the configuration)
terraform apply (apply the configuration on cloud)
terraform destroy (destroy the cloud's service)

### Verify if the code works in the latest version of Terraform and provider ###

```sh
$ terraform init
Initializing the backend...
╷
│ Error: Unsupported Terraform Core version
│ 
│   on tf-challenge-1.tf line 9, in terraform:
│    9:   required_version = "0.12.31"
│ 
│ This configuration does not support Terraform version 1.11.4. To proceed, either choose another supported Terraform version or update this version constraint. Version constraints are normally set for good
│ reason, so updating the constraint may lead to other errors or unexpected behavior.
╵
```

### Modify and fix the code so that can work with the latest version of Terraform and provider ###

For fix the code we have to comment the line ```required_version = "0.12.31"```

```sh
$ terraform init
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 2.54"...
- Finding latest version of hashicorp/digitalocean...
- Installing hashicorp/aws v2.70.4...
- Installed hashicorp/aws v2.70.4 (signed by HashiCorp)
╷
│ Warning: Version constraints inside provider configuration blocks are deprecated
│ 
│   on tf-challenge-1.tf line 2, in provider "aws":
│    2:   version = "~> 2.54"
│ 
│ Terraform 0.13 and earlier allowed provider version constraints inside the provider configuration block, but that is now deprecated and will be removed in a future version of Terraform. To silence this
│ warning, move the provider version constraint into the required_providers block.
│ 
│ (and one more similar warning elsewhere)
╵
╷
│ Error: Failed to query available provider packages
│ 
│ Could not retrieve the list of available versions for provider hashicorp/digitalocean: provider registry registry.terraform.io does not have a provider named registry.terraform.io/hashicorp/digitalocean
│ 
│ Did you intend to use digitalocean/digitalocean? If so, you must specify that source address in each module which requires that provider. To see which modules are currently depending on hashicorp/digitalocean,
│ run the following command:
│     terraform providers
╵
```

Now we have to comment the line ```version = "~> 2.54"```
And we have to add the configuration for the digital ocean : 

```terraform
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
```
Then we remake the command init :
```sh
$ terraform init
Initializing the backend...
Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Finding digitalocean/digitalocean versions matching "~> 2.0"...
- Installing digitalocean/digitalocean v2.53.0...
- Installed digitalocean/digitalocean v2.53.0 (signed by a HashiCorp partner, key ID F82037E524B9C0E8)
- Installing hashicorp/aws v5.97.0...
- Installed hashicorp/aws v5.97.0 (signed by HashiCorp)
Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://developer.hashicorp.com/terraform/cli/plugins/signing
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

To test the the syntax of the code, we make the commande :

```sh
$ terraform validate
╷
│ Warning: Argument is deprecated
│ 
│   with aws_eip.kplabs_app_ip,
│   on tf-challenge-1.tf line 19, in resource "aws_eip" "kplabs_app_ip":
│   19:   vpc = true
│ 
│ vpc is deprecated. Use domain instead.
╵
Success! The configuration is valid, but there were some validation warnings as shown above.
```

We have to change the resource aws_eip : 
```terraform 
resource "aws_eip" "kplabs_app_ip" {
  domain = "vpc"
}
```
After this change we can now revalidate the code :
```sh
$ terraform validate
Success! The configuration is valid.
```

Now we can make the cycle of the terraform :

```sh 
terraform init 
terraform validate
terraform fmt 
terraform plan
terraform apply -auto-approve
```

When we find out that all work, we can destroy the infrastructure : 

```sh
terraform destroy -auto-approve
```

### Feel free to edith the code as you like ###

I add a aws_instance and attache the aws_eip. 
I fetched the ami of the aws_instance from data block. 

```terraform
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "Challenge_1"
  }
}
```

Make the terraform command cycle to build the infrastructure. 

```sh
terraform fmt
terraform init
terraform validate
terraform apply -auto-approve
``` 

Check the infrastructure if it was build perfectly. 

Then, we can destroy the infrastructure : 
```sh
terraform destroy -auto-approve
```

CHALLENGE 1 DONE!