# Kubernetes Cluster Architecture

## Non-Technical Example
Kubernetes cluster architecture is like understanding how a large hospital operates as a whole system.

Think of a hospital:
- **The CEO and management team** are like the Master/Control Plane components - they make decisions and coordinate operations
- **Individual departments (Emergency, Surgery, Cardiology)** are like the Worker Nodes - they perform specific functions
- **The hospital layout** is like the networking - how patients (data) flow between departments
- **Medical records system** is like etcd - stores all critical information about patient care
- **Communication network** is like the APIs and DNS - how departments communicate with each other
- **Security guards** are like authentication mechanisms - only authorized personnel can enter certain areas
- **Maintenance crew** are like controllers - they keep equipment running optimally

In a Kubernetes cluster, these components work together:
- **Master Node** (the CEO) manages everything, decides what goes where
- **Worker Nodes** (departments) run the actual workloads 
- **Networking** (communication system) connects everything
- **Storage** (records) keeps track of everything

## Technical Description
Kubernetes cluster architecture consists of two main types of nodes:

**Control Plane (Master) Nodes:**
- **API Server (kube-apiserver)**: The front end for the Kubernetes control plane
- **etcd**: Consistent and highly-available key-value store used for all cluster data
- **Scheduler (kube-scheduler)**: Component that schedules pods to nodes
- **Controller Manager (kube-controller-manager)**: Manages controllers that handle cluster state
- **Cloud Controller Manager (cloud-controller-manager)**: Interacts with cloud provider APIs

**Worker Nodes:**
- **kubelet**: Agent that runs on each node, ensuring containers are running in pods
- **kube-proxy**: Network proxy that maintains network rules on nodes
- **Container Runtime**: Software responsible for running containers (Docker, containerd, etc.)

The architecture is distributed, scalable, and designed for high availability where each component can be scaled independently.

## Hands-On Lab: Understanding Cluster Components
In this lab, you'll examine your Kubernetes cluster's architectural components.

### Lab Steps
1. **Check your cluster status**
   ```bash
   kubectl cluster-info
   ```
   This shows the API server address and other cluster information.

2. **List the nodes in your cluster**
   ```bash
   kubectl get nodes
   ```
   You'll see all worker nodes in your cluster.

3. **Examine the control plane components**
   ```bash
   kubectl get pods -n kube-system
   ```
   This shows system pods running in the kube-system namespace, including core components.

4. **Check the cluster version**
   ```bash
   kubectl version
   ```
   This displays both client and server versions.

5. **Get detailed node information**
   ```bash
   kubectl describe nodes
   ```
   This shows detailed information about your nodes including capacity, allocatable resources, and conditions.

6. **Check API server status**
   ```bash
   kubectl get componentstatuses
   ```
   This shows the status of all control plane components.

7. **Examine etcd information (if you have access)**
   ```bash
   kubectl get pods -n kube-system | grep etcd
   ```
   This identifies etcd pods if they're running in the cluster.

8. **List all namespaces**
   ```bash
   kubectl get namespaces
   ```
   This shows different organizational units in your cluster.

9. **View cluster resource usage (if metrics server is enabled)**
   ```bash
   kubectl top nodes
   ```
   This shows CPU and memory usage statistics (requires metrics-server addon).

This lab gives you hands-on experience understanding the different parts of a Kubernetes cluster architecture and how they relate to each other.