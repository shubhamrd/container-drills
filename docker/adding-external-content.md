# Adding External Content

## Real World Analogy
Adding external content to Docker containers is like importing files into a digital library from various sources.

Think of it like:
- **Book Collection Expansion**: Like adding new books to your personal library from different publishers
- **Research Data Integration**: Like incorporating data files from various studies and datasets
- **Multimedia Enrichment**: Like adding photos, videos, or audio files to enhance a presentation
- **Reference Material Import**: Like gathering and organizing reference documents for a project
- **Content Synchronization**: Like updating your library with the latest editions of your favorite series

In digital library management:
1. **Content Acquisition**: Getting materials from multiple sources
2. **Organization System**: Structuring imported content for easy access
3. **Format Compatibility**: Ensuring different file types work in your system
4. **Version Control**: Managing updates and changes to imported materials
5. **Integration Process**: Making sure new content works seamlessly with existing resources

## Technical Explanation
Adding external content to Docker containers involves copying files from the host system or external sources into container filesystems. This is essential for:
- Providing application configuration files
- Adding static assets (images, CSS, JavaScript)
- Including data files for processing
- Incorporating executable scripts
- Managing external dependencies

**Methods for Adding Content:**
- **COPY Instruction**: Copy files from build context into container
- **ADD Instruction**: Extended COPY with automatic decompression and remote URL handling
- **VOLUME Mounts**: Mount directories from host system into container
- **Bind Mounts**: Direct mapping between host and container filesystems
- **Git Submodules**: Adding code repositories as part of the container

**Best Practices:**
- **Build Context Management**: Keep build context minimal to reduce image size
- **File Permissions**: Ensure proper access permissions for copied files
- **Security**: Avoid copying sensitive information unnecessarily
- **Layer Optimization**: Place frequently changing files in later layers
- **Environment Specific**: Use multi-stage builds for different environments

## Lab Exercise: Adding Various Content Types
In this lab, you'll learn different methods for adding external content to containers.

### Lab Steps
1. **Create working directory with sample content**
   ```bash
   mkdir external-content-lab
   cd external-content-lab
   
   # Create various content types
   mkdir -p data config assets
   ```

2. **Create sample configuration files**
   ```bash
   # Create a configuration file
   cat > config/app.conf << 'EOF'
   DEBUG=false
   DATABASE_URL=sqlite:///app.db
   LOG_LEVEL=INFO
   API_KEY=secret-key-12345
   EOF
   
   # Create a JSON configuration
   cat > config/settings.json << 'EOF'
   {
     "app": {
       "name": "Sample App",
       "version": "1.0.0",
       "features": ["auth", "logging", "storage"]
     },
     "database": {
       "driver": "sqlite",
       "pool_size": 10
     }
   }
   EOF
   ```

3. **Create sample static content**
   ```bash
   # Create HTML file
   cat > assets/index.html << 'EOF'
   <!DOCTYPE html>
   <html>
   <head>
       <title>Sample App</title>
   </head>
   <body>
       <h1>Welcome to Sample App</h1>
       <p>This page is part of the external content demo.</p>
   </body>
   </html>
   EOF
   
   # Create CSS file
   cat > assets/style.css << 'EOF'
   body {
       font-family: Arial, sans-serif;
       margin: 20px;
       background-color: #f5f5f5;
   }
   
   h1 {
       color: #333;
   }
   EOF
   
   # Create log file
   echo "Application started at $(date)" > data/app.log
   ```

4. **Create Dockerfile with various COPY methods**
   ```bash
   cat > Dockerfile << 'EOF'
   FROM ubuntu:latest
   
   # Create working directory
   WORKDIR /app
   
   # Install necessary tools
   RUN apt-get update && apt-get install -y curl
   
   # Copy configuration files to container
   COPY config/ ./config/
   
   # Copy static assets to container
   COPY assets/ ./assets/
   
   # Copy data files
   COPY data/ ./data/
   
   # Create directory for runtime data
   RUN mkdir -p /app/runtime
   
   # Show what was copied
   RUN ls -la
   
   # Run a simple command to keep container alive
   CMD ["tail", "-f", "/dev/null"]
   EOF
   ```

5. **Build the container image**
   ```bash
   docker build -t external-content-demo .
   ```

6. **Run container to examine content**
   ```bash
   docker run -it --name content-test external-content-demo bash
   ```

7. **Inside container, verify content**
   ```bash
   # Inside the container:
   ls -la /app/
   ls -la /app/config/
   ls -la /app/assets/
   ls -la /app/data/
   cat /app/config/app.conf
   cat /app/assets/index.html
   ```

8. **Exit and inspect more thoroughly**
   ```bash
   exit
   ```

9. **Create Dockerfile with ADD command**
   ```bash
   cat > Dockerfile.add << 'EOF'
   FROM ubuntu:latest
   
   WORKDIR /app
   
   # ADD files (this also supports tar archives and remote URLs)
   ADD config/ ./config/
   ADD assets/ ./assets/
   
   # Add file from local host to container  
   ADD data/ ./data/
   
   CMD ["tail", "-f", "/dev/null"]
   EOF
   ```

10. **Test ADD command**
    ```bash
    docker build -f Dockerfile.add -t add-content-demo .
    docker run -it --name add-test add-content-demo bash
    
    # Inside container:
    ls -la /app/
    exit
    ```

11. **Create container with volume mounting**
    ```bash
    # Create an external directory that we'll mount
    mkdir external-mount-point
    
    # Create a sample document in mount point
    echo "This file is mounted from outside the container" > external-mount-point/external-doc.txt
    
    # Run container that mounts external directory
    docker run -d --name volume-test \
      -v $(pwd)/external-mount-point:/mounted-data \
      -v $(pwd)/config:/app/config \
      external-content-demo
    
    # Test mounted volume
    docker exec volume-test ls -la /mounted-data/
    ```

12. **Clean up test containers**
    ```bash
    docker stop content-test add-test volume-test
    docker rm content-test add-test volume-test
    docker rmi external-content-demo add-content-demo
    ```

This lab demonstrates multiple ways to incorporate external content into Docker containers, showing COPY, ADD, and volume mounting approaches.