# Docker and Kubernetes Training Repository

This repository contains comprehensive training materials for Docker and Kubernetes, including theoretical explanations and hands-on labs.

## Table of Contents

### Docker Fundamentals
1. [Introduction to Docker](./docker/docker-intro.md) - Understanding containerization concepts and Docker's role in modern development
2. [Container vs Virtual Machines](./docker/container-vs-vm.md) - Comparing container technology with traditional virtualization
3. [Docker Architecture](./docker/docker-architecture.md) - Exploring Docker's internal components and communication model
4. [The Docker Hub](./docker/docker-hub.md) - Learning to use Docker's public registry for images
5. [Docker Installation](./docker/docker-installation.md) - Installing Docker engine on various operating systems

### Docker Operations
6. [Creating First Image](./docker/creating-first-image.md) - Building your first Docker image from a base image
7. [Working with Multiple Images](./docker/working-with-images.md) - Managing multiple Docker images effectively
8. [Packaging Customized Container](./docker/packaging-customized-container.md) - Creating custom container configurations
9. [Running Container Commands](./docker/running-container-commands.md) - Executing commands within running containers
10. [Container Port Redirect](./docker/container-port-redirect.md) - Managing container networking with port mapping
11. [Container Snapshots](./docker/container-snapshots.md) - Saving container states as new images
12. [Attach to a Running Container](./docker/attach-to-running-container.md) - Interacting with active container processes

### Docker Management
13. [Removing Images](./docker/removing-images.md) - Clean up unused Docker images to save space
14. [Understand Directory Structure](./docker/directory-structure.md) - Exploring how Docker manages files and directories
15. [Services - on Startup](./docker/services-on-startup.md) - Managing container services that run automatically
16. [Dockerfile](./docker/dockerfile.md) - Writing configurations that drive automated image builds
17. [Pushing Images to Docker Hub](./docker/pushing-images.md) - Sharing your Docker images with others
18. [Adding External Content](./docker/adding-external-content.md) - Including files outside the build context in containers
19. [Image Volume Management](./docker/image-volume-management.md) - Managing data persistence with volumes
20. [Creating Docker Registry (Private)](./docker/private-registry.md) - Setting up private Docker repositories

### Docker Swarm & Advanced Features
21. [Docker Swarm Overview](./docker/docker-swarm-overview.md) - Orchestrating containers with Docker Swarm
22. [Docker Resource Management and Networking](./docker/resource-management-networking.md) - Optimizing container performance and connectivity
23. [Docker Troubleshooting](./docker/troubleshooting.md) - Diagnosing and fixing common Docker issues
24. [Advanced Docker Networking](./docker/advanced-networking.md) - Building complex network topologies
25. [Docker Logging](./docker/logging.md) - Capturing and analyzing container output
26. [Docker Compose](./docker/docker-compose.md) - Managing multi-container applications
27. [Configuring compose](./docker/configuring-compose.md) - Fine-tuning Docker Compose configurations
28. [PHP Application with MySQL](./docker/php-mysql-application.md) - Building web applications with Docker Compose
29. [Building a Cluster](./docker/building-cluster.md) - Creating multi-container cluster architectures
30. [Launch Strategy](./docker/launch-strategy.md) - Designing robust deployment strategies
31. [Docker Compose & Swarm Together](./docker/compose-swarm-together.md) - Combining orchestration tools
32. [Docker Cloud (Introduction)](./docker/docker-cloud.md) - Cloud-native Docker deployment concepts

### Kubernetes Fundamentals
33. [Kubernetes Introduction](./kubernetes/kubernetes-intro.md) - Getting started with Kubernetes orchestration
34. [Understanding API Primitives](./kubernetes/api-primitives.md) - Core Kubernetes objects and their relationships
35. [Kubernetes Cluster Architecture](./kubernetes/cluster-architecture.md) - Understanding the high-level Kubernetes components
36. [Services and Network Primitives](./kubernetes/services-networking.md) - Setting up networking between applications in Kubernetes

