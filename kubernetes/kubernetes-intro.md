# Kubernetes Introduction

## Real World Analogy
Think of Kubernetes like a traffic controller for a busy city intersection. 

Just as a traffic controller manages multiple cars, pedestrians, and cyclists at an intersection, Kubernetes manages multiple applications (called workloads) running on many computers (nodes) in a cluster. 

The traffic controller has specific roles:
- **Dispatcher**: Decides which vehicle goes where
- **Scheduler**: Plans the optimal route for each vehicle based on traffic conditions 
- **Monitor**: Watches for accidents or problems and handles them appropriately
- **Controller**: Ensures vehicles follow traffic rules consistently

Similarly, Kubernetes orchestrates your applications by:
- **Scheduling**: Deciding which machines (nodes) should run your applications
- **Automatically restarting failed applications**
- **Scaling** applications up or down based on demand  
- **Managing updates without downtime**
- **Handling network communication** between applications

## Technical Explanation
Kubernetes (also known as K8s) is an open-source container orchestration platform designed to automate deployment, scaling, and management of containerized applications across clusters of hosts. 

The name Kubernetes comes from the Greek word for "helmsman" or "pilot," reflecting its role in steering complex containerized applications. It provides a robust framework for automating deployment, scaling, and operations of application containers across clusters of hosts.

Key Kubernetes concepts include:
- **Cluster**: A set of nodes (machines) running Kubernetes
- **Node**: A worker machine in a cluster that runs containers
- **Pod**: The smallest deployable unit in Kubernetes that contains one or more containers sharing storage and network
- **Service**: An abstraction that defines a logical set of pods and a policy to access them
- **Deployment**: A declaration of desired state for pods and replicas
- **Namespace**: A way to divide cluster resources between multiple users or projects

## Lab Exercise: Creating Your First Pod
In this lab, you'll deploy your first Kubernetes pod.

### Lab Steps
1. **Create a simple pod using kubectl run**
   ```bash
   kubectl run firstpod --image nginx
   ```
   This creates a pod named "firstpod" running the nginx web server image.

2. **Check pod status**
   ```bash
   kubectl get pods
   ```
   This shows all pods in the current namespace and their status. You should see your pod with status "Running."

3. **Get more detailed information**
   ```bash
   kubectl get pods -o wide
   ```
   This displays additional details including the node where the pod is running and IP addresses.

4. **Describe the pod for detailed information**
   ```bash
   kubectl describe pod firstpod
   ```
   This shows detailed information including events, configuration, and container information.

5. **View pod logs**
   ```bash
   kubectl logs firstpod
   ```
   This displays the standard output from the container.

6. **Execute commands inside the pod**
   ```bash
   kubectl exec -it firstpod -- bash
   ```
   This opens an interactive terminal session inside the pod. You can run commands like `ls` or `cat /etc/os-release` to explore the container environment.

7. **Exit the pod session**
   ```bash
   exit
   ```
   Returns you to your host machine.

8. **Clean up (optional)**
   ```bash
   kubectl delete pod firstpod
   ```
   Removes the pod from the cluster.

This lab demonstrates the basic Kubernetes workflow of deploying, inspecting, and interacting with containers.