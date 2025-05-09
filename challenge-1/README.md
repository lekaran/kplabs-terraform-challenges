Create Infrastructure using the provided code (without modification on code)

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