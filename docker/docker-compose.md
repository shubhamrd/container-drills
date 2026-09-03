# Docker Compose

## Real World Analogy
Docker Compose is like having a detailed construction blueprint that specifies how to build an entire building with many interconnected systems all at once.

Think of it like:
- **House Blueprint**: Like having detailed plans showing where every room, electrical outlet, and pipe should go
- **Assembly Instructions**: Like step-by-step directions for putting together a complex piece of furniture
- **Integrated System Design**: Like planning how all mechanical, electrical, and plumbing systems work together
- **Single Point of Control**: Like having one master plan you consult to understand how everything fits
- **Scalable Construction**: Like being able to reproduce the same complex building in multiple locations

In construction:
1. **Coordination Plan**: Ensures all systems work together rather than separately  
2. **Standardized Process**: Everyone follows the same blueprint and specifications
3. **Modular Approach**: Complex building broken down into manageable sections
4. **Quality Control**: Each component is built to precise specifications from one document
5. **Efficient Build Process**: No rework from missing or conflicting instructions

## Technical Explanation
Docker Compose provides a way to define and run multi-container Docker applications using a YAML file called `docker-compose.yml`. It allows you to:
- Define services that make up your application
- Configure networks between services
- Define volume mounts for data persistence
- Set environment variables and configuration
- Specify service dependencies and startup order
- Manage entire applications with a single command

Compose solves complex multi-container problems by:
- Managing interdependent containers as one application
- Handling network configuration automatically
- Preserving data through volumes
- Providing consistent deployment environments
- Supporting multi-environment configurations

## Lab Exercise: Docker Compose Implementation
In this lab, you'll set up and manage a multi-container application using Docker Compose.

### Lab Steps
1. **Create a sample application directory**
   ```bash
   mkdir docker-compose-lab
   cd docker-compose-lab
   ```

2. **Create a docker-compose.yml file for a simple web application**
   ```yaml
   version: '3.8'
   services:
     web:
       image: nginx:latest
       ports:
         - "8080:80"
       volumes:
         - ./html:/usr/share/nginx/html
       depends_on:
         - app
         
     app:
       image: node:16-alpine
       working_dir: /app
       volumes:
         - ./app:/app
       command: sh -c "npm install && npm start"
       ports:
         - "3000:3000"
   ```

3. **Create supporting directories and files**
   ```bash
   # Create HTML directory and index file
   mkdir -p html app
   
   # Create simple HTML page
   cat > html/index.html << 'EOF'
   <!DOCTYPE html>
   <html>
   <head>
       <title>Docker Compose Demo</title>
   </head>
   <body>
       <h1>Hello from Docker Compose!</h1>
       <p>This site is running in containers managed by Docker Compose.</p>
   </body>
   </html>
   EOF
   
   # Create Node.js application file
   cat > app/server.js << 'EOF'
   const express = require('express');
   const app = express();
   const port = 3000;
   
   app.get('/', (req, res) => {
     res.send('Hello from Node.js app!');
   });
   
   app.listen(port, () => {
     console.log(`Node.js app listening at http://localhost:${port}`);
   });
   EOF
   
   # Create package.json
   cat > app/package.json << 'EOF'
   {
     "name": "docker-compose-demo",
     "version": "1.0.0",
     "main": "server.js",
     "dependencies": {
       "express": "^4.18.0"
     }
   }
   EOF
   ```

4. **Start the application**
   ```bash
   docker-compose up -d
   ```

5. **View the running services**
   ```bash
   docker-compose ps
   ```

6. **Check service logs**
   ```bash
   docker-compose logs web
   docker-compose logs app
   ```

7. **Access the application**
   ```bash
   # Test web interface
   curl http://localhost:8080
   
   # Test API endpoint
   curl http://localhost:3000
   ```

8. **Scale services**
   ```bash
   docker-compose up -d --scale web=3
   ```

9. **View updated service status**
   ```bash
   docker-compose ps
   ```

10. **Stop and clean up**
    ```bash
    docker-compose down
    ```

11. **Clean up local files (optional)**
    ```bash
    cd ..
    rm -rf docker-compose-lab
    ```

This lab demonstrates the core principles and practical usage of Docker Compose for managing complex multi-container applications.