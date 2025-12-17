# CI/CD Deployment to Azure Web App for Containers

## Overview

This repository demonstrates a simple CI/CD pipeline that builds a Dockerized application, 
pushes the image to Azure Container Registry (ACR), and deploys it to an Azure Web App for Containers using GitHub Actions.

The setup enables automated build and deployment whenever code is pushed to the GitHub repository.

---

## Architecture Overview

**High-level flow:**

```
GitHub → GitHub Actions → Azure Container Registry → Azure Web App → Users
```

---

## Components

### 1. Source Code (GitHub)

* Application source code is hosted in a GitHub repository
* Any code push triggers the CI/CD pipeline

### 2. CI/CD Pipeline (GitHub Actions)

The GitHub Actions workflow performs the following steps:

1. **Build Docker Image**

   * Builds a Docker image from the application source code

2. **Push Image to Azure Container Registry (ACR)**

   * Authenticates with ACR
   * Pushes the built Docker image to the registry

3. **Deploy to Azure Web App**

   * Triggers deployment using the latest image stored in ACR

---

### 3. Azure Container Registry (ACR)

* Stores Docker images built by the CI/CD pipeline
* Acts as the image source for the Azure Web App
* Example image tag:

  ```
  health-app:latest
  ```

---

### 4. Azure Web App for Containers

* Pulls the Docker image from ACR
* Runs the container on Azure App Service
* Automatically updates when a new image is deployed

---

### 5. Application Endpoint

* The application exposes a health check endpoint:

```
GET /health
```

* Example response:

```json
{
  "status": "ok"
}
```

---

### 6. User Access

* End users access the application via the Azure Web App URL
* Requests are handled by the running Docker container

---

## Deployment Flow (Step-by-Step)

1. Developer pushes code to GitHub
2. GitHub Actions workflow is triggered
3. Docker image is built
4. Image is pushed to Azure Container Registry
5. Azure Web App pulls the latest image
6. Application is deployed and available to users

---

## Summary

This setup provides a clean and automated way to build, store, and deploy containerized applications to Azure using GitHub Actions, ACR, and Azure Web App for Containers.
