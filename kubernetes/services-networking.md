# Services and Network Primitives

## Real World Analogy
Services and network primitives in Kubernetes are like the city's postal system and communication network.

Imagine:
- **Your house (pod)** is like a business that produces goods
- **The local post office (Service)** is like a communication hub that receives mail and forwards it to the correct destination
- **Street addresses (Pod IPs)** are like specific locations where products are actually produced
- **Mail carriers (Network Proxy)** deliver messages between different post offices
- **The city delivery system (Kubernetes networking)** ensures mail reaches the right place reliably

When you want to order something from a business:
1. You send your request to the *post office* (the Service)
2. The post office knows how to route your mail to the *actual business* (Pod)  
3. The *mail carrier* delivers your request to the correct physical location
4. When the business responds, it goes back through the *delivery system* to you

In Kubernetes:
- Services are like the postal network that provides consistent addresses to access applications
- Pods are like the actual businesses producing the work
- Networking primitives ensure reliable communication between these components

## Technical Explanation
Services in Kubernetes provide stable network endpoints (IP addresses and DNS names) for accessing pods. Services abstract the underlying dynamically allocated pod IPs through:
- **ClusterIP**: Exposes the service on a cluster-internal IP
- **NodePort**: Exposes the service on each node's IP at a static port
- **LoadBalancer**: Exposes the service externally using a cloud provider's load balancer
- **ExternalName**: Maps the service to an external name

Key networking concepts:
- **DNS in Kubernetes**: Services get DNS entries automatically
- **Network Policies**: Control pod-to-pod communication
- **Pod Networking**: How pods communicate within a node
- **Service Discovery**: How components find each other

The service abstraction is essential because pods are ephemeral - they can die and be recreated, getting new IPs in the process.

## Lab Exercise: Creating and Using Services
In this lab, you'll create and test different types of services.

### Lab Steps
1. **Create a simple pod**
   ```bash
   kubectl run nginx-app --image=nginx
   ```

2. **Expose the pod as a service**
   ```bash
   kubectl expose pod nginx-app --port=80 --target-port=80
   ```

3. **Check the service details**
   ```bash
   kubectl get svc nginx-app
   ```
   This shows the service details including cluster IP.

4. **Get more detailed service information**
   ```bash
   kubectl describe service nginx-app
   ```

5. **Check the DNS resolution**
   ```bash
   kubectl get svc nginx-app -o jsonpath='{.spec.clusterIP}'
   ```
   This extracts the cluster IP address of the service.

6. **Create a service with NodePort type**
   ```bash
   kubectl expose pod nginx-app --port=80 --target-port=80 --type=NodePort
   ```

7. **Check NodePort assignment**
   ```bash
   kubectl get svc nginx-app
   ```
   You'll see both ClusterIP and NodePort.

8. **Access through NodePort (from host machine)**
   - Find the assigned NodePort from the output above
   - Visit http://<node-ip>:<node-port> in your browser

9. **Create a service with LoadBalancer type (if supported)**
   ```bash
   kubectl expose pod nginx-app --port=80 --target-port=80 --type=LoadBalancer
   ```

10. **Test service communication using a test pod**
    ```bash
    kubectl run test-pod --image=busybox --rm -it --restart=Never -- sh
    ```
    
    Inside the pod, test DNS resolution:
    ```bash
    nslookup nginx-app
    wget -qO- http://nginx-app
    ```

11. **Clean up**
    ```bash
    kubectl delete svc nginx-app
    kubectl delete pod nginx-app
    ```

This lab demonstrates the fundamental concept of Kubernetes services and shows how they provide stable endpoints for accessing applications.