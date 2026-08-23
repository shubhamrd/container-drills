# Understanding Kubernetes API Primitives

## Non-Technical Example
Understanding Kubernetes API primitives is like understanding the fundamental building blocks of a city's infrastructure.

In a city:
- **Houses** are like Pods - individual buildings where people live and work
- **Streets** are like Services - pathways that connect buildings but allow people to move between them 
- **City Blocks** are like Namespaces - defined areas that contain groups of related buildings
- **Traffic Signals** are like Controllers - they direct traffic flow and maintain order
- **Building Permits** are like Deployments - they control how new buildings (applications) are constructed and updated

Each building block serves a specific purpose, but they all work together in combination to make the entire city function as a cohesive unit. In Kubernetes, these primitives work similarly to create a robust, scalable, and manageable environment for applications.

## Technical Description
Kubernetes API primitives are the fundamental objects that define and control various aspects of a Kubernetes cluster. These are the building blocks that form the foundation of Kubernetes architecture and management:

**Core Primitives:**
- **Pods**: The smallest deployable units in Kubernetes representing one or more containers that share storage and network
- **Services**: Abstract way to expose applications running in pods to network traffic
- **Namespaces**: Logical partitions of a cluster to organize and isolate resources
- **Deployments**: Declares desired state for pods and replicas with rollout and rollback capabilities
- **ReplicaSets**: Ensures a specified number of pod replicas are running

**Advanced Primitives:**
- **DaemonSets**: Ensures a copy of a pod runs on each node
- **Jobs**: Run containers that execute to completion
- **CronJobs**: Schedule Jobs to run at specific times  
- **Ingress**: Controls external access to services in a cluster
- **PersistentVolumes**: Storage resources for pod consumption

These primitives are managed by Kubernetes controllers and communicate through the Kubernetes API server, which acts as the central point of control for all cluster operations.

## Hands-On Lab: Working with Core Kubernetes Primitives
In this lab, you'll experiment with the fundamental API primitives.

### Lab Steps
1. **Create a Namespace for isolation**
   ```bash
   kubectl create namespace demo-apps
   ```

2. **Create a simple Pod**
   ```bash
   kubectl run nginx-pod --image=nginx --namespace=demo-apps
   ```

3. **Check the Pod status**
   ```bash
   kubectl get pods -n demo-apps
   ```

4. **Create a Service for the Pod**
   ```bash
   kubectl expose pod nginx-pod --port=80 --target-port=80 --namespace=demo-apps
   ```

5. **Verify Service creation**
   ```bash
   kubectl get services -n demo-apps
   ```

6. **Create a Deployment instead of a single Pod**
   ```bash
   kubectl create deployment nginx-deployment --image=nginx --namespace=demo-apps
   ```

7. **Check Deployment status**
   ```bash
   kubectl get deployments -n demo-apps
   ```

8. **Examine the ReplicaSet created by Deployment**
   ```bash
   kubectl get replicasets -n demo-apps
   ```

9. **Examine detailed Pod information**
   ```bash
   kubectl describe pod nginx-pod -n demo-apps
   ```

10. **View the Deployment configuration**
    ```bash
    kubectl describe deployment nginx-deployment -n demo-apps
    ```

11. **Scale the Deployment**
    ```bash
    kubectl scale deployment nginx-deployment --replicas=3 -n demo-apps
    ```

12. **Verify scaling worked**
    ```bash
    kubectl get pods -n demo-apps
    ```

13. **Clean up**
    ```bash
    kubectl delete deployment nginx-deployment -n demo-apps
    kubectl delete pod nginx-pod -n demo-apps
    kubectl delete service nginx-pod -n demo-apps
    kubectl delete namespace demo-apps
    ```

This lab introduces you to the core Kubernetes objects and how they're related, showing how they work together to maintain application availability and management.