# Project - CI/CD Deployment on GCP on GKE
## Step 0 - Docker image creation with App and its dependencies for testing
- Create a GCP Artifacts Repo:
  - `gcloud beta artifacts repositories create my-docker-repo --repository-format=docker --location=us-central1`
- Create the image with all App dependencies:
  - In the Dockerfile path: `docker build -t my-app-image:v1.0 .`
  - In the Dockerfile path: `docker build -t my-app-image:v2.0 .`
- To validate the new created image, run a container with our image:
  - `docker run -p <puerto-en-host>:<puerto-en-contenedor> <nombre-de-imagen>`
## Step 1 - Image creation and upload with **cloudbuild.yaml**
- Sign in to GCP:
  - `gcloud auth login`
- Configure the project:
  - `gcloud config set project PROJECT_ID`
  - Example: `gcloud config set project aiimdxghbalyvvw0ahpt6kz3uciv7i`
- Configure the Artifact Repository:
  - `gcloud auth configure-docker [LOCATION]-docker.pkg.dev` , donde LOCATION es la región a usar
  - Example: `gcloud auth configure-docker us-central1-docker.pkg.dev`
- Generate the  [cloudbuild.yaml](cloudbuild.yaml) file:
```
steps:
- name: 'gcr.io/cloud-builders/docker'
  args: [ 'build', '-t', 'us-central1-docker.pkg.dev/${PROJECT_ID}/my-docker-repo/my-app-image', '.' ]
- name: 'gcr.io/cloud-builders/docker'
  args: ['push', 'us-central1-docker.pkg.dev/${PROJECT_ID}/my-docker-repo/my-app-image']
```
- Run the build and upload command:
  - `gcloud builds submit --config cloudbuild.yaml .`
  - **IMPORTANT!:** the command must be launched from the path where the *Dockerfile* is located.
## Step 2 - Generate Terraform files to deploy a GKE cluster and deploy the app
- Sign in to GCP:
  - `gcloud auth login`
- Configure the project:
  - `gcloud config set project PROJECT_ID`
  - Example: `gcloud config set project aiimdxghbalyvvw0ahpt6kz3uciv7i`
- Generate the Terraform file:
  - Create the [main.tf](terraform/main.tf) file, which contains the logic for creating the GKE cluster and deploying the application.
  - Create the file for deploying the app [my-app.yml](terraform/my-app.yml)
- Run the Terraform flow:
```
terraform init
terraform plan
terraform apply
```
## Step 3 - Answer the IAM privileges/roles question
- As we didn't have privileges to create accounts in IAM, we had to respond theoretically:
  - The DevOps team should be granted the **Kubernetes Engine Cluster Admin** role, provides access to management of clusters.
  - The Finance team should be granted the **Billing Account Viewer** role, it provides access to spend information, but does not confer the right to link or unlink projects or otherwise manage the properties of the billing account.
