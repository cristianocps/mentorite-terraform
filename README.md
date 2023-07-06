App Stack
=========

This repository has automation for various application deployments on the Oracle Cloud Infrastructure (OCI) using serverless resources such as Container Instances and Autonomous Database. In the current version only Java applications are supported. 

The Container Instances service is an ideal deployment platform as it is serverless and cost effective.
# Target Applications

**Web applications** Server-side HTML applications, a.k.a. servlets or Java Server Pages
**Back-end servers** REST APIs
# App Stack for Java

**App Stack for Java** is a customizable Terraform Stack designed to automate the deployment of Java applications (the backend only) in a serverless infrastructure. Follow the instructions below to learn how to utilize the stack to seamlessly deploy Java applications to Container Instances, creating a production-ready environment.

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oracle-quickstart/appstack/releases/download/v0.1.1/appstackforjava.zip) 

![Blueprint architecture](https://github.com/oracle-quickstart/appstack/blob/main/images/blueprintarchitecture.svg)

Your Java application can be packaged in 3 ways:
1. As **source code**: this is the most valuable use case. Your source code can be in a github repo and mirrored in OCI DevOps (see details below). The stack will create a build pipeline that:
    - Builds a container image of your application using your build instructions (for example 'mvn install'). The container image uses JDK17 to run your application.
    - Automatically deploys new versions of the git branch you have selected during the configuration.
2. As a **Java artifact (JAR or WAR)**: the stack configures the JDBC DataSource for the selected Database and creates a build pipeline that:
    - Builds a container image of your application by either executing the Jar (JDK17 is used) or deploying the War in Tomcat 9.
    - Automatically deploys new versions of the artifact.
3. As a  **container image**: your application is already packaged in a *container image* published in the container registry.

In all cases the deployment is done on Container Instances behind a load balancer.

## Release and status
 - This is v0.1.0: initial release as a preview.

## Prerequisites

For deploying your Java App with the App Stack, here is the list of OCI prerequisites.

- **DevOps project (optional):** A Java application in an OCI DevOps project (can be a mirror of an existing GitHub repo). This isn't required if the application is provided as a container image.
- **Database:** an existing Autonomous Database  - Shared Infrastructure (ADB-S) can be used with the stack. The stack may create a new one, if specified during the Stack configuration. 
- **Vault (optional):** A new user in IAM (<application_name>-user) is created and his token used for connectng to the DevOps repo, is stored in the vault. When the stack is destroyed this user is removed. A Vault is necessary to avoid the limit on the number of tokens the current user has however, the Vault isn't required if the application is provided as a container image.
- **DNS (optional):** A DNS zone for creating the application URL (for example https://myapp.domain.com). If not provided during the stack configuration, the application will be available through the load balancer's public IP. You can then configure your third-party DNS provider to point to this IP address.
- **HTTPS certificate (optional):** is needed for the load balancer. If no certificate is provided, HTTP will be used against the IP address.


## Which Cloud Resources will be used?

The [Oracle Cloud Free Tier service](https://www.oracle.com/cloud/free/) allows you to  build, test, and deploy your applications on Oracle Cloud for free. Upon signing up, the service comes with a $300 credit with 30 days expiration; following the expiration or the exhaustion of the credit, most of the provisioned services remain available  as [Always Free](https://www.oracle.com/cloud/free/#always-free). You may add additional credit for services that do not fall under Always-Free.
- **Container Instances** for building and running  the app. This service is part of Free-Tier but not an Always-Free resource. 
- **DevOps** for the build pipeline and CI/CD. This service is part of Free-Tier but not an Always-Free resource (it uses Container Instances under the covers).
- **ADB-S** for persistence. This service is part of Always-Free. 
- **Vault** for enhanced security. This service is part of Always-Free. 
- **APM** for monitoring. This service is part of Always-Free with some limits. The stack has a checkbox to specify that *always free* should be used.
- **Load Balancer** for scalability.  This service is part of Always-Free with some limits.
- **HTTPS Certificates**. This service is part of Always-Free with some limits. 
- **DNS** for application URL. This service is part of Free-Tier but not an Always-Free resource. 


## Usage Instructions

Please refer to the [usage instructions](./usage_instructions.md) for details about each field of the stack form.

### What will the stack do?

 - Create a new repository called "<application-name>_config" that includes:
   - **wallet.zip:** The database wallet (the zip that includes tnsnames.ora, cwallet.sso and ojdbc.properties) If the database wallet is rotated this zip file needs to be updated.
   - **Dockerfile:** used to build the container image
   - **build_spec.yaml:** build spec for the build pipeline
   - **self.keystore:** self-signed keystore for the internal https connection between the load balancer and the container instances
   - **orapki.jar:** used by the build pipeline to add the db password to cwallet.sso.
 - Generate a *container image* of the user's application, including an HTTP/HTTPS server and pre-configured ADB access
 - Add the generated image to the Container Registry
 - Deploy the application as a container in **Container Instances**
   - leverage OCI services such as VCN, Object stores 
 - Terraform script for provisioning the Autonomous Database
 - Dependencies to pull JDBC, UCP, R2DBC, and so on from Maven  Central. 

## Destroying the stack

Before you can destroy the stack and all the resources that have been created you must manually delete the artifact that the stack has created under the "Artifact Registry".

## Tutorial

[MyTodoList SpringBoot application tutorial](./tutorials/mytodolist/tutorial.md).

## Contributing

This project welcomes contributions from the community. Before submitting a pull
request, see [CONTRIBUTING](./CONTRIBUTING.md) for details.

## License

Copyright (c) 2023, Oracle and/or its affiliates.
Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
See [LICENSE](./LICENSE) for more details.

## Support

Please review the [troubleshooting document](./troubleshooting/troubleshooting.md).
For support you can [file issues on GitHub](https://github.com/oracle-quickstart/appstack/issues).
You can also send an email to the product team at "appstack_ww at oracle.com".

## Appendix

### Build instructions
To build the zip on a mac from this directory:
```
zip -r ../appstackforjava.zip . -x "*.git*" -x "*.DS_Store" -x "images" -x "listing" -x "*.md" -x "troubleshooting" -x "tutorials" 
```


To manually create the Stack on OCI:
 - Download the zip (under project download)
 - Log in to OCI
 - Navigate to "Resource manager" -> "Stacks"
 - Click on "Create Stack"
 - Choose "My configuration"
 - On "Stack configuration" use the ZIP file to create the Stack