### Kubernetes Operations
37. [Installing Masters and Nodes](./kubernetes/installing-master-node.md) - Setting up a basic Kubernetes cluster
38. [Secure Cluster Communications](./kubernetes/secure-communications.md) - Securing Kubernetes internals
39. [Highly-Available Cluster](./kubernetes/high-availability.md) - Building fault-tolerant Kubernetes deployments
40. [Release Binaries](./kubernetes/release-binaries.md) - Working with Kubernetes distribution releases
41. [Infrastructure Provisioning](./kubernetes/infrastructure-provisioning.md) - Setting up the underlying hardware/cloud
42. [Network Solutions](./kubernetes/network-solutions.md) - Choosing and implementing network policies
43. [Infrastructure Configuration](./kubernetes/infrastructure-config.md) - Customizing cluster parameters
44. [End-to-End Tests](./kubernetes/end-to-end-tests.md) - Validating Kubernetes cluster functionality
45. [Deployment and Scaling](./kubernetes/deployment-scaling.md) - Managing application deployments and growth
46. [Rolling Updates and Rollbacks](./kubernetes/rolling-updates-rollbacks.md) - Updating applications smoothly without downtime

### Advanced Kubernetes Concepts
47. [Application Configuration](./kubernetes/application-config.md) - Managing application settings and secrets
48. [Scaling Applications](./kubernetes/scaling-applications.md) - Automatically growing workloads
49. [Self-Healing Applications](./kubernetes/self-healing.md) - Built-in fault tolerance mechanisms
50. [Label Selectors and DaemonSets](./kubernetes/label-selectors-daemonsets.md) - Organizing and targeting workloads
51. [Resource Limits and Scheduling](./kubernetes/resource-limits-scheduling.md) - Optimizing resource allocation and scheduling
52. [Scheduler Configuration](./kubernetes/scheduler-config.md) - Customizing container placement logic
53. [Network Concepts](./kubernetes/network-concepts.md) - Understanding Kubernetes networking layers
54. [Pod Networking](./kubernetes/pod-networking.md) - Connecting containers within pods
55. [Service Networking](./kubernetes/service-networking.md) - Exposing applications within clusters
56. [Network Load Balancer](./kubernetes/load-balancer.md) - Distributing traffic to applications
57. [Ingress Rules](./kubernetes/ingress-rules.md) - Managing external access to cluster services
58. [Cluster DNS](./kubernetes/cluster-dns.md) - Service discovery within the cluster
59. [CNI (flannel and calico)](./kubernetes/cni-flannel-calico.md) - Container Network Interface implementations

### Storage in Kubernetes
60. [Helm Charts - Overview](./kubernetes/helm-charts.md) - Package management for Kubernetes
61. [Persistent Volumes](./kubernetes/persistent-volumes.md) - Managing long-term data in containers
62. [Volume Access Modes](./kubernetes/volume-access-modes.md) - Defining how volumes can be accessed
63. [Persistent Volume Claims](./kubernetes/persistent-volume-claims.md) - Requesting storage resources
64. [Kubernetes Storage Objects](./kubernetes/storage-objects.md) - Different types of storage in Kubernetes

### Security in Kubernetes
65. [Authentication and Authorization](./kubernetes/authentication-authorization.md) - Controlling access to Kubernetes resources
66. [Security Primitives](./kubernetes/security-primitives.md) - Fundamental security mechanisms
67. [Secure Image Handling](./kubernetes/secure-images.md) - Managing container image security
68. [Security Contexts](./kubernetes/security-contexts.md) - Controlling container privileges
69. [Persistent Key Value Store](./kubernetes/key-value-store.md) - Secure secret management
70. [Role-Based Access Control](./kubernetes/rbac.md) - Fine-grained permission management
71. [Monitoring Cluster Components](./kubernetes/monitoring-components.md) - Observing system health
72. [Application Monitoring](./kubernetes/application-monitoring.md) - Tracking application performance

### Advanced Kubernetes Topics
73. [Ollama Model Deployment](./kubernetes/ollama-deployment.md) - Deploying AI models in Kubernetes