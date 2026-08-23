# Creating First Image

## Real World Analogy
Creating your first Docker image is like baking your own custom cake mix from scratch.

When you buy a cake mix from the store, it comes already packaged with all the ingredients in specific proportions (flour, sugar, eggs, etc.). But creating your own cake mix is like:
1. Gathering all the individual ingredients (flour, sugar, eggs, butter) 
2. Mixing them in the proper ratio to create your custom blend
3. Pouring the mixture into a special cake pan (Dockerfile)
4. Baking it in the oven (docker build command)
5. Once baked, you have a delicious, customizable cake (Docker image)

Just like your homemade cake mix can be used multiple times to bake cakes, your Docker image can be used to create countless identical containers - all perfectly shaped the way you designed when you "baked" the image.

## Technical Explanation
Creating a Docker image involves defining a Dockerfile that contains instructions for building an image. A Dockerfile is essentially a script that describes:
- Which base image to start with (FROM instruction)
- What files to copy into the image (COPY instruction)
- Which commands to run during image construction (RUN instruction)
- Which command to run when containers are started (CMD instruction)
- What port to expose (EXPOSE instruction)

The process of creating an image involves:
1. **Planning**: Decide what goes in your image and what you want to run
2. **Writing a Dockerfile**: Define the build instructions in a text file called Dockerfile
3. **Building the image**: Using `docker build` command to create the image from the Dockerfile
4. **Tagging**: Assigning a meaningful name and version to your image
5. **Testing**: Running a container from the image to verify it works

Images can be pushed to repositories like Docker Hub for sharing and storage, or kept locally for development purposes.

## Lab Exercise: Create Your First Custom Docker Image
In this lab, you'll build a simple custom image using a Dockerfile.

### Lab Steps
1. **Create a working directory for your project**
   ```bash
   mkdir my-first-image
   cd my-first-image
   ```

2. **Create a simple HTML file**
   ```bash
   nano index.html
   ```
   
   Add the following content:
   ```html
   <!DOCTYPE html>
   <html>
   <head>
       <title>My First Docker Image</title>
   </head>
   <body>
       <h1>Hello from my custom Docker image!</h1>
       <p>This image was built as part of my Docker training.</p>
   </body>
   </html>
   ```
   
   Save and exit (Ctrl+X, then Y, then Enter)

3. **Create the Dockerfile**
   ```bash
   nano Dockerfile
   ```
   
   Add the following content:
   ```dockerfile
   FROM nginx:alpine
   COPY index.html /usr/share/nginx/html/index.html
   EXPOSE 80
   ```
   
   Save and exit
   
4. **Build your Docker image**
   ```bash
   docker build -t my-first-image:latest .
   ```
   This builds an image named `my-first-image` with tag `latest` from the current directory (.).
   
5. **Verify the image is built**
   ```bash
   docker images
   ```
   You should see your image listed with name `my-first-image` and tag `latest`.

6. **Run your custom image**
   ```bash
   docker run -d --name my-first-container -p 8080:80 my-first-image:latest
   ```

7. **Verify the container is running**
   ```bash
   docker ps
   ```

8. **Access your web page**
   - Visit http://localhost:8080 in your browser
   - You should see your custom HTML page instead of the default nginx page

9. **Stop and remove the container**
   ```bash
   docker stop my-first-container
   docker rm my-first-container
   ```

10. **Clean up (optional)** 
    ```bash
    docker rmi my-first-image:latest
    ```

This lab demonstrates the complete process of creating a custom Docker image from scratch, showing how Dockerfiles define the build process to create reproducible, portable environments.