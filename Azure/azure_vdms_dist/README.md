# Deploying an Azure Secure Cloud Computing Architecture (SCCA) with Palo Alto Networks  

Terraform creates two load balanced VM-Series firewalls deployed in a single VNET with two VDMS virtual machines (Windows & Ubuntu).  The VM-Series firewalls secure all ingress/egress to and from the VDMS subnet.  All traffic originating from the VDMS subnet is routed to VM-Series internal load balancer.  All inbound traffic from the internet is sent through a public load balancer.

</br>
<p align="center">
<img src="https://raw.githubusercontent.com/PaloAltoNetworks/Palo-Azure-SACA/main/Azure/azure_vdms_dist/images/Azure%20saca%20architecture.png">
</p> 


## Prerequistes 
* Valid Azure Subscription
* Access to Azure Cloud Shell
* Valid VM-Series authcode (If using BYOL)
* Panorama network information (only if using the Panorama for bootstrapping)

## How to Deploy
### 1. Setup & Download Build
In the Azure Portal, open Azure Cloud Shell and run the following **BASH ONLY!**.
```
# Accept VM-Series EULA for desired license type (BYOL, Bundle1, or Bundle2)
$ az vm image terms accept --urn paloaltonetworks:vmseries1:<byol><bundle1><bundle2>:10.0.1

# Download repo & change directories to the Terraform build
$ git clone https://github.com/PaloAltoNetworks/Palo-Azure-SACA.git; cd Palo-Azure-SACA/Azure/azure_vdms_dist
```

### 2. Edit terraform.tfvars
Open terraform.tfvars and uncomment one value for fw_license that matches your license type from step 1.  The variables below should also be edited to suit  your environment. 
 
* **Firewall License**: The first few lines are the firewall licensing options. After determining your license option, please uncomment that option only. The default is set for **"byol"**. 
* **Location**: Select the desired commerical or government region and uncommented if necessary to reflect the correct location/environment. 
* **Pan OS**: In the VM-Series resource group variable section, please confirm that you have the correct Pan OS. The default is **"10.0.1"**. 

```
$ vi terraform.tfvars
```

<p align="center">
<b>Your terraform.tfvars should look like this before proceeding</b>
<img src="https://raw.githubusercontent.com/wwce/terraform/master/azure/transit_2fw_2spoke_common/images/tfvars.png" width="75%" height="75%" >
</p>    


#### Deployment Options
Please review each deployment options and only make changes for the ones that are applicable

* Licensing the firewall. If you want the terraform build to license the firewalls once deployed for byol customer, from the Azure/azure_vdms_dist/bootstrap_files/vmseries/license directory. edit the authcode file and add your authcode on line 1.
* If you do not enter an authcode, the firewalls will still deploy, but will require a license post-deployment to enable full functionality


### 3. Deploy Build
After uploading the code to Azure Shell, change to the directory Azure/azure_vdms_dist. Run terraform init to initialize the code. Then run terraform plan to confirm what will be built. Take note of the number of resources being built. Then run terraform apply to begin the build process. You will have to enter a value of yes to start the build.

```
$ terraform init
$ terraform apply
```

It may take up to 15 minutes to build the infrastructure and for the firewalls to fully boot. One the build is complete, copy the output data generated and save for later use

## How to Destroy
Run the following to destroy the build.  Verify that you are in the Azure/azure_vdms_dist directory. 
```
$ terraform destroy
```

