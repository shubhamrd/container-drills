# Packaging Customized Container

## Real World Analogy
Packaging a customized container is like assembling a custom-built furniture kit. 

Just as you might take a basic wooden frame (base image) and add specific components like a drawer, shelves, or decorative elements to meet your exact needs, packaging a customized container involves:
1. Starting with a base "kit" (base image like Ubuntu or Nginx)
2. Installing specific tools or libraries (like drill bits, screws)
3. Adding your own unique modifications (custom configuration files, logos)
4. Finalizing it as a complete package ready to ship (building the image)
5. The finished package can then be delivered to customers (running containers)

Each customized package has a specific purpose, just like each assembly has a specific function. You can create many variations of different packages based on different requirements, but they all start from the same basic components.

## Technical Explanation
Packaging a customized container involves creating a Docker image that includes all the necessary components and configurations for a specific application. This process allows for:
- Customizing base operating systems with specific software and dependencies
- Bundling pre-configured applications with their runtime environments
- Including custom scripts, configuration files, and data
- Applying security hardening and compliance settings
- Optimization of image size and performance through layer management

Key aspects of custom container packaging:
- **Layer Optimization**: Minimizing image layers to reduce size and improve performance
- **Security Considerations**: Using minimal base images, running containers as non-root users
- **Configuration Management**: Including configuration files and environment variables
- **Application Bundling**: Packaging all necessary components together
- **Tagging Strategy**: Using meaningful tags for version control and deployment

The Dockerfile is the blueprint that defines how the container should be built, including the base image, installations, configurations, and run commands.

## Lab Exercise: Package a Custom Web Application Container
In this lab, you'll create a customized container for a simple web application.

### Lab Steps
1. **Create a working directory**
   ```bash
   mkdir custom-web-app
   cd custom-web-app
   ```

2. **Create a simple web application file**
   ```bash
   nano app.py
   ```
   
   Add the following content:
   ```python
   from flask import Flask
   
   app = Flask(__name__)
   
   @app.route('/')
   def hello():
       return '<h1>Hello from Custom Web App Container!</h1><p>This container was built specifically for our project.</p>'
   
   if __name__ == '__main__':
       app.run(host='0.0.0.0', port=5000)
   ```

3. **Create requirements file**
   ```bash
   nano requirements.txt
   ```
   
   Add:
   ```
   Flask==2.0.1
   ```

4. **Create Dockerfile for custom web app**
   ```bash
   nano Dockerfile
   ```
   
   Add:
   ```dockerfile
   FROM python:3.9-slim
   
   # Set working directory
   WORKDIR /app
   
   # Copy requirements and install dependencies
   COPY requirements.txt .
   RUN pip install --no-cache-dir -r requirements.txt
   
   # Copy application code
   COPY app.py .
   
   # Expose port
   EXPOSE 5000
   
   # Create non-root user for security
   RUN useradd --create-home --shell /bin/bash appuser
   USER appuser
   WORKDIR /home/appuser
   
   # Run the application
   CMD ["python", "/app/app.py"]
   ```

5. **Build the customized image**
   ```bash
   docker build -t my-custom-webapp:latest .
   ```

6. **Verify the image was built**
   ```bash
   docker images | grep my-custom-webapp
   ```

7. **Run the container**
   ```bash
   docker run -d --name custom-web-container -p 8080:5000 my-custom-webapp:latest
   ```

8. **Check if it's running**
   ```bash
   docker ps
   ```

9. **Access the application**
   - Visit http://localhost:8080 in your browser
   - You should see your custom web application running

10. **Get container logs**
    ```bash
    docker logs custom-web-container
    ```

11. **Inspect container**
    ```bash
    docker inspect custom-web-container
    ```

12. **Stop and remove container**
    ```bash
    docker stop custom-web-container
    docker rm custom-web-container
    ```

This lab demonstrates how to create a tailored container for a specific web application by combining a base Python image, custom code, dependencies, and security considerations.