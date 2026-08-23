# Service Networking

## Non-Technical Example
Service networking in Kubernetes is like having a contact center that acts as the official phone number for a business.

Think of it like:
- **Main Phone Number**: Like the service's official phone number that customers always call
- **Call Routing**: Like the contact center operator directing calls to the right department
- **Consistent Identifier**: Like having the same phone number whether a customer calls in the morning or evening
- **Flexible Department Allocation**: Like a call center that can redirect calls to different agents as needed
- **Backup Systems**: Like having multiple operators so if one is busy, calls are routed elsewhere

In a business setting:
1. **Customers Dial One Number**: Everyone calls the same main number
2. **Operator Handles Routing**: The phone operator knows which department to send callers to
3. **Department Location Changes**: The business can move departments but keep the same number
4. **Availability Management**: The contact center can handle fluctuations in call volume
5. **Reliability**: Even if the main operators are unavailable, backup systems keep calls flowing

## Technical Description
Service networking in Kubernetes provides stable network endpoints for accessing applications, abstracting away the dynamic nature of individual pods. Services are the primary mechanism for exposing applications within and outside the cluster.

**Service Types:**
- **ClusterIP**: Internal service accessible only within the cluster
- **NodePort**: Exposes service on each node's IP at a static port  
- **LoadBalancer**: Exposes service externally using cloud provider's load balancer
- **ExternalName**: Maps service to an external DNS name

**Service Architecture:**
- **Endpoints**: Dynamic list of pod IPs that match service selector
- **Virtual IPs**: Stable IP addresses assigned to services
- **Service Discovery**: DNS-based naming resolution
- **Load Balancing**: Distribution of traffic across endpoints
- **Port Mapping**: Translation between service ports and pod ports

**Implementation Details:**
- **Service Creation**: Kubernetes assigns a cluster IP to a service object
- **Endpoint Management**: Automatically managed by controller
- **Packet Forwarding**: Uses iptables or kube-proxy for traffic routing
- **Health Checks**: Determining which endpoints are ready to receive traffic
- **Selector Matching**: Finding pods that match the service's label selector

## Hands-On Lab: Service Networking Implementation
In this lab, you'll implement and test various service networking approaches.

### Lab Steps
1. **Create a deployment to expose**
   ```bash
   kubectl create deployment service-test --image=nginx --replicas=3
   ```

2. **Create a ClusterIP service**
   ```bash
   kubectl expose deployment service-test --port=80 --target-port=80 --type=ClusterIP
   ```

3. **Check service details**
   ```bash
   kubectl get svc service-test
   kubectl describe svc service-test
   ```

4. **View service endpoints**
   ```bash
   kubectl get endpoints service-test
   ```

5. **Check service DNS entry**
   ```bash
   kubectl run test-pod --image=busybox --rm -it --restart=Never -- sh
   # Inside pod:
   # nslookup service-test
   # wget -qO- http://service-test
   ```

6. **Create a NodePort service**
   ```bash
   kubectl expose deployment service-test --port=80 --target-port=80 --type=NodePort
   ```

7. **Check NodePort assignment**
   ```bash
   kubectl get svc service-test
   ```

8. **Test service access from host (conceptual)**
   ```bash
   # If running on a node, you'd access via:
   # curl http://<node-ip>:<NodePort>
   ```

9. **Delete and recreate with LoadBalancer**
   ```bash
   kubectl delete svc service-test
   # Note: LoadBalancer requires cloud provider
   # kubectl expose deployment service-test --port=80 --target-port=80 --type=LoadBalancer
   ```

10. **Check service configuration**
    ```bash
    kubectl get svc service-test -o yaml
    ```

11. **Test service discovery within cluster**
    ```bash
    # Create another pod and test DNS:
    kubectl run dns-test --image=busybox --rm -it --restart=Never -- nslookup service-test
    ```

12. **View service networking statistics**
    ```bash
    kubectl get svc service-test -o wide
    ```

13. **Clean up**
    ```bash
    kubectl delete deployment service-test
    kubectl delete svc service-test
    kubectl delete pod dns-test
    ```

This lab demonstrates the implementation and operation of different service networking types, showing how services provide stable access patterns to applications.