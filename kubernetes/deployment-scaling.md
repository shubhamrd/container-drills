# Deployment and Scaling

## Non-Technical Example
Deployment and scaling in Kubernetes is like managing a restaurant business and knowing when to expand or reduce operations.

Think of it like:
- **Menu Development (Deployment)**: Like selecting and perfecting your menu items before opening
- **Restaurant Staffing (Replicas)**: Like having the right number of employees to handle customer demand
- **Peak Hours (Auto-scaling)**: Like increasing staff during busy lunch and dinner times
- **Slow Periods (Downscaling)**: Like reducing staff during early morning or late evening
- **Business Expansion (Scale Up)**: Like opening new locations or adding new kitchen sections
- **Business Contraction (Scale Down)**: Like closing a location or reducing kitchen capacity
- **Demand Forecasting (Monitoring)**: Like predicting customer numbers based on time of day and season

When you have a successful restaurant, you start by:
1. Developing your menu and kitchen setup (deployment)
2. Hiring and training staff (initial replicas)
3. Growing staff with demand (scale up)
4. Reducing staff during slow periods (scale down)
5. Expanding kitchens for peak demand (horizontal scaling)

## Technical Description
Deployment and scaling in Kubernetes are fundamental operations that manage application availability and resource utilization. These processes are controlled through Kubernetes primitives and automated tools.

**Deployment Concepts:**
- **Deployments**: Declare desired state for pods and replicas
- **ReplicaSets**: Ensure a specified number of pod replicas are running
- **Rolling Updates**: Gradually replace old pods with new ones
- **Rollbacks**: Revert to previous deployment versions

**Scaling Mechanisms:**
- **Horizontal Scaling**: Adding more pods running the same application
- **Vertical Scaling**: Increasing resources (CPU, memory) for existing pods
- **Manual Scaling**: Operator-controlled scaling
- **Auto-scaling**: Automated scaling based on metrics like CPU usage or custom metrics

**Scaling Strategies:**
- **Simple Scaling**: Direct replica count adjustment
- **Advanced Scaling**: Using HPA (Horizontal Pod Autoscaler) with metrics
- **Blue-Green Deployment**: Zero-downtime deployments with dual environments
- **Canary Releases**: Gradual rollout to small subset of users

## Hands-On Lab: Deployment and Scaling Operations
In this lab, you'll practice deployment and scaling concepts.

### Lab Steps
1. **Create a deployment with initial replicas**
   ```bash
   kubectl create deployment nginx-deployment --image=nginx --replicas=3
   ```

2. **Check deployment status**
   ```bash
   kubectl get deployments
   kubectl get pods
   ```

3. **View deployment details**
   ```bash
   kubectl describe deployment nginx-deployment
   ```

4. **Scale deployment manually**
   ```bash
   kubectl scale deployment nginx-deployment --replicas=5
   ```

5. **Verify scaling worked**
   ```bash
   kubectl get pods
   ```

6. **Update deployment with a new image (rolling update)**
   ```bash
   kubectl set image deployment/nginx-deployment nginx=nginx:1.19
   ```

7. **Monitor rollout status**
   ```bash
   kubectl rollout status deployment/nginx-deployment
   ```

8. **Check rollout history**
   ```bash
   kubectl rollout history deployment/nginx-deployment
   ```

9. **Scale down deployment**
   ```bash
   kubectl scale deployment nginx-deployment --replicas=2
   ```

10. **Verify scaling**
    ```bash
    kubectl get pods
    ```

11. **Rollback to previous version**
    ```bash
    kubectl rollout undo deployment/nginx-deployment
    ```

12. **Create a service to expose the deployment**
    ```bash
    kubectl expose deployment nginx-deployment --port=80 --type=ClusterIP
    ```

13. **Check service information**
    ```bash
    kubectl get svc nginx-deployment
    ```

14. **Clean up**
    ```bash
    kubectl delete deployment nginx-deployment
    kubectl delete svc nginx-deployment
    ```

This lab demonstrates managing application lifecycle through deployments and scaling operations, showing how Kubernetes handles both manual adjustments and automated scaling scenarios.