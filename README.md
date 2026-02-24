# GitHub Actions + Terraform Demo

This repository demonstrates a complete CI/CD flow for a small React app:

- Build and test a frontend app with Vite + Vitest.
- Run SAST and container security checks with Snyk.
- Build and push a Docker image to AWS ECR.
- Provision and destroy AWS infrastructure with Terraform modules.

The project name in older docs mentions a REST API, but the current codebase is a frontend application deployed as a container.

## Tech Stack

- React 18
- Vite 3
- Vitest + Testing Library
- Docker (multi-stage build with Nginx runtime)
- Terraform (AWS provider)
- GitHub Actions
- AWS (ECR, ECS/Fargate, ALB, VPC, IAM)

## Project Structure

```text
rest-api-demo/
|-- .github/workflows/
|   |-- CI.yaml                  # Test, Snyk scans, Docker build/push to ECR
|   |-- infra.yaml               # Terraform plan/apply workflow
|   `-- infra destroy.yaml       # Terraform destroy workflow
|-- infrastructure/
|   |-- main.tf                  # Root Terraform config and module wiring
|   |-- variables.tf             # Input variables for root module
|   |-- terraform.tfvars         # Example variable values
|   `-- modules/
|       |-- vpc/                 # VPC + subnet resources
|       |-- alb/                 # Application Load Balancer resources
|       |-- ecs/                 # ECS cluster/service/task resources
|       `-- iam/                 # IAM roles/policies
|-- src/
|   |-- components/              # UI components + component tests
|   |-- assets/images/           # Static image assets
|   |-- test/setup.js            # Vitest setup
|   |-- App.jsx                  # Root component
|   `-- main.jsx                 # React entry point
|-- public/                      # Public static files
|-- Dockerfile                   # Builds app and serves dist via Nginx
|-- package.json                 # Node scripts and dependencies
`-- vite.config.js               # Vite + Vitest configuration
```

## Application Behavior

- The UI displays a page titled "Learn & Master GitHub Actions".
- `MainContent` toggles a help area and renders user input.
- `MainContent.jsx` currently contains an intentional XSS vulnerability using `dangerouslySetInnerHTML`.
  - This appears to be intentional to demonstrate SAST/security workflow behavior.

## Local Development

### Prerequisites

- Node.js 18+ (recommended)
- npm

### Install dependencies

```bash
npm ci
```

### Start dev server

```bash
npm run dev
```

### Run tests

```bash
npm test
```

### Build production assets

```bash
npm run build
```

### Preview production build

```bash
npm run preview
```

## Docker Workflow

### Build image locally

```bash
docker build -t rest-api-demo:latest .
```

### Run container locally

```bash
docker run --rm -p 8080:80 rest-api-demo:latest
```

Open http://localhost:8080

## GitHub Actions Workflows

### 1) `Test and Dockerize` (`.github/workflows/CI.yaml`)

Trigger:
- Manual (`workflow_dispatch`)

Stages:
1. `test`
   - Checks out code
   - Caches `node_modules`
   - Installs deps with `npm ci` (if cache miss)
   - Runs `npm test`
2. `SAST`
   - Runs Snyk code scan and Snyk open-source scan
   - Uploads SARIF reports to GitHub code scanning
3. `Dockerize_and_push`
   - Configures AWS credentials
   - Logs in to ECR
   - Builds image
   - Runs Snyk container scan
   - Pushes image tags if scan step does not fail

Required GitHub repository secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `ECR_REPOSITORY`
- `SNYK_TOKEN`

### 2) `Infrastructure setup` (`.github/workflows/infra.yaml`)

Triggers:
- Manual (`workflow_dispatch`)
- Push to paths under `Infrastructure/**`

Jobs:
1. `tf_plan`
   - Terraform init, fmt check, validate, and plan
   - Uploads `tfplan` artifact
2. `tf_apply`
   - Runs only on `main` branch
   - Downloads plan artifact and applies it
   - Targets environment: `Production`

Required GitHub repository secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### 3) `Infrastructure destroy` (`.github/workflows/infra destroy.yaml`)

This is for emergency deletion of resources to save on bills.. 😜

Trigger:
- Manual (`workflow_dispatch`)

Job:
- Initializes Terraform and runs `terraform destroy --auto-approve`

Required GitHub repository secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

## Terraform Notes

- Root Terraform config is in `infrastructure/main.tf`.
- Backend is configured as S3 + DynamoDB locking.
- Modules are split into `vpc`, `alb`, `ecs`, and `iam`.
- `terraform.tfvars` includes example values for CIDRs, ECS sizing, image URI, and container port.

## Important Path-Case Note

Current workflow files reference `Infrastructure` (capital `I`) while the folder in this repository is `infrastructure` (lowercase `i`).

On case-sensitive runners (Linux), this can break workflow execution unless paths are aligned. Consider updating workflow `WORKING_DIR` and `paths` entries to `infrastructure`.
