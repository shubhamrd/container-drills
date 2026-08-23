# Working with Multiple Images

## Real World Analogy
Working with multiple Docker images is like managing a collection of recipe books in your kitchen. 

Each recipe book (image) has its own unique set of ingredients and cooking instructions (dependencies). When you need to make different dishes (applications):
1. You might have a "Pizza Recipe Book" (nginx image)
2. You might have a "Cake Recipe Book" (nodejs image) 
3. You might have a "Soup Recipe Book" (python image)

You don't need to buy all the ingredients for all recipes at once - you only bring out the books (pull the images) when you need to cook a specific dish (run a container). And if you decide to add a new recipe, you can add a new "recipe book" (pull a new image) to your collection.

Additionally, you can:
- Share recipe books with friends (push images to registry)
- Swap one recipe book for another ("docker tag" to rename) 
- Archive old recipe books you rarely use (remove unused images)
- Update existing recipe books (get newer editions)

## Technical Explanation
Docker allows you to work with multiple images by storing them locally in the Docker daemon's image store. Each image is identified by a unique image ID and one or more tags. Multiple tags can refer to the same image, and images can be organized by repository names.

Key concepts in managing multiple images:
- **Image Repository**: The name of the image (like nginx, node, ubuntu)
- **Image Tag**: Version specification (like latest, alpine, v1.0)
- **Image ID**: Unique 64-character hexadecimal identifier
- **Layers**: Images are built from multiple read-only layers that are cached for efficiency
- **Image Sizes**: Different images have different sizes based on their contents and dependencies

Effective image management practices include:
- Regular cleanup of unused images
- Using appropriate tags for version control
- Pulling specific image versions for reproducible builds
- Tagging images for clarity and organization

## Lab Exercise: Manage Multiple Docker Images
In this lab, you'll create a scenario to work with multiple images effectively.

### Lab Steps
1. **Pull multiple different images**
   ```bash
   docker pull nginx
   docker pull node:alpine
   docker pull python:3.9-slim
   docker pull redis
   ```

2. **List all pulled images**
   ```bash
   docker images
   ```
   You'll see multiple images with their repository names, tags, image IDs, and sizes.

3. **Inspect a specific image**
   ```bash
   docker inspect nginx
   ```
   This shows detailed information about the nginx image including its layers, configuration, and mount points.

4. **Tag an image with a different name or version**
   ```bash
   docker tag nginx my-nginx:latest
   ```
   This creates a new tag pointing to the same image.

5. **Verify the new tag**
   ```bash
   docker images | grep nginx
   ```
   You should see the nginx image with both the original and new tag.

6. **Run containers from different images**
   ```bash
   docker run -d --name web-server -p 8080:80 nginx
   docker run -d --name node-app -p 8081:3000 node:alpine
   docker run -d --name redis-db -p 6379:6379 redis
   ```

7. **Check running containers**
   ```bash
   docker ps
   ```
   You should see all three containers running.

8. **View container details**
   ```bash
   docker ps -a
   ```
   This shows all containers that have ever run.

9. **Stop and remove containers**
   ```bash
   docker stop web-server node-app redis-db
   docker rm web-server node-app redis-db
   ```

10. **View images again**
    ```bash
    docker images
    ```
    All images remain, but no containers are running.

11. **Remove specific images**
    ```bash
    docker rmi my-nginx:latest
    ```
    This removes the tagged version, but leaves the original nginx image.

12. **Clean up all containers and images (optional)**
    ```bash
    docker container prune
    docker image prune -a
    ```
    These commands remove all stopped containers and unused images respectively.

This lab demonstrates the practical management of multiple Docker images, showing how to pull, inspect, tag, run, and remove different images efficiently.