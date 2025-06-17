📝 Project Description
This project implements a production-grade, reusable DevSecOps Kubernetes platform on AWS EKS, designed with GitOps, secure CI/CD, policy enforcement, and progressive delivery in mind. The architecture leverages ArgoCD, Sealed Secrets, Trivy, Kyverno, Cosign, Velero, and more to ensure that application delivery is auditable, resilient, and secure.

While the platform supports any microservice-based application, it includes a test deployment of the my-vote app (vote, result, worker, redis) to validate functionality across CI/CD, policy, secrets, and monitoring layers.

🎯 Project Goals
Category Goals
GitOps ArgoCD-based GitOps bootstrap with multi-environment app-of-apps
CI/CD Security Integrate container scanning (Trivy, Gitleaks), SLSA, and signed artifacts
Secrets Governance End-to-end secure secret handling using IRSA and Sealed Secrets
Progressive Delivery Canary and BlueGreen rollouts for microservices via Argo Rollouts or Helm
Observability Prometheus, Grafana, Loki, Fluent Bit for metrics, logs, and alerting
Policy Enforcement Kyverno/Gatekeeper policies to enforce deployment security rules
Backup & Resilience Use Velero for backup and disaster recovery
RBAC & Access Control Fine-grained namespace and secret access using RBAC
Audit & Drift Detection Track configuration drift and audit Kubernetes and GitOps events🎯 Goal
Bootstrap a GitOps workflow using ArgoCD to declaratively manage the entire platform and application lifecycle, starting with the "App-of-Apps" pattern. You'll run this both locally on Minikube and later on EKS.

Phased Implementation Plan
Phase Title
0 Project Planning & Directory Scaffolding
1 Provision EKS Cluster with OIDC, CloudWatch, and Nodegroups (via eksctl)
2 Install ArgoCD and Bootstrap GitOps with App-of-Apps
Goal of the Phase
Bootstrap a GitOps workflow using ArgoCD to declaratively manage the entire platform and application lifecycle, starting with the "App-of-Apps" pattern. You'll run this both locally on Minikube and later on EKS.

Lessons & Skills to Learn
Area What You’ll Learn
GitOps Declarative app lifecycle management using ArgoCD
Kustomize + Helm Organizing workloads into environments (dev, prod)
ArgoCD Internals Sync policies, self-healing, automated deployment
Git Structure How to link Git files directly to cluster state
Drift Management Auto-reconciliation and preventing manual changes

❓ Problem(s) Solved
Problem How This Phase Solves It
Manual Deployments Replaces kubectl apply with Git-driven auto-sync
Hidden Drift Enables auto-healing and pruning of out-of-sync resources
App Sprawl Centrally manages services with a scalable structure
Onboarding Delays New services are onboarded by just adding Git manifests

🔁 Old Repositories Mapped
Feature Source Repo
ArgoCD install & app-of-apps k8s-gitops-progressive-deployment-stack
Service-level Argo apps Same repo, plus my-vote-full-stack-app-infrastructure-deployment
Triggers + auto sync configs container-security-automation
GitOps RBAC & drift policy secrets-governance-k8s

🧩 Phase 2 – Steps + Files
Step Description Files/Manifests Involved
2.1 Install ArgoCD controller and services bootstrap/argocd-install.yaml
2.2 (Optional) Add namespace file bootstrap/argocd-namespace.yaml
2.3 Expose ArgoCD UI (e.g., port-forward) N/A – CLI only
2.4 Create App-of-Apps manifest bootstrap/app-of-apps.yaml
2.5 Register individual Argo apps for each service, first, apps/vote-dev.yaml

2.6 – Build Kustomize/Helm overlay for vote-dev
Substep Description
🛡️ 2.6.1 Implement workloads/services/vote/base/kustomization.yaml pointing to base-chart
🛡️ 2.6.2 Implement workloads/services/vote/overlays/dev/kustomization.yaml
🛡️ 2.6.3 Implement workloads/services/vote/overlays/dev/values.yaml with image, replica, etc.
🛡️ 2.6.4 Make sure Chart.yaml exists under workloads/base-chart/

2.7 – Validate ArgoCD Sync for vote-dev
Substep Description
🛡️ 2.7.1 Confirm Application appears in ArgoCD UI
🛡️ 2.7.2 Ensure Sync status is Synced, Health is Healthy
🛡️ 2.7.3 Fix kustomization.yaml or Helm values if status is Unknown or OutOfSync

🛡️ 2.8 – (Optional) Add Kustomize overlay for app-of-apps
Substep Description
🛡️ 2.8.1 Create bootstrap/overlays/dev/kustomization.yaml if needed
🛡️ 2.8.2 Register app-of-apps.yaml as part of GitOps

