# Rolling Updates and Rollbacks

## Non-Technical Example
Rolling updates and rollbacks in Kubernetes are like performing renovations on a building while keeping it occupied.

Think of it like:
- **Building Renovation**: Like renovating a building room by room, where tenants can continue using other rooms
- **Phased Construction**: Like building a new wing, starting with one section and gradually expanding
- **Minimize Disruption**: Like keeping the elevator operational while replacing just one floor's tiles
- **Rolling Back Improvements**: Like reverting a room renovation if it didn't work out as planned

In this scenario:
1. **Before Update**: The building operates normally with residents
2. **During Update**: Some rooms are renovated while others remain functional
3. **During Rollback**: If something went wrong, rooms revert to their previous state
4. **Completion**: The building operates with all new improvements

## Technical Description
Rolling updates and rollbacks are essential deployment strategies in Kubernetes that ensure applications remain available during upgrades and can recover from failed deployments.

**Rolling Update Process:**
1. **Gradual Replacement**: Old pods are replaced by new ones in batches
2. **Health Checks**: New pods must be healthy before removing old ones
3. **Configurable Parameters**: Control update speed and failure thresholds using:
   - MaxUnavailable: Maximum number of pods that can be unavailable
   - MaxSurge: Maximum number of pods that can be created over desired amount
4. **Lifecycle Management**: Ensures graceful shutdown and startup

**Rollback Capabilities:**
1. **Version History**: Kubernetes automatically keeps deployment revision history
2. **Immediate Recovery**: Quickly revert to a previously working version
3. **Selective Rollback**: Rollback to specific revisions if needed
4. **Status Monitoring**: Track rollback progress and success

**Advanced Options:**
- **Blue-Green Deployments**: Completely separate environments for testing
- **Canary Deployments**: Gradual release to subset of users
- **Strategy Selection**: Choose between RollingUpdate, Recreate, etc.
- **Health Probes**: Configurable readiness and liveness probes

## Hands-On Lab: Implementing Rolling Updates and Rollbacks
In this lab, you'll practice with rolling updates and rollback operations.

### Lab Steps  
1. **Create a deployment with initial configuration**
   ```bash
   kubectl create deployment app-deployment --image=nginx:1.18 --replicas=3
   ```

2. **Verify initial deployment**
   ```bash
   kubectl get deployments
   kubectl get pods
   ```

3. **Check deployment details and configuration**
   ```bash
   kubectl describe deployment app-deployment
   ```

4. **Perform a rolling update to a new version**
   ```bash
   kubectl set image deployment/app-deployment app-deployment=nginx:1.19
   ```

5. **Monitor the rolling update process**
   ```bash
   kubectl rollout status deployment/app-deployment
   kubectl get pods
   ```

6. **Check rollout history**
   ```bash
   kubectl rollout history deployment/app-deployment
   ```

7. **View detailed rollout information**
   ```bash
   kubectl rollout history deployment/app-deployment --revision=1
   ```

8. **Pause the rollout (if needed for testing)**
   ```bash
   kubectl rollout pause deployment/app-deployment
   ```

9. **Resume the rollout**
   ```bash
   kubectl rollout resume deployment/app-deployment
   ```

10. **Rollback to previous version**
    ```bash
    kubectl rollout undo deployment/app-deployment
    ```

11. **Rollback to a specific revision**
    ```bash
    kubectl rollout undo deployment/app-deployment --to-revision=1
    ```

12. **Check that rollback completed successfully**
    ```bash
    kubectl get pods
    kubectl describe deployment app-deployment
    ```

13. **Update to a different version for further testing**
    ```bash
    kubectl set image deployment/app-deployment app-deployment=nginx:1.20
    kubectl rollout status deployment/app-deployment
    ```

14. **Clean up resources**
    ```bash
    kubectl delete deployment app-deployment
    ```

This lab demonstrates the core concepts of Kubernetes rolling updates and rollback management, showing how to safely and effectively update applications with minimal disruption to users.