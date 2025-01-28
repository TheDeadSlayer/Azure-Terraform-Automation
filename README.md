# Azure-Terraform-Automation

This project demonstrates the deployment of a **Simple React TS Vite App** on **Azure Cloud** using **Terraform** and **Azure DevOps Pipelines**. It automates the creation and configuration of Azure resources required to host both the frontend and backend of the application.

## Resources Created

### 1. **Resource Group**
- A centralized Azure **Resource Group** to organize and manage all the components.

### 2. **Web Apps**
- **Frontend Web App**: Hosts the React + Vite + TypeScript application.
- **Backend Web App**: Hosts the Express.js API.

### 3. **Azure Container Registry (ACR)**
- Stores the Docker image for the **backend API**, ensuring efficient and secure deployment.

### 4. **PostgreSQL Flexible Server**
- A managed **PostgreSQL database** to store application data with high availability and scalability.

### 5. **Azure Blob Storage**
- Used to store frontend build artifacts for reliable and scalable static file hosting.

## Deployment Workflow

### 1. **Infrastructure as Code (IaC) with Terraform**
- All Azure resources are defined and provisioned using **Terraform**, ensuring reproducibility and scalability.
- Includes modules for:
  - Resource Group creation
  - Web Apps setup
  - ACR setup
  - PostgreSQL server provisioning
  - Blob Storage configuration

### 2. **CI/CD with Azure DevOps Pipelines**
- Automated pipelines for building, testing, and deploying the application.
- **Frontend Pipeline**:
  - Builds the React application.
  - Deploys the build artifacts to Azure Blob Storage.
- **Backend Pipeline**:
  - Builds the Docker image for the API.
  - Pushes the image to Azure Container Registry (ACR).
  - Deploys the API to the Azure Web App.

## Key Features
- **End-to-End Deployment**: Complete automation of infrastructure provisioning and application deployment.
- **Scalable Architecture**: Utilizes Azure's cloud services to ensure scalability and reliability.
- **Cost Optimization**: Efficient use of Azure resources to minimize costs.
- **Secure Hosting**: Ensures secure storage and hosting for both frontend and backend components.

This project showcases the integration of modern cloud services, infrastructure as code, and DevOps pipelines to deliver a fully functional and cloud-native application. Feel free to explore, contribute, or adapt it to your own use cases!
