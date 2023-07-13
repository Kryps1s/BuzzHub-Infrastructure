# BuzzHub - Infrastructure Repository

Welcome to the BuzzHub Infrastructure repository! This repository contains the HashiCorp Configuration Language (HCL) code used to define and manage the cloud infrastructure for the BuzzHub project. The infrastructure code automates the provisioning and configuration of the required cloud resources.

## Getting Started

To get started with the BuzzHub Infrastructure, please follow the instructions below:

1. Clone the repository to your local machine using the following command:

`git clone github.com/Kryps1s/BuzzHub-Infrastructure`

2. Navigate to the project directory:

`cd BuzzHub-Infrastructure`

3. Configure the necessary environment variables and access credentials for your cloud provider. This typically involves setting up your provider's CLI tool and authenticating. Contact Elliot for help with this step.

4. Update the infrastructure configuration files located in the repository according to your project requirements. These files define the cloud resources, such as compute instances, networking, storage, and other components.

5. Deploy the infrastructure by running the following command:

`terraform init`
`terraform plan`
`terraform apply`

The `terraform init` command initializes the Terraform configuration. The `terraform plan` command generates an execution plan, and the `terraform apply` command applies the changes to create or update the infrastructure.

6. Review the output of the `terraform apply` command for any errors or warnings, and confirm the changes to proceed with infrastructure deployment.

7. Once the deployment is complete, you will have your cloud infrastructure set up and ready to use for the BuzzHub project.

## Project Structure

The project structure of the BuzzHub Infrastructure repository is as follows:

- `/main.tf`: The main configuration file that defines the infrastructure resources.
- `/variables.tf`: The file that declares input variables used in the infrastructure configuration.
- `/appsync.tf`: The file that defines appsync resources.
- `/dynamodb.tf`: The file that defines dynamodb resources.
- `/iam.tf`: The file that defines iam resources, such as users, usergroups, and policies.
- `/state.tf`: The file that defines management of this projet's terraform state in a s3 bucket.
  
## Linting with TFLint

To ensure best practices and maintain consistency in your infrastructure code, you can use TFLint for linting. TFLint is a Terraform linter that checks your code for potential errors and violations of best practices. To run TFLint, execute the following command:

`tflint`

This command will analyze your Terraform code and provide feedback on any issues or recommendations it detects.

## Technologies Used

The BuzzHub Infrastructure is managed using the following technologies:

- [Terraform](https://www.terraform.io/): An infrastructure-as-code tool that enables declarative provisioning of cloud resources.
- [HashiCorp Configuration Language (HCL)](https://github.com/hashicorp/hcl): The language used to write the configuration files for Terraform.


## Contributing

We welcome contributions to the BuzzHub project! If you would like to contribute, please follow these guidelines:

1. Fork the repository on GitHub.
2. Create a new branch with a name based off a user story on the [Kanban Board](https://tree.taiga.io/project/kryps1s-bee/kanban).
3. Commit your changes and push them to your forked repository.
4. run the command `tflint` to ensure that there are no linting errors.
5. Submit a pull request to the main repository, describing your changes in detail.

## License

The BuzzHub project is licensed under the [MIT License](LICENSE). Feel free to modify and use the code for your own purposes.

## Contact

If you have any questions or feedback regarding the BuzzHub project, please contact me at [eoreilly1994@gmail.com]. I appreciate your interest and support!
