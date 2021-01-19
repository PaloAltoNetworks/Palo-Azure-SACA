</br>
<p align="center">
<img src="https://github.com/PaloAltoNetworks/Palo-Azure-SACA/blob/main/Azure/azure_vdms_dist/images/Azure%20saca%20architecture.png?raw=true">
</p>





# Deploying an Azure Secure Cloud Computing Architecture (SCCA) with Palo Alto Networks  


## Prerequisites

- Valid Azure Subscription 
- Access to Azure Cloud Shell 
- Valid VM-Series authcode (If using BYOL)
- Panorama network information (only if using the Panorama for bootstrapping)


## Setup and configuration of the Terraform code 

Setup and Download the Build

In the Azure portal, open Azure Cloud Shell and run the following in **BASH ONLY**

## Accept the VM-Series EULA for desired license type (BYOL, Bundle1, or Bundle2)
## Select just one license type and Pan OS below 
$ az vm image terms accept --urn paloaltonetworks:vmseries1:<byol/bundle1/bundle2>:10.0.1

# Download the terraform code from the repo
$ git clone https://github.com/PaloAltoNetworks/Palo-Azure-SACA  


## Configuration changes to Terraform 

Prior to running the terraform, there are several changes that need to be made based on the desired outcome. The following files should be reviewed and edited to fit your deployment needs. 

Open the **terraform.tfvars** file. 

- **Firewall License**: The first few lines are the firewall licensing options. After determining your license option, please uncomment that option only. The default is set for **"byol"**. 
- **Location**: Select the desired commerical or government region and uncommented if necessary to reflect the correct location/environment. 
- **Pan OS**: In the VM-Series resource group variable section, please confirm that you have the correct Pan OS. The default is **"10.0.1"**. 

## Deployment Options
Please review each deployment options and only make changes for the ones that are applicable 

  - **Licensing the firewall**. If you want the terraform build to license the firewalls once deployed for **byol** customer, from the **Azure/azure_vdms_dist/bootstrap_files/vmseries/license** directory. edit the authcode file and add your authcode on line 1. 

If you do not enter an authcode, the firewalls will still deploy, but will require a license post-deployment to enable full functionality 

## Deploy Build

After uploading the code to Azure Shell, change to the directory Azure/azure_vdms_dist. Run **terraform init**  to initialize the code. Then run **terraform plan** to confirm what will be built. Take note of the number of resources being built. Then run **terraform apply** to begin the build process. You will have to enter a value of **yes** to start the build.

- $terraform init 
- $terraform plan
- $terraform apply 

It may take up to 15 minutes to build the infrastructure and for the firewalls to fully boot. One the build is complete, copy the output data generated and save for later use

## Destroy Build

To destroy the build, verify that you are in the **Azure/azure_vdms_dist** directory. Run **terraform destroy**. Review the , [number] to destroy. and enter **yes** to confirm. Once the destroy is complete, you will receive the following message **"Destroy complete! Resources: [number] destroyed. 

- $terraform destroy

**IMPORTANT** Manual changes made in Azure outside of the terraform build will not be destroyed. Once the terraform destroy is complete, login to Azure and confirm all resources, including manually changes, have been destroyed. 
