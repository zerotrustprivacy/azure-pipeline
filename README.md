# azure-pipeline
App: Simple Python API (FastAPI is great here).

Infrastructure: Terraform (to provision a simple Azure App Service).

The Gatekeeper: A Python script that orchestrates the quality checks.

CI/CD: GitHub Actions or Azure DevOps.

<h1>Python-based microservice and deploy it using Terraform to Azure.</h1>

<p>Create a GitHub Actions or Azure DevOps pipeline where a build cannot proceed unless it passes:</p>

Static Analysis: Linting and security scanning (using Bandit or SonarQube).

Contract Testing: Use Pact to ensure the API doesn't break for customers.

<p>Automated Quality Gate to query your testing results; if code coverage is < 90% or any high-severity bug is found, the pipeline auto-fails and alerts a Slack channel.</p>