🛡️ 2.10 – Re-verify GitOps Sync in ArgoCD (vote only)
Substep Description
🛡️ 2.10.1 Inspect ArgoCD UI or run argocd app get vote-dev
🛡️ 2.10.2 Confirm live manifests match what’s in Git

🛡️ 2.11 – (Optional) Implement Drift Detection + Prevention
Substep Description
🛡️ 2.11.1 Create Kyverno policy: policies/kyverno/block-manual-changes.yaml
🛡️ 2.11.2 Apply Kyverno/OPA to cluster via ArgoCD
🛡️ 2.11.3 Label Argo-managed resources with managed-by: argocd
🛡️ 2.11.4 Add selfHeal: true, prune: true in every ArgoCD Application

🛡️ 2.12 – Deploy vote-dev to EKS
Substep Description
🛡️ 2.12.1 Re-provision EKS using cluster/eksctl-cluster.yaml
🛡️ 2.12.2 Apply bootstrap/app-of-apps.yaml to EKS
🛡️ 2.12.3 ArgoCD pulls from Git and deploys vote-dev workload
🛡️ 2.12.4 Confirm health and connectivity in EKS via ArgoCD UI

🔍 📦 Observability for ArgoCD (Logging)
🛡️ 2.13 – Add ArgoCD Logging for Observability
Substep Description
🛡️ 2.13.1 Label all ArgoCD pods with log-collect=enabled
🛡️ 2.13.2 Deploy Fluent Bit/Promtail under observability/
🛡️ 2.13.3 Configure filters to forward logs from argocd-server, repo-server, etc.
🛡️ 2.13.4 Integrate with Loki or CloudWatch Logs
🛡️ 2.13.5 Build Grafana dashboards under observability/dashboards/ for Argo logs
🛡️ 2.13.6 Add ArgoCD log alerts to notifications/configmap.yaml (optional)

🔒 🔍 Production-Grade Drift Detection & Prevention
🛡️ 2.14 – Harden Drift Detection (beyond Kyverno)
Substep Description
2.14.1 Ensure all apps use automated.selfHeal=true and prune=true
🛡️ 2.14.2 Use argocd app diff in automation (optional CI step)
🛡️ 2.14.3 Enable ArgoCD notifications for drift events (OutOfSync, Pruned)
🛡️ 2.14.4 Optionally use OPA policies to enforce Git-only source of truth
🛡️ 2.14.5 Label everything with argocd.argoproj.io/instance=<app> for traceability

🔍 🛡️ Production-Grade Auditing
🛡️ 2.15 – Audit ArgoCD and K8s Activity
Substep Description
🛡️ 2.15.1 Enable Kubernetes API audit logs (EKS: use CloudWatch audit logging)
🛡️ 2.15.2 Create audit policy file: audit/k8s-audit-policy.yaml
🛡️ 2.15.3 Add ArgoCD audit log config in argocd-cm and sync via Git
🛡️ 2.15.4 Ship audit logs to a central store (CloudWatch, Loki, Elasticsearch)
🛡️ 2.15.5 Visualize audit logs using Grafana dashboards
🛡️ 2.15.6 Set alerts for sensitive actions like manual patching or kubectl edit

🛡️ 2.16. do steps 2.5-2.15 for each of the following:
apps/worker-dev.yaml
apps/result-dev.yaml
apps/redis-dev.yaml

3 Configure IAM Roles for IRSA & Deploy External-Secrets + External-DNS
4 Deploy Sealed Secrets Controller & Integrate GitOps Secret Management
5 Create Helm/Kustomize Workloads for vote, worker, result, redis
6 Deploy Workloads via ArgoCD in dev environment
7 Implement Progressive Delivery (Canary/BlueGreen) using Argo Rollouts or Helm hooks
8 Add Trivy & Gitleaks to CI/CD for Container Security Automation
9 Define and Enforce Policies (Kyverno / Gatekeeper constraints)
10 Integrate Monitoring: Prometheus, Grafana, Fluent Bit, and Loki
11 Configure ArgoCD Notifications + Drift Detection
12 Enable Backup with Velero (S3) and Disaster Recovery Testing
13 Implement Cosign & SLSA for Supply Chain Security
14 Finalize RBAC for dev1, dev2, and limit access to Sealed Secrets
15 Conduct Audit Logging Integration and Alerting for Anomalies
16 Validate with MyVote App as Demo Across CI/CD & Monitoring Layers
17 Final Documentation, Templates, and Reusability Guide for Other Teams
