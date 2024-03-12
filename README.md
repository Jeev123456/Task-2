
## Overview

This repository contains Terraform code to automate the provisioning of MySQL 8.x RDS instances with specified configurations. Additionally, it includes modules for user management and a multi-tier architecture design with an EC2 instance for secure access to the RDS instance.

## Table of Contents

-   [Prerequisites](https://chat.openai.com/c/57a16d82-e4f9-45aa-bd59-97c017e59b8f#prerequisites)
-   [Repository Structure](https://chat.openai.com/c/57a16d82-e4f9-45aa-bd59-97c017e59b8f#repository-structure)
-   [Setup Instructions](https://chat.openai.com/c/57a16d82-e4f9-45aa-bd59-97c017e59b8f#setup-instructions)
-   [Usage](https://chat.openai.com/c/57a16d82-e4f9-45aa-bd59-97c017e59b8f#usage)


## Prerequisites

Before you begin, ensure you have the following prerequisites:

-   Terraform installed on your machine.
-   AWS credentials configured with appropriate permissions.

## Repository Structure

The repository is organized as follows:


    ├── data.tf
    ├── modules
    │   └── rds
    │       ├── main.tf
    │       ├── outputs.tf
    │       └── variables.tf
    ├── prod.tfvars
    ├── rds.tf
    ├── script.sh
    └── variables.tf


- `data.tf`: Terraform file for managing data-related configurations.
- `modules/rds/`: Directory containing the Terraform module for provisioning MySQL RDS instances.
- `prod.tfvars`: Configuration file for production environment variables.
- `rds.tf`: Main Terraform configuration file for defining RDS infrastructure.
- `script.sh`: To create user in RDS
- `variables.tf`: File defining input variables for Terraform modules.

## Setup Instructions

1.  Clone this repository:
    

    
    `git clone https://github.com/yourusername/terraform-mysql-rds.git
    cd terraform-mysql-rds` 
    
2.  Customize the configuration by modifying the variables in `main.tf` and `variables.tf` according to your requirements.
    
3.  Run the following Terraform commands:
    

    `terraform init
    terraform apply` 
    
4.  Follow the prompts to confirm the changes and provision the infrastructure.
    

## Usage

After running the setup instructions, the MySQL RDS instances and associated resources will be provisioned according to the specified configurations. Access information, such as endpoint URLs and login credentials, will be available as outputs.
