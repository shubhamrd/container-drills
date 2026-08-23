# Services - on Startup

## Real World Analogy
Services-on-startup in Docker is like having a smart home automation system where appliances start automatically when power is restored.

Think of it like:
- **Morning Routine**: Like having coffee maker, toaster, and lights turn on automatically when you wake up
- **Power Restoration**: Like security systems activating when electricity comes back on after a blackout
- **Scheduled Tasks**: Like a calendar app that triggers actions at specific times  
- **System Initialization**: Like how a computer runs startup programs when booting up
- **Automated Maintenance**: Like having lawn mowers and cleaning robots start automatically based on schedule

In smart home automation:
1. **Automated Launch**: Things start without manual intervention
2. **Predefined Sequences**: Specific order of actions that happen together
3. **Reliability**: Systems start consistently when conditions are met
4. **Resource Management**: Optimizing when services start for efficiency
5. **Monitoring**: Knowing when systems are running or have been activated

## Technical Explanation
Services-on-startup in Docker refers to how containerized applications can be configured to run or initialize specific services when a container starts up. This is essential for:
- Preparing application environments
- Running initialization scripts
- Setting up database connections
- Starting background services
- Managing application dependencies

Key approaches to service startup:
- **Entrypoint Scripts**: Main startup script that initializes the container
- **Init Systems**: Lightweight init systems to manage multiple services
- **Supervisord**: Process supervisor for managing multiple processes
- **Health Checks**: Readiness probes to ensure services are fully initialized
- **Startup Hooks**: Custom code that runs during container initialization

Docker handles startup through:
- **ENTRYPOINT** and **CMD** instructions in Dockerfiles
- **Container lifecycle management**
- **Process management within containers**
- **Environment variable preparation**
- **Volume and network initialization**

## Lab Exercise: Configure Startup Services
In this lab, you'll create a container with multiple startup services.

### Lab Steps
1. **Create an initialization script**
   ```bash
   # Create a startup script in your working directory
   cat > startup.sh << 'EOF'
   #!/bin/bash
   echo "Starting container initialization..."
   
   # Initialize environment variables
   export ENVIRONMENT="development"
   export STARTUP_TIME=$(date)
   
   # Log startup
   echo "[$STARTUP_TIME] Container started with environment: $ENVIRONMENT" >> /var/log/startup.log
   
   # Simulate service startup
   echo "Starting web service..."
   echo "Starting database service..."
   echo "Starting logging service..."
   
   # Keep container running
   tail -f /dev/null
   EOF
   
   chmod +x startup.sh
   ```

2. **Create a Dockerfile with startup**
   ```bash
   cat > Dockerfile << 'EOF'
   FROM ubuntu:latest
   
   # Install dependencies
   RUN apt-get update && apt-get install -y \
       curl \
       && rm -rf /var/lib/apt/lists/*
   
   # Copy startup script
   COPY startup.sh /usr/local/bin/startup.sh
   
   # Set permissions
   RUN chmod +x /usr/local/bin/startup.sh
   
   # Set working directory
   WORKDIR /app
   
   # Entry point that executes the startup script
   ENTRYPOINT ["/usr/local/bin/startup.sh"]
    
   # Default command (for interactive mode)
   CMD ["tail", "-f", "/dev/null"]
   EOF
   ```

3. **Build the container image**
   ```bash
   docker build -t startup-test .
   ```

4. **Run container to test startup**
   ```bash
   docker run -d --name startup-container startup-test
   ```

5. **Check startup logs**
   ```bash
   docker exec startup-container cat /var/log/startup.log
   ```

6. **Verify container is running**
   ```bash
   docker ps
   ```

7. **Test environment variables**
   ```bash
   docker exec startup-container env | grep ENVIRONMENT
   ```

8. **Create a more complex service startup**
   ```bash
   # Create service startup script
   cat > service-init.sh << 'EOF'
   #!/bin/bash
   
   echo "=== Service initialization started ==="
   
   # Create log directory
   mkdir -p /var/log/myapp
   
   # Set up configuration
   echo "Setting up application configuration..."
   echo "app.version=1.0" > /etc/myapp.conf
   
   # Start services
   echo "Starting database service..."
   echo "Starting web service..." 
   echo "Starting monitoring service..."
   
   # Create readiness indicator
   touch /var/run/app-ready
   
   echo "=== All services started successfully ==="
   
   # Keep container alive
   tail -f /dev/null
   EOF
   
   chmod +x service-init.sh
   ```

9. **Clean up test container**
   ```bash
   docker stop startup-container
   docker rm startup-container
   docker rmi startup-test
   ```

This lab shows how to properly orchestrate startup services in Docker containers, ensuring that applications and their dependencies are initialized correctly.