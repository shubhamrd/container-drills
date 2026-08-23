# Application Configuration

## Real World Analogy
Application configuration in Kubernetes is like setting up a restaurant menu and kitchen operations before opening.

Think of it like:
- **Menu Planning**: Like deciding what dishes to offer - this can change based on seasonality, customer demands, or chef preferences
- **Kitchen Setup**: Like arranging ingredients, utensils, and cooking equipment in the kitchen  
- **Recipe Cards**: Like documenting exact cooking instructions and ingredient quantities
- **Seasonal Adjustments**: Like changing menu items based on what's fresh and available
- **Staff Training**: Like ensuring kitchen staff understand new recipes and procedures

When you're preparing to open a restaurant:
1. **Initial Setup**: Plan your core menu items
2. **Preparation**: Acquire ingredients and setup kitchen processes
3. **Training**: Teach staff the new menu preparations 
4. **Testing**: Trial-run new dishes with staff
5. **Adaptation**: Adjust based on feedback or supply chain issues

## Technical Explanation
Application configuration in Kubernetes separates application code from configuration data, allowing for flexible deployment and management. This follows the principle of declaring what the application should look like externally (configuration) rather than hardcoding values in the application itself.

**Configuration Methods:**
- **ConfigMaps**: Store non-sensitive configuration data as key-value pairs
- **Secrets**: Store sensitive information like passwords and API keys
- **Environment Variables**: Pass configuration as environment variables to containers
- **Volume Mounts**: Mount configuration files as volumes in containers
- **Command Line Arguments**: Pass configuration as CLI arguments

**Best Practices:**
- **Separation of Concerns**: Keep configuration separate from application code
- **Parameterization**: Use variables that can be changed without rebuilding images
- **Security**: Protect sensitive data with Secrets rather than storing in ConfigMaps
- **Version Control**: Track configuration changes like code changes
- **Namespacing**: Organize configuration within namespaces for isolation

**Configuration Management:**
- **Immutability**: Once applied, configuration is generally immutable during pod lifetime
- **Reload Mechanism**: Some configurations require container restart to take effect
- **Validation**: Ensure configuration data meets required schema and constraints
- **Audit Trail**: Track configuration changes for debugging and compliance

## Lab Exercise: Managing Application Configuration
In this lab, you'll work with different configuration management methods.

### Lab Steps
1. **Create a ConfigMap with application settings**
   ```bash
   kubectl create configmap app-config --from-literal=environment=production --from-literal=log-level=info
   ```

2. **Create a Secret for sensitive data**
   ```bash
   kubectl create secret generic app-secret --from-literal=username=admin --from-literal=password=secret123
   ```

3. **Create a deployment using configuration**
   ```bash
   kubectl create deployment config-test --image=nginx --env-from=configmap/app-config --env-from=secret/app-secret
   ```

4. **View the configuration as environment variables**
   ```bash
   kubectl set env deployment/config-test --list
   ```

5. **Create configuration files for volume mounting (conceptual)**
   ```bash
   # Create a config file
   echo "database_url=postgresql://localhost:5432/mydb" > config.properties
   echo "app_version=1.2.3" >> config.properties
   ```

6. **Create a ConfigMap from a file**
   ```bash
   kubectl create configmap app-properties --from-file=config.properties
   ```

7. **View ConfigMap contents**
   ```bash
   kubectl get configmap app-properties -o yaml
   ```

8. **Create a pod with volume-mounted configuration**
   ```bash
   kubectl run config-pod --image=nginx --mounts=configMap/app-properties:/app/config
   ```

9. **Update configuration and verify**
   ```bash
   kubectl edit configmap app-config
   ```

10. **View updated config values**
    ```bash
    kubectl get configmap app-config -o yaml
    ```

11. **Delete test resources**
    ```bash
    kubectl delete deployment config-test pod config-pod
    kubectl delete configmap app-config app-properties
    kubectl delete secret app-secret
    ```

This lab teaches the fundamentals of Kubernetes configuration management, showing how to separate application settings from code while maintaining flexibility and security.