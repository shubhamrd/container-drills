# Resource Limits and Scheduling

## Real World Analogy
Resource limits and scheduling in Kubernetes is like managing a construction site with limited workers and materials.

Think of it like:
- **Worker Allocation**: Like assigning specific workers to specific jobs based on their skills and availability
- **Material Limits**: Like having a limited supply of materials (steel, concrete, wood) that must be allocated wisely  
- **Job Priority**: Like prioritizing critical construction tasks over less important ones
- **Capacity Planning**: Like calculating how many workers and materials are needed for a given project
- **Dynamic Adjustment**: Like adding more workers or supplies when projects grow unexpectedly

In construction management:
1. **Resource Inventory**: Knowing what tools and materials are available
2. **Assignment Matching**: Matching workers to jobs that match their expertise  
3. **Capacity Constraints**: Making sure each job has enough resources to complete
4. **Over-subscription Prevention**: Ensuring no projects run over capacity
5. **Adaptation to Changes**: Adjusting resource allocation when priorities change

## Technical Explanation
Resource limits and scheduling in Kubernetes involve managing computational resources (CPU, memory) to ensure efficient cluster utilization and predictable application performance.

**Resource Management:**
- **Requests**: Minimum resources guaranteed to a container (for scheduling decisions)
- **Limits**: Maximum resources a container can consume
- **Resource Types**: CPU cores, memory, storage, network bandwidth
- **Requests vs Limits**: Requests determine where pods can be scheduled; limits prevent resource exhaustion

**Scheduling Mechanisms:**
- **Scheduler**: Component that assigns pods to nodes based on resource availability and constraints
- **Node Affinity**: Guide scheduling to specific nodes based on labels
- **Taints and Tolerations**: Control which pods can be scheduled on specific nodes
- **Resource Quotas**: Limit resource consumption within namespaces

**Scheduling Factors:**
- **Available Capacity**: Resources left on target nodes
- **Resource Requests**: Required resources for pod scheduling
- **Node Constraints**: Specific requirements like hardware or location
- **Priority-based Scheduling**: High-priority workloads get resources first

## Lab Exercise: Resource Management and Scheduling
In this lab, you'll explore resource allocation and scheduling concepts.

### Lab Steps
1. **Create a deployment with resource requests and limits**
   ```bash
   kubectl create deployment resource-test --image=nginx 
   ```

2. **Set resource limits and requests**
   ```bash
   # This would be done via YAML file or using annotations
   # In practice, you'd create proper deployment with resource specs
   ```

3. **Check node resources available**
   ```bash
   kubectl describe nodes | grep -E "(CPU|Memory) Capacity"
   ```

4. **View current resource usage**
   ```bash
   kubectl top nodes
   # Requires metrics server to be installed
   ```

5. **Create a pod with specific resource requirements**
   ```bash
   # Conceptual - in real world you'd create YAML with:
   # resources:
   #   requests:
   #     memory: "64Mi"
   #     cpu: "250m"
   #   limits:
   #     memory: "128Mi"
   #     cpu: "500m"
   ```

6. **Check resource quota in default namespace**
   ```bash
   kubectl get quota
   ```

7. **Examine pod scheduling**
   ```bash
   kubectl get pods -o wide
   ```

8. **View scheduler events**
   ```bash
   kubectl get events --sort-by=.metadata.creationTimestamp
   ```

9. **Understand resource allocation logic**
   ```bash
   # Scheduler tries to balance:
   # - Resource availability
   # - Node constraints
   # - Affinity requirements
   # - Taints/tolerations
   ```

10. **Test resource constraint scenarios (conceptual)**
    ```bash
    # In a real test:
    # Create pods that request more resources than available
    # The scheduler would fail to place them
    ```

11. **View pod resource consumption (if available)**
    ```bash
    kubectl top pods
    # Requires metrics server
    ```

12. **Clean up (conceptual)**
    ```bash
    # kubectl delete deployment resource-test
    ```

This lab demonstrates the principles of Kubernetes resource management and scheduling, showing how compute resources are allocated and constrained for optimal cluster performance.