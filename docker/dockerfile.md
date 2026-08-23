# Dockerfile

## Non-Technical Example
A Dockerfile is like a cookbook recipe that anyone can follow to create the exact same dish.

Think of it like:
- **Recipe Card**: Like having a printed recipe with ingredients and instructions
- **Assembly Instructions**: Like directions for putting together a piece of furniture
- **Blueprint**: Like architectural plans that engineers use to build the same structure
- **Cooking Guide**: Like step-by-step instructions that ensure consistent results
- **Quality Control Document**: Like standardized procedures for pharmaceutical manufacturing

In cooking:
1. **Ingredient List**: Exact quantities and types of ingredients needed
2. **Step-by-Step Directions**: Precise order of cooking procedures
3. **Timing Guidelines**: When to add ingredients or check progress
4. **Quality Standards**: Ensuring each dish meets the same taste and texture expectations
5. **Reuse Protocol**: Same recipe can be followed by anyone to get identical results

## Technical Description
A Dockerfile is a text file that contains a series of instructions telling Docker how to build an image. It's the blueprint for creating container images and ensures reproducibility and consistency across different environments.

**Key Dockerfile Instructions:**
- **FROM**: Base image to start with
- **RUN**: Execute commands during image build
- **COPY/ADD**: Copy files from host to container
- **WORKDIR**: Set the working directory
- **ENV**: Set environment variables
- **EXPOSE**: Document ports to be published
- **ENTRYPOINT/CMD**: Define the default command to run
- **VOLUME**: Create volume mount points
- **USER**: Switch to a specific user
- **LABEL**: Add metadata to image

Best practices for Dockerfile creation:
- **Multi-stage Builds**: Reduce final image size
- **Layer Caching**: Optimize build performance
- **Security**: Avoid privileged containers, use non-root users
- **Minimalism**: Keep images small and focused
- **Reproducibility**: Consistent builds across environments

## Hands-On Lab: Create and Build a Custom Dockerfile
In this lab, you'll create and test different types of Dockerfiles.

### Lab Steps
1. **Create a working directory for the lab**
   ```bash
   mkdir dockerfile-lab
   cd dockerfile-lab
   ```

2. **Create a simple Python web application**
   ```bash
   # Create a simple web app
   cat > app.py << 'EOF'
   from flask import Flask
   
   app = Flask(__name__)
   
   @app.route('/')
   def hello():
       return 'Hello from Dockerfile lab!'
   
   if __name__ == '__main__':
       app.run(host='0.0.0.0', port=5000)
   EOF
   ```

3. **Create requirements file**
   ```bash
   cat > requirements.txt << 'EOF'
   Flask==2.0.1
   EOF
   ```

4. **Create a basic Dockerfile**
   ```bash
   cat > Dockerfile.basic << 'EOF'
   # Use Python base image
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
   
   # Set environment variables
   ENV FLASK_APP=app.py
   
   # Run the application
   CMD ["python", "app.py"]
   EOF
   ```

5. **Build the basic image**
   ```bash
   docker build -f Dockerfile.basic -t web-app-basic .
   ```

6. **Run the basic container**
   ```bash
   docker run -d --name basic-app -p 8080:5000 web-app-basic
   ```

7. **Test the basic web app**
   ```bash
   curl http://localhost:8080
   ```

8. **Create a multi-stage Dockerfile for optimization**
   ```bash
   cat > Dockerfile.multi << 'EOF'
   # Build stage
   FROM python:3.9-slim AS builder
   
   WORKDIR /app
   COPY requirements.txt .
   RUN pip install --no-cache-dir -r requirements.txt
   
   # Final stage
   FROM python:3.9-slim
   
   WORKDIR /app
   
   # Copy installed dependencies from builder stage
   COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
   COPY app.py .
   
   EXPOSE 5000
   ENV FLASK_APP=app.py
   CMD ["python", "app.py"]
   EOF
   ```

9. **Build the multi-stage image**
   ```bash
   docker build -f Dockerfile.multi -t web-app-optimized .
   ```

10. **Run the optimized container**
    ```bash
    docker run -d --name optimized-app -p 8081:5000 web-app-optimized
    ```

11. **Verify both images**
    ```bash
    docker images | grep web-app
    ```

12. **Test the optimized web app**
    ```bash
    curl http://localhost:8081
    ```

13. **Compare image sizes**
    ```bash
    docker images | grep web-app
    ```

14. **Clean up test containers**
    ```bash
    docker stop basic-app optimized-app
    docker rm basic-app optimized-app
    docker rmi web-app-basic web-app-optimized
    ```

This lab demonstrates creating and using Dockerfiles, showing both basic and optimized approaches for building container images from scratch.