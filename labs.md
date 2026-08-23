Docker Installation:
1. Update System
 
sudo yum -y remove docker*
This command updates the system to ensure you have the latest packages and dependencies.
 
2. Install Required Dependencies
sudo yum install -y yum-utils
Install necessary packages for Docker.
 
3. Add Docker Repository
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
This adds the Docker repository to your system.
 
4. Install Docker Engine
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
Install Docker Engine using the added repository.
 
5. Start and Enable Docker
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
Start and enable Docker to ensure it runs on system boot.
 
 
6. Verify Docker Installation
docker --version
Check the installed Docker version to confirm a successful installation.


Run hello world container
docker ps -a

docker run hello-world
docker ps
docker ps -a
get the container id
 
docker start <container-id>
docker ps -a
docker logs <container-id>
docker rm <container-id>
 
Remove all container
docker rm -f $(docker ps -qa)
 
Create a ubuntu container container.
1. Pull a Base Image:
Choose a base image from Docker Hub.
docker pull ubuntu
 
2. Run a Container:
Start a basic container without specifying a command.
docker run -itd --name ubuntu-container ubuntu
docker exec -it ubuntu-container bash
 
3. Explore the Container:
Once inside the container, you can explore its filesystem or execute commands.
ls
cat /etc/os-release
 
4. Exit the Container:
To exit the container, type exit.
exit
 
5. View Exited Containers:
Check the list of all containers, including the exited ones.
docker ps
 
6. stop and remove the container.
docker stop container-id
docker rm container-id

Remove Image
docker image rm <image-name/id> 
 
Create a centos container
1. Pull a Base Image:
Choose a base image from Docker Hub.
docker pull centos:8
 
2. Run a Container:
Start a basic container without specifying a command.
docker run -it centos:8
 
3. Explore the Container:
Once inside the container, you can explore its filesystem or execute commands.
ls
cat /etc/os-release
 
4. Exit the Container:
To exit the container, type exit.
exit
 
5. View Exited Containers:
Check the list of all containers, including the exited ones.
docker ps
docker ps -a
Copy container id
 
6. Start the stopped container
docker start container-id
docker ps
 
7. Connect to the container
docker exec -it container-id bash
exit
 
6. Remove Containers
Remove the container.
docker stop container-id
docker rm container-id

 
 
Practice: Hosting a Website with Apache HTTP Server Container
Objective:
To provide hands-on experience with Docker, hosting a website using the Apache HTTP Server container, modifying the website content inside the container, and utilizing port forwarding.
 
Practice Steps:
Step 1: Pull Apache HTTP Server Container
docker pull httpd:latest
 
Step 2: Run Apache HTTP Server Container
docker run -d -p 8080:80 --name my-apache-container httpd:latest
This command runs the Apache HTTP Server container in detached mode (-d), maps host port 8080 to container port 80 (-p 8080:80), and assigns a name to the container (--name my-apache-container).
Note: check the used port number “ss -tulpen”
Step 3: Verify the Running Container
docker ps
Ensure the Apache HTTP Server container is running.
check container ip
docker inspect my-apache-container | grep IPAddress
curl <container-ip>

Step 4: Access the Website
check ip adddress of node 1: ip ad | grep 192.168
Open a web browser and navigate to http://192.168.61.130:8080 to see the default Apache welcome page.
 
Step 5: Get Inside the Container
docker exec -it my-apache-container /bin/bash
Access the container's shell interactively (-it).
 
Step 6: Change Index.html Content
echo "Welcome to My Dockerized Website" > /usr/local/apache2/htdocs/index.html
Modify the content of the index.html file with a unique message.
 
Step 7: Exit the Container
exit
 
Step 8: Refresh the Website
Visit http://192.168.61.130:8080 in your web browser again to see the updated content.
 
Practice Task2:
1.	Host a container with image docker.io/pengbai/docker-supermario on external port 8090
docker run -d --name mario -p 8090:8080 docker.io/pengbai/docker-supermario
1.	Verify the running container on the browser
http://192.168.61.130:8090

 
MySQL Container
Create container
docker pull mysql
 docker run --name db1 -d -e MYSQL_ROOT_PASSWORD=password123 -e MYSQL_DATABASE=blankdb -e MYSQL_USER=<your-name> -e MYSQL_PASSWORD=<your-password> mysql
 
Verify the container is running
docker ps -a
 
Verify container logs
docker logs db1
 
connect to db option1
docker exec -it db1 bash
bash# mysql -u root -ppassword123
> show databases;
> exit
bash# exit
 
connect to db option2
docker exec -it db1 mysql -u root -ppassword123
> exit
docker exec -it db1 mysql -u shubham -pshubham123
> exit
stop mysql container
remove mysql container
1.	Host mysql continer.
docker run --name db1 -d -e MYSQL_ROOT_PASSWORD=password123 -e MYSQL_DATABASE=blankdb -e MYSQL_USER=shubham -e MYSQL_PASSWORD=shubham123 mysql
2.	Grab mysql details
1.	username : shubham
2.	password : shubham123
3.	ip addrees: 172.17.0.7 (get the ip from docker inspect command)
4.	database name: blankdb  (match with your databse name used while creation of mysql container MYSQL_DATABASE=””)

3.	host wordpress container and Provide mysql connetions parameters
docker run --name wp1 -d -e WORDPRESS_DB_HOST=172.17.0.7 -e WORDPRESS_DB_USER=shubham -e WORDPRESS_DB_PASSWORD=shubham123  -e WORDPRESS_DB_NAME=blankdb -p 8095:80 wordpress
 

 
Day 2
Host Machine Setup
●	mkdir /mnt/share
○	Description: Attempts to create a new directory named share inside the /mnt directory.
○	Note: This command will likely fail with a "Permission denied" error because standard users usually don't have the rights to modify the /mnt directory.
●	sudo mkdir /mnt/share
○	Description: Re-runs the previous command with "Superuser DO" (sudo), granting administrative privileges to successfully create the /mnt/share directory.
●	cd /mnt/share/
○	Description: Changes your current working directory into the newly created /mnt/share folder.
●	sudo touch app.config app.data app.logs
○	Description: Creates three empty files (app.config, app.data, and app.logs) inside the folder. sudo is used here because the parent directory was created by the root user in the previous step.
●	ls
○	Description: Lists the contents of your current directory to verify that the three files were created.
●	cd
○	Description: Changes your directory back to your user's default home directory (e.g., /home/username).
Docker Container Setup
●	docker run --name app1 -itd -v /mnt/share:/data ubuntu
○	Description: This is the core command. It starts a new Docker container with the following rules:
■	--name app1: Names the container "app1".
■	-itd: Runs the container in interactive mode, allocates a tty (terminal), and runs it in detached mode (in the background so it doesn't lock up your current terminal).
■	-v /mnt/share:/data: Creates a bind mount. It links the /mnt/share folder on your host machine to a /data folder inside the container.
■	ubuntu: Uses the official Ubuntu Linux image.
●	docker inspect app1
○	Description: Outputs a large block of JSON data containing all the low-level configuration details about the app1 container. If you scroll through it, you would see your volume mount listed under the "Mounts" section.
●	docker exec -it app1 bash
○	Description: Executes a new command inside the running app1 container. Specifically, it opens an interactive bash shell, effectively logging you into the container.
Inside the Docker Container (Terminal changes to root@<container-id>:/#)
●	> cd /data
○	Description: Navigates into the /data directory inside the container.
●	> ls
○	Description: Lists the files. Because this directory is mapped to the host, you will see app.config, app.data, and app.logs here.
●	> touch app.new data
○	touch app.new or to add text to a file, use echo "data" > app.new. Let's assume you used touch app.new to create a new file.
●	> ls
○	Description: Lists the files again to verify the new file (app.new) was successfully created inside the container.
●	> exit
○	Description: Closes the bash shell and exits the container, dropping you back into your host machine's terminal.
Back on the Host Machine
●	ls /mnt/share/
○	Description: Lists the contents of the shared folder on your host machine. You will now see the original three files plus the new app.new file you created while inside the container. This proves that data modified inside the container's /data directory is permanently saved and reflected on the host machine.
 
creat a index.html with content on node1

1.	mkdir /mnt/web-data
2.	nano /mnt/web-data/index.html

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Container Practice</title>
    <style>
        body {
            font-family: system-ui, -apple-system, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f0f4f8;
            color: #1a202c;
        }
        .card {
            background: white;
            padding: 3rem;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            text-align: center;
            max-width: 400px;
        }
        h1 { 
            color: #3182ce; 
            margin-top: 0;
        }
        .status {
            display: inline-block;
            background-color: #c6f6d5;
            color: #22543d;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.875rem;
            font-weight: bold;
            margin-top: 1rem;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>🐳 Hello, Container!</h1>
        <p>If you are seeing this webpage, your container deployment was successful.</p>
        <p>This is a lightweight static page perfect for testing Docker, Nginx, or Kubernetes setups.</p>
        <span class="status">System: Online</span>
    </div>
</body>
</html>

to save and exit,  Cntr + X , Y, enter

create container
docker run -d  --name web2  -p 8080:80  -v /mnt/web-data:/usr/share/nginx/html  nginx

open browser with node1ip:8080
and verify the content 
MySQL Database Persistence with Docker Volumes
To ensure MySQL database persistence using Docker volumes, follow this revised scenario. It includes creating a MySQL container with a volume, connecting to it, creating a sample database, exiting the container, launching another MySQL container with the same volume, and verifying the presence of the database in the newly launched container.
 
1.       Scenario Overview:
2.       Create MySQL Container with Volume: Create a Docker container with MySQL, utilizing a Docker volume for data persistence.
3.       Connect and Access MySQL Database: Connect to the MySQL container, access the MySQL database inside, and create a sample database.
4.       Exit Container: Exit the MySQL container to simulate a shutdown or container termination.
5.       Launch Another MySQL Container: Launch a new MySQL container with the same volume.
6.       Verify Database Persistence:  Verify that the sample database created earlier is present in the newly launched MySQL container.




 
Step-by-Step Guide:
1. Create MySQL Container with Volume:
docker run -d --name mysql-container -v mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=password mysql:latest
 
2. Connect and Access MySQL Database:
docker exec -it mysql-container mysql -uroot -p
 
Inside MySQL:
CREATE DATABASE sample_db;
show databases;
exit;
 
3. Exit Container:
exit
docker stop mysql-container
4. Launch Another MySQL Container:
docker run -d --name mysql-container-2 -v mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=password mysql:latest
 
5. Login to second container database and list database.
docker exec -it mysql-container-2  mysql -uroot -p
Inside MySQL:
show databases;
 
6. Clean up. Stop and remove both containers.
docker stop mysql-container-2  mysql-container
docker rm mysql-container-2  mysql-container
docker volume rm mysql-data
 
Practice Guide: Docker Commit and Push to Docker Hub
Objective:
Demonstrate the use of the docker commit command to create a new Docker image and push it to Docker Hub.
 
Practice Steps:
Step 1: Sign Up for Docker Hub
Visit Docker Hub and sign up for a new account.
https://hub.docker.com/
Step 2: Create a public Repository
Log in to Docker Hub.
In the top navigation, click on "Repositories" and then "Create Repository."
Provide a name for the repository (e.g., my-public-repo) and set it to public. Click "Create."
 
Step 3: Get User Access Keys
In the Docker Hub dashboard, go to "Account Settings" > "personal access tokens" > "New Access Token."
Generate a new access token, providing the necessary permissions(read and write).
 
Step 4: Connect to Docker Hub
In the terminal, log in to Docker Hub using the Docker CLI.
docker login -u YOUR_DOCKER_HUB_USERNAME -p YOUR_ACCESS_TOKEN
 
Step 5: Create a Container
Launch a new container from a base image.
docker run -itd --name my-container ubuntu:latest
 
Step 6: Connect to the Container
docker exec -it my-container /bin/bash
 
 
Step 7: Make Changes in the Container
Create a sample file using the text editor.
mkdir sample-dir
echo “ Enter some content and save the file.” > sample.txt
ls
cat sample.txt
 
Step 8: Commit Changes to a New Image
Exit the container.
exit
Use the docker commit command to create a new image.
docker commit my-container YOUR_DOCKER_HUB_USERNAME/my-custom-image:latest
 
Step 9: Push the Image to Docker Hub
Push the newly created image to Docker Hub.
docker push YOUR_DOCKER_HUB_USERNAME/my-custom-image:latest
 
Step 10: Verify on Docker Hub
Stop and remove the currently running container.
Get the new image path, uploaded your repository.
Create container with same image.
Connect to container and check for same file.
 
Hosting Electo website:
 
Host the following repo in docker container and convert to an image.
https://github.com/shubhamrd/electro-sample.git
 
1.	create container with nginx / httpd
2.	get inside container
3.	install git
4.	clone the git repo (https://github.com/shubhamrd/electro-sample.git)
5.	copy cloned the data to web hosting dir
6.	check locally
7.	convert to an image
8.	push to your docker hub account (optional)


 
Guided Practice: Containerizing a Static Web App with Docker
Objective: Learn how to launch a base Nginx web server, manually inject a custom website into it, and save those changes as a brand new, reusable Docker image.

Prerequisites:

Docker installed and running on your machine.

Terminal or Command Prompt access.

Logged into Docker Hub on your CLI (using docker login).

Step 1: Launch the Base Web Server
First, we need to start a standard Nginx web server. We will run it in the background and map a port so we can access it from our web browser.

docker run --name electro -p 8090:80 -d nginx
--name electro: Gives our container a recognizable name instead of a random string.

-p 8090:80: Forwards traffic from port 8090 on your actual computer (the host) to port 80 inside the container (where Nginx is listening).

-d: Runs the container in "detached" mode (in the background).

Step 2: Access the Container's Terminal
To modify the web server, we need to get inside it. We will open an interactive bash shell within the running "electro" container.

docker exec -it electro bash
-it: Keeps the input open and allocates a terminal, allowing us to type commands.

Note: Your prompt will change to something like root@container_id:/#, indicating you are now operating inside the container.

Step 3: Install Necessary Tools
The base Nginx image is very minimal and doesn't come with tools like Git. We need to update the package manager and install Git so we can download our code.


apt update
apt install git -y
Step 4: Fetch the Application Code
Now that Git is installed, we can download the sample website repository directly into the container.


git clone https://github.com/shubhamrd/electro-sample.git
cd electro-sample/
ls
Observation: The ls command will show you the HTML, CSS, and other assets that make up the website.

Step 5: Deploy the Website
Nginx serves web pages from a specific default folder: /usr/share/nginx/html/. We need to move our downloaded files into this directory, overwriting the default Nginx welcome page.


cp -rvf * /usr/share/nginx/html/
-r: Recursive (copies all folders and their contents).

-v: Verbose (shows you exactly what is being copied).

-f: Force (overwrites existing files without asking).

Step 6: Verify Internally and Exit
Let's make sure the website is responding from inside the container before we leave.

apt update
apt install curl -y
curl localhost
exit
curl localhost should output the HTML code of your newly copied website.

exit returns you to your host machine's regular terminal.

Step 7: Verify Externally
It's time to see it in action! Open your favorite web browser and navigate to:
http://<your-node-ip>:8090 (If you are doing this on your local machine, use http://localhost:8090).

You should see the "Electro" sample website running live.

Step 8: Save Your Custom Image
Right now, your custom website only exists inside the running "electro" container. If you delete the container, your work is gone. Let's capture the current state of the container and save it as a new Docker image.

docker commit electro shubhamrdalvi/app-repo:electro
This command takes the electro container and bundles it into an image tagged as shubhamrdalvi/app-repo:electro.

Step 9: Publish to Docker Hub
Finally, push your new custom image to your Docker Hub repository so it can be pulled and deployed anywhere in the world.


docker push shubhamrdalvi/app-repo:electro
💡 Best Practice Pro-Tip for the Future:
While using docker commit is an excellent way to learn how containers work, it is generally considered an "anti-pattern" in production environments because it's hard to track exactly what changes were made. In real-world scenarios, you would automate Steps 3 through 5 by writing a Dockerfile and using the docker build command!
 
Dockerfile
https://docs.docker.com/reference/dockerfile/
This guide walks you through creating a directory, setting up a Dockerfile, building images, and managing container versions.
1. Setup Workspace
Create a directory to keep your project files organized and move into it.
mkdir data cd data
2. Create the Dockerfile
Open the text editor to create the configuration file.
nano Dockerfile
Copy and paste the following content into the editor:
FROM nginx
WORKDIR /usr/share/nginx/html
RUN apt update
RUN apt install git -y
RUN git clone https://github.com/shubhamrd/electro-sample.git
RUN cp -rf electro-sample/* .
COPY ca.cert .
ADD https://dockerlabs.collabnix.com/beginners/docker/what-is-docker.html .
 
Save and Exit Nano:
1.   Press Ctrl+O then Enter (to save)
2.   Press Ctrl+X (to exit)
Verify the file was created correctly:
cat Dockerfile
3. Create Initial Content
Create a simple HTML file that will be copied into your image.
echo "file created using dockerfile" > ca.cert ls
4. Build and Run Version 1
Build your first Docker image tagged as version 1.
docker build -t app2:v1 .
Check that the image exists:
docker images
Run the container in the background (detached mode):
docker run --name app4 -d -p 8090:80 app2:v1
Verify the container is running:
docker ps
5. Inspect Container Internals
open browser with nodeip:8090 check website
 
6. Create Version 2
Modify the HTML file to create a new version of your application.
echo "version2" >> ca.cert
Build the new image tagged as version 2:
docker build -t app2:v2 .
Verify both versions exist:
docker images
7. Run Version 2
Start a new container using the updated image. Note that we give it a different name (app5).
docker run --name app5 -d -p 8092:80 app2:v2
8. open browser with nodeip:8090/ca.cert check website
Ubuntu Shell Script Application
This section covers creating a custom shell script, using a specific Dockerfile name, and checking container logs.
1. Create the Shell Script
Create a script that prints a message repeatedly.
nano script1.sh
Paste the following content:
while true
do
echo "the script is running" sleep 5
done
 
Save and Exit:
1.   Press Ctrl+O then Enter
2.   Press Ctrl+X
Verify the file exists:
ls
2. Create a Custom Dockerfile
Create a Dockerfile with a specific name (dockerfile1) instead of the default.
nano dockerfile1
Paste the following content:
FROM ubuntu
WORKDIR /mnt
COPY *.sh .
CMD ["sh", "script1.sh"]
Save and Exit:
1.   Press Ctrl+O then Enter
2.   Press Ctrl+X
Verify the file content:
cat dockerfile1
3. Build with Custom File
Build the image using the -f flag to point to your custom Dockerfile.
docker build -t bashapp:v1 -f dockerfile1 .
Check the image:
docker images
4. Run and Monitor
Run the container in detached mode.
docker run --name bashapp -d bashapp:v1
Check the container status (it should be Up):
docker ps -a
View the logs to verify the script is running:
docker logs bashapp
 
 
 
 
 Entrypoint and Environment Scripts
This section demonstrates how to use ENTRYPOINT combined with CMD to create flexible containers that can run different scripts (Prod vs Non-Prod) based on command-line arguments.
1. Create Environment Scripts
Create two separate scripts to simulate different environments.
Create the Non-Prod script:
nano nonprod.sh
Paste the following content:
while true
do echo "This is non prod environment"
sleep 5
done
Save and Exit (Ctrl+O, Enter, Ctrl+X).
Create the Prod script:
nano prod.sh
Paste the following content:
while true
do echo "This is prod environment"
sleep 5
done
Save and Exit.
2. Update the Dockerfile
Modify dockerfile1 to use ENTRYPOINT. This sets the executable to sh, while CMD provides the default argument (nonprod.sh).
nano dockerfile1
Replace the content with:
FROM ubuntu
WORKDIR /mnt
COPY *.sh .
ENTRYPOINT ["sh"]
CMD ["nonprod.sh"]
Save and Exit.
3. Build Version 3
Build the new image version using the updated Dockerfile.
docker build -t bashapp:v3 -f dockerfile1  .
4. Run Default (Non-Prod)
Run the container without extra arguments. It will use the default CMD (nonprod.sh).
docker run --name nonprodapp3 -d bashapp:v3
Check status and logs:
docker ps
docker logs nonprodapp3
(Output should say "This is non prod environment")
5. Run Override (Prod)
Run the container and explicitly provide prod.sh as an argument. This overrides the default CMD.
docker run --name prodapp3 -d bashapp:v3 prod.sh
Check status and logs:
docker ps
docker logs prodapp3
(Output should say "This is prod environment")
 

 
 
 Day 3
Delete all container and clean  node 1
for i in $(docker ps -qa); do  docker rm -f $i; done
Docker git repo:
https://github.com/docker/awesome-compose/tree/master
nano docker-compose.yaml
 
name: web-compose
services:
 web:
   image: nginx
   ports:
    - "8090:80"
    - "8443:443"
    - "8080:8090"
   environment:
    - NGINX_HOST=localhost
    - NGINX_PORT=80
 db:
   image: mysql
   environment:
    - MYSQL_ROOT_PASSWORD=example
   ports:
    - "3306:3306"

 
use Cntr + o to save
and ctr + x to exit
 
 
docker compose up -d
docker ps -a
docker compose ls
docker compose ps
 docker compose logs
 docker compose top
 docker compose down
docker compose ls
docker ps -a















docker compose with flask: https://docs.docker.com/compose/gettingstarted/

Docker Compose Quickstart
This tutorial introduces fundamental concepts of Docker Compose by guiding you through the development of a basic Python web application using the Flask framework and a Redis hit counter.
Prerequisites
●	Installed the latest version of Docker Compose
●	A basic understanding of Docker concepts
Step 1: Set up the project
Create a directory for the project:
$ mkdir compose-demo
$ cd compose-demo

Create app.py in your project directory and add the following:
import os
import redis
from flask import Flask

app = Flask(__name__)
cache = redis.Redis(
    host=os.getenv("REDIS_HOST", "redis"),
    port=int(os.getenv("REDIS_PORT", "6379")),
)

@app.route("/")
def hello():
    count = cache.incr("hits")
    return f"Hello from Docker! I have been seen {count} time(s).\n"

Create requirements.txt in your project directory and add the following:
flask
redis

Create a Dockerfile:
# syntax=docker/dockerfile:1
FROM python:3.12-alpine
WORKDIR /code
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["flask", "run", "--debug"]

Create a .env file to hold configuration values:
APP_PORT=8000
REDIS_HOST=redis
REDIS_PORT=6379

Create a .dockerignore file to keep unnecessary files out of your build context:
.env
*.pyc
__pycache__
redis-data

Step 2: Define and start your services
Create compose.yaml in your project directory:
services:
  web:
    build: .
    ports:
      - "${APP_PORT}:5000"
    environment:
      - REDIS_HOST=${REDIS_HOST}
      - REDIS_PORT=${REDIS_PORT}
  redis:
    image: redis:alpine

Start up your application:
$ docker compose up -d

Open http://localhost:8000. You should see the hit counter. Stop the stack before moving on:
$ docker compose down

Step 3: Fix the startup race with health checks
To ensure the web service waits for Redis to be fully ready, add a health check. Update compose.yaml:
services:
  web:
    build: .
    ports:
      - "${APP_PORT}:5000"
    environment:
      - REDIS_HOST=${REDIS_HOST}
      - REDIS_PORT=${REDIS_PORT}
    depends_on:
      redis:
        condition: service_healthy
  redis:
    image: redis:alpine
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5
      start_period: 10s

Step 4: Enable Compose Watch for live updates
Because the Flask app is already running in --debug mode (which has a built-in auto-reloader), we can actually just use sync instead of sync+restart. This bypasses the restart bugs in older Docker Compose versions and is much faster.
Update your compose.yaml. Add the develop block to your web service. Your complete compose.yaml should look like this:
services:
  web:
    build: .
    ports:
      - "${APP_PORT}:5000"
    environment:
      - REDIS_HOST=${REDIS_HOST}
      - REDIS_PORT=${REDIS_PORT}
      - FLASK_APP=app.py
      - FLASK_DEBUG=1
    volumes:
      - .:/code
    depends_on:
      redis:
        condition: service_healthy
    develop:
      watch:
        - action: sync
          path: .
          target: /code
        - action: rebuild
          path: requirements.txt

  redis:
    image: redis:alpine
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5
      start_period: 10s

Start the stack in Watch Mode. Instead of the older docker compose watch command, you should launch the stack directly into watch mode using the --watch flag:
docker compose up --watch

Test the Live Update
1.	Open your browser to http://localhost:8000.
2.	Leave your terminal running. Open your app.py file in a code editor.
3.	Change the greeting text (e.g., to return f"Hello from Compose Watch! I have been seen {count} time(s).\n").
4.	Save the file.
Stop the stack before moving on:
$ docker compose down

Step 5: Persist data with named volumes
If you run docker compose down and then docker compose up, the Redis hit counter resets to zero. To preserve this data across container restarts, use a named volume.
Update compose.yaml to mount a volume for the Redis container:
services:
  web:
    # ... web configuration ...
  redis:
    image: redis:alpine
    volumes:
      - redis-data:/data
    healthcheck:
      # ... healthcheck configuration ...

volumes:
  redis-data:

Stop the stack and verify volume removal when necessary using:
$ docker compose down -v

Step 6: Structure your project with multiple Compose files
As applications grow, a single Compose file becomes harder to maintain. You can split services across multiple files and use the -f flag to combine them at runtime.
Create a new file called infra.yaml and move the Redis infrastructure into it:
infra.yaml
services:
  redis:
    image: redis:alpine
    volumes:
      - redis-data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5
      start_period: 10s

volumes:
  redis-data:

Update your compose.yaml to focus on the web application:
services:
  web:
    build: .
    ports:
      - "${APP_PORT}:5000"
    environment:
      - REDIS_HOST=${REDIS_HOST}
      - REDIS_PORT=${REDIS_PORT}
    depends_on:
      redis:
        condition: service_healthy
    develop:
      watch:
        - action: sync+restart
          path: .
          target: /code
        - action: rebuild
          path: requirements.txt

  redis:
    image: redis:alpine

Start the application by passing both files. Compose will merge them at startup:
docker compose -f compose.yaml -f infra.yaml up

Stop the stack before moving on:
$ docker compose -f compose.yaml -f infra.yaml down

Step 7: Inspect and debug your running stack
With your stack running, you can observe logs and execute commands without stopping the containers.
Stream logs from all services:
$ docker compose logs -f

Verify environment variables inside a running container:
$ docker compose exec web env | grep REDIS

Test internal networking:
$ docker compose exec web python -c "import redis; r = redis.Redis(host='redis'); print(r.ping())"


 
Kubernete setup with minikube
https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download

Kubernetes setup with kubeadm
https://github.com/shubhamrd/Kubernetes/tree/main/kubernetes-setup


 
Pod Management
minikube status
kubectl get nodes
 
Part 1: Running and Managing Pods
In this section, you'll practice deploying an Nginx container and exploring different ways to view its status.
1. Create the Pod
The run command is the fastest way to start a single Pod.
Command: kubectl run firstpod --image nginx
Goal: Tell Kubernetes to pull the nginx image and start a container named firstpod.
2. Check Pod Status
Basic List: kubectl get pods (Shows name, status, and restarts).
Extended Info: kubectl get pods -o wide (Shows the IP address and which Node the pod is running on).
Real-time Watch: kubectl get pods -w
Tip: This "watches" for changes. If you delete a pod in another terminal, you’ll see the status change here instantly. Press Ctrl + C to exit.
3. Deep Dive into the Pod
Sometimes a pod says "Running," but you need to know what happened behind the scenes.
Command: kubectl describe pod firstpod
Look for: The Events section at the bottom. This tracks pulling the image, assigning the node, and starting the container.
4. Logging and Execution
View Logs: kubectl logs firstpod
Use case: If your app crashes, this shows the application's stdout/stderr.
Interactive Shell: kubectl exec -it firstpod -- bash
Action: This drops you inside the container. Try typing ls or exit to return to your main terminal.

 
Part 2: Working with Labels
Labels are key-value pairs used to organize and select subsets of objects.
Action	Command
Add a Label	kubectl label pod firstpod env=test
View Labels	kubectl get pod firstpod --show-labels
Update Label	kubectl label --overwrite pod firstpod env=test1
Remove Label	kubectl label pod firstpod env- (The - after the key deletes it)
 
 

 
 
Practical Guide: Basic Pod Management (CLI)
This guide focuses on managing Pods directly via the command line (CLI). Using the CLI is essential for quick troubleshooting, labeling, and administrative tasks in a containerized environment.
🛠 Basic Concepts
●	Pod: The smallest deployable unit in Kubernetes/container orchestration, representing a single instance of a running process.
●	Labels: Key-value pairs attached to Pods used for organizing and filtering.
●	CLI Management: Performing actions directly via commands rather than configuration files (YAML).
🏗 Scenario: Non-Prod Application Management
You are tasked with managing several application pods in a testing environment (nonprod). You will create, label, and filter these pods to simulate a real-world workflow.
Step 1: Create a Pod
We will create a simple Nginx pod to represent a web server.
Command: kubectl run nonprod-webapp --image=nginx
●	Explanation:
○	run: Creates a new Pod.
○	nonprod-webapp: The name of the Pod.
○	--image=nginx: Specifies the container image to use.
Step 2: List Pods
To see if your Pod was created successfully.
Command: kubectl get pods
●	Explanation: Lists all Pods in the current namespace and shows their status (e.g., Running, Pending).
Step 3: Describe a Pod (Detailed Info)
If a Pod is stuck in "Pending" or "CrashLoopBackOff," you need to see the detailed status and events.
Command: kubectl describe pod nonprod-webapp
●	Explanation:
○	describe: Shows detailed information about the resource, including its IP, labels, container status, and a list of recent Events (e.g., "Successfully pulled image").
Step 4: View Pod Logs
Checking logs is the first step in debugging an application.
Command: kubectl logs nonprod-webapp
●	Explanation: Displays the standard output (STDOUT) of the container running inside the Pod.
Step 5: Execute Commands Inside a Pod
Sometimes you need to enter the Pod to check files or configurations.
Command: kubectl exec -it nonprod-webapp -- //bin/bash
●	Explanation:
○	-it: Interactive terminal mode.
○	-- /bin/bash: The command to run inside the container to give you a shell prompt.
○	run command cat /etc/os-release
○	To Exit: Type exit and press Enter.
Step 6: Labeling and Overriding
Labels allow you to categorize Pods (e.g., by environment or tier).
Adding a Label:
Command: kubectl label pods nonprod-webapp env=nonprod tier=frontend
kubectl get pods –-show-labels
●	Explanation: Adds two labels (env and tier) to the nonprod-webapp pod.
Overriding an Existing Label:
Command: kubectl label pods nonprod-webapp tier=web-server --overwrite
kubectl get pods –-show-labels
●	Explanation:
○	--overwrite: Required if the label key (tier) already exists and you want to change its value.
Step 7: Filtering Pods Based on Labels
When you have hundreds of pods, you use filters (selectors) to find specific ones.
Command: kubectl get pods -l env=nonprod
 
●	Explanation:
○	-l: Stands for "selector" or "label". This command only shows pods that have the env=nonprod label.
Step 8: Removing a Label (De-labeling)
If a label is no longer needed, you can remove it.
Command: kubectl label pods nonprod-webapp tier-
●	Explanation: Adding a dash (-) immediately after the label key name removes that label from the Pod.
🧹 Clean Up Steps
Always remove your practice resources to keep the environment clean.
1. Delete the Pod
Command: kubectl delete pod nonprod-webapp
●	Explanation: Stops the container and removes the Pod definition from the system.
💡 Best Practices
1.   Descriptive Names: Always include the environment prefix (e.g., nonprod-) in the Pod name.
2.   Standard Labels: Establish a standard set of labels (e.g., app, env, owner) for all Pods.
3.   Describe First for Infrastructure Errors: If the pod won't start, use describe. If the pod starts but the app crashes, use logs.
 
https://kubernetes.io/docs/home/
 
Practical Guide: Declarative Pod Management (YAML & Inspection)
This guide covers how to manage Kubernetes resources using YAML files (declarative approach) and how to use inspection tools to understand resource structures.
🛠 Basic Concepts
●	Declarative Management: Using files (YAML) to define the "desired state" of your cluster.
●	Dry Run: Simulating a command to see the output or generate a template without actually creating a resource.
●	API Exploration: Using tools to see what fields are available in a Kubernetes resource.
🏗 Scenario: Non-Prod Resource Exploration and Deployment
You are moving beyond simple CLI commands to managing resources using configuration files, which is the standard for production environments.
Step 1: Explore API Resources
Before creating a YAML file, you need to know what fields are available and what resources the cluster supports.
Command: kubectl api-resources
●	Explanation: Lists all available resource types (Pods, Services, etc.) supported by your cluster.
Command: kubectl explain pods
●	Explanation: Provides documentation for the Pod resource. It shows the top-level fields like apiVersion, kind, metadata, and spec.
Command: kubectl explain pods --recursive
●	Explanation: Shows the entire tree of fields available within a Pod, helping you find deeply nested configuration options.
Step 2: Generate a YAML Template
Instead of writing YAML from scratch, use a dry-run to generate a template.
Command: kubectl run firstpod1 --image=nginx --dry-run=client -o yaml > newpod.yml
●	Explanation:
○	--dry-run=client: Tells Kubernetes NOT to create the pod, just simulate the request.
○	-o yaml: Outputs the result in YAML format.
○	> newpod.yml: Redirects the output into a new file named newpod.yml.
Step 3: Edit the YAML File
Open the file to modify it for your specific needs.
1.   Open the file: nano newpod.yml
2.   Modify the content to match this configuration:
apiVersion: v1
kind: Pod
metadata:
  labels:
 	run: firstpod1
 	env: test
  name: firstpod2
spec:
  containers:
  - image: httpd
	name: firstpod1
 
3.   To Save and Exit: Press Ctrl + O, then Enter, then Ctrl + X.
Step 4: Validate and Create the Pod
Always validate your YAML before applying it to the cluster.
Command: kubectl create -f newpod.yml --dry-run=client
●	Explanation: Validates that the YAML syntax is correct without creating the resource.
Command: kubectl create -f newpod.yml
●	Explanation: Creates the Pod defined in the file.
Step 5: Verify and Inspect
Command: kubectl get pods
Command: kubectl describe pod firstpod2
●	Explanation: Use describe to check if the Pod started correctly or to see if there are any errors.
Step 6: The "Apply" Workflow (Updates)
In professional environments, we use apply to update resources.
1.   Edit the file to add a new label: nano newpod.yml
2.   Under labels:, add team: dev. Save and exit.
Command: kubectl diff -f newpod.yml
●	Explanation: Shows the difference between your local file and the live resource in the cluster (like a "git diff").
Command: kubectl apply -f newpod.yml
●	Explanation: Updates the live Pod with the changes made in your YAML file.
Command: kubectl get pod firstpod2 --show-labels
Step 7: Direct Live Editing
Sometimes you need to fix a live resource without changing the local file.
Command: kubectl edit pod firstpod2
●	Explanation: Opens the live configuration in your default editor. After you save and exit, Kubernetes applies the changes immediately.
Command: kubectl get pod firstpod2 --show-labels
🧹 Clean Up Steps
Command: kubectl delete -f newpod.yml
●	Explanation: Deletes the resource defined in the file.
Command: rm newpod.yml
💡 Best Practices
1.   Dry-Run Often: Use --dry-run=client -o yaml to generate perfect templates every time.
2.   Apply over Create: Use kubectl apply for most tasks as it handles updates gracefully.
Check Labels: Use --show-labels frequently to ensure your organization logic is correct.
 
 

 
Task 1: 
1.	Create pod with electo image created in last practice
apiVersion: v1
kind: Pod
metadata:
 labels:
   owner: shubham
   app: electro
   version: "1"
 name: electro
spec:
 containers:
 - image: pavanvs/electo:1.0
  name: main

2.	expoe with port forwarding

kubectl port-forward pod/electro 8080:80
3.	Open browser localhost:8080
4.	and verify
 
Task2:
1.	Cretae a pod with mysql container image
apiVersion: v1
kind: Pod
metadata:
 name: mysql
spec:
 containers:
 - name: mysql
  image: mysql:latest
  env:
  - name: MYSQL_ROOT_PASSWORD
    value: "root123"
  ports:
  - containerPort: 3306

2.	connect to pod and get inside the mysql database
appy file, 
use exec to get in the pod
use mysql to get in database
list databases and exit

Task3:
1.	Create pod with two containers.


2.	container 1 image: nginx
3.	container 2 image: busybox
Create a pod with two container
con1: nginx
con2: busybox
apiVersion: v1
kind: Pod
metadata:
  labels:
	app: webapp
	image: nginx
	owner: team-b
	cc: rps
	stage: beta
  name: multi-pod
spec:
  containers:
  - image: nginx
	name: con1
  - image: busybox
	name: con2
	command: ["sleep", "3600"]
 
 
apply the file
get pods
describe pod to get container
kubectl exec -it multi-pod -c con1
exit
kubectl exec -it multi-pod -c con2
exit
kubectl logs multi-pod -c con1
kubectl logs multi-pod -c con2

 
Init Containrt
apiVersion: v1
kind: Pod
metadata:
 name: init-demo
spec:
 containers:
 - name: nginx
  image: nginx
  ports:
  - containerPort: 80
 initContainers:
 - name: init-container
  image: busybox
  command: ['sh', '-c', 'echo Starting init container... && sleep 30 && echo Init container finished successfully!']


apply the file,
wait to start container
describe pod and check the events
check logs of both containers


 
Working with ReplicaSet
Create a ReplicaSet (RS)
 
YAML Definition: Create nginx-rs.yaml with the following content:
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-rs
spec:
  replicas: 3
  selector:
	matchLabels:
  	app: nginx
  template:
	metadata:
  	labels:
    	app: nginx
	spec:
  	containers:
  	- name: nginx
    	image: nginx
 
 
 
 
 
 
kubectl apply -f nginx-rs.yaml
 
Verify the ReplicaSet
 
Command: kubectl get rs
Expectation: nginx-rs should be running with 3 replicas.
 
Scale the ReplicaSet
Scale Up: kubectl scale rs nginx-rs --replicas=5
Verify: kubectl get rs
Scale Down: kubectl scale rs nginx-rs --replicas=2
Verify again.
 
edit the label of any pod under rs and check the reaction.
restore the label to original and again check
kubectl get pods --show-labels
select any pod
kubectl label pod pod-name app=webapp --overwrite
kubectl get pods --show-labels
kubectl label pod pod-name app=nginx 
 

  
Services
kubectl run webapp --image=nginx --port=80
kubectl expose pod webapp --target-port=80 --port=8090
 
kubectl get pods
kubectl get svc
copy the IP of services
minikube ssh
 curl <service-ip>:8090
exit
 
NodeIP servoie
 
kubectl delete svc webapp
kubectl expose pod webapp --target-port=80 --port=8090 --type=NodePort
kubectl get svc
 
Check external port no.
 
minikube ip
Open browser with minikube ip and port no
  

 
Labels and selectors with service
Step 1: Create a Pod with Labels using YAML
Create a YAML file named pod-with-labels.yaml with the following content:
 
apiVersion: v1
kind: Pod
metadata:
  name: my-nginx
  labels:
	app: my-nginx
	env: production
spec:
  containers:
  - name: nginx-container
	image: nginx
 
 
 
Apply the YAML file:
 
kubectl apply -f pod-with-labels.yaml
 
Step 2: List Labels for the Pod
List labels for the created pod:
kubectl get pod my-nginx --show-labels
 
 
Step 3: Create a Service with the Same Selectors using YAML
Create service-with-selectors.yaml with the following content:
 
apiVersion: v1
kind: Service
metadata:
  name: my-nginx-svc
spec:
  selector:
	app: my-nginx
	env: production
  type: NodePort
  ports:
	- protocol: TCP
  	port: 80
  	targetPort: 80
  	nodePort: 30007  # Optional: defines the specific port on the Node
 
 
 
Apply the YAML file:
kubectl apply -f service-with-selectors.yaml
 
Step 4: Test the Service
 
kubectl get svc my-nginx-svc
open broser with minikube ip and port
 
Extend the demos of service:
Step 1: Remove Selectors from Existing Pod
 
kubectl label pod podname --overwrite app=webapp
kubectl label pod podname --overwrite env=test
 
 
Step 2: Check Connectivity to the Service (Expect Failure)
# Access the service internally after removing selectors (Expect failure)
check on browser
 
 
 
 
delete all pods, service and replicaset (not default kubernetes service))
kubectl get all


Step1: Create a replica set with image: shubhamrdalvi/application:1.0
apiVersion: apps/v1
kind: ReplicaSet
metadata:
 name: app
spec:
 replicas: 3
 template:
   metadata:
     labels:
       app: webapp
       version: v1
   spec:
     containers:
     - name: nginx-con
      image: shubhamrdalvi/application:1.0
 selector:
   matchLabels:
     app: webapp

step2: expose the replica set with service and check verify appliction on browser
apiVersion: v1
kind: Service
metadata:
 name: frontend-svc
spec:
 ports:
 - port: 80 #service now
  protocol: TCP
  targetPort: 80 # container port
 selector:
   app: webapp
   version: v1
 type: NodePort

step3: create a new replica set with image shubhamrdalvi/application:2.0 
apiVersion: apps/v1
kind: ReplicaSet
metadata:
 name: app2
spec:
 replicas: 3
 template:
   metadata:
     labels:
       app: webapp
       version: v2
   spec:
     containers:
     - name: nginx-con
      image: shubhamrdalvi/application:2.0
 selector:
   matchLabels:
     app: webapp

Step4: forward traffic to new replica set from same service
apiVersion: v1
kind: Service
metadata:
 name: frontend-svc
spec:
 ports:
 - port: 80 #service now
  protocol: TCP
  targetPort: 80 # container port
 selector:
   app: webapp
   version: v2
 type: NodePort

step5: change old replica set count to 0 
Deployment
Step 1: Create a Deployment
Create a YAML file for the Deployment: Name it nginx-deployment.yaml. This will create a Deployment running an Nginx server.
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 5
  selector:
	matchLabels:
  	app: nginx
  template:
	metadata:
  	labels:
    	app: nginx
	spec:
  	containers:
  	- name: nginx
    	image: shubhamrdalvi/application:1.0
 
 
 
 
 
 
Create the Deployment:
kubectl apply -f nginx-deployment.yaml
 
 kubectl annotate deployment nginx-deployment kubernetes.io/change-cause="version change1" --overwrite=true
 
expose the deployment and check on browser.


Step 2: Update the Deployment
Update the Deployment to Use a New Version of Nginx:
 
Edit the nginx-deployment.yaml file, changing the image from shubhamrdalvi/application:1.0 to shubhamrdalvi/application:2.0
 
 Apply the yaml file
.
Chck deployment 
Kubectl get pods -w
 kubectl annotate deployment nginx-deployment kubernetes.io/change-cause="upgraded to stable-perl" --overwrite=true

verify changes on browser with service


Do the same for image  shubhamrdalvi/application:3.0
 
Step 3: Monitor the Update
Monitor the Status of the Deployment:
kubectl rollout status deployment/nginx-deployment
 
 
 
Step 5: Rollback if Necessary
Rollback to the Previous Version:
If you need to rollback the update for any reason:
 kubectl rollout history deployment/nginx-deployment
 kubectl get rs -o wide
 
Rollback deployment
 
kubectl rollout undo deployment/nginx-deployment
 
or
Kubectl rollout undo –to-revision=2 deployment name # last version
 
 
 
Practice Guide: Setting Resource Limits in Kubernetes
Objective
Learn to apply CPU and memory limits to containers in Kubernetes pods.
 
Part 1: Creating a Pod with Resource Limits
Write a Pod Definition with Resource Limits
 
Create a file named myapp-pod.yaml.
Add the following content to define a pod with a single container:
apiVersion: v1
kind: Pod
metadata:
  name: web1
  labels:
	app: webapp
spec:
  containers:
  - name: nginx
	image: nginx
	resources:
  	requests:
    	cpu: "500m"
    	memory: "125Mi"
  	limits:
    	cpu: "800m"
    	memory: "400Mi"
 
 
 
 
 
(Here, 500m stands for 500 millicpu (half of a CPU core), and 128Mi is 128 Mebibytes of memory.)
 
Create the Pod
 
Run the following command to create the pod:
kubectl apply -f myapp-pod.yaml
 
Verify the Pod Creation
Check the status of the pod:
kubectl get pods
 
Inspect Resource Limits
View detailed information about the pod, including its resource limits:
kubectl describe pod web1
 
 
Part 3: Experimenting with Resource Limits
Modify Resource Limits
 
Edit myapp-pod.yaml to change the resource limits and provide diiferent pod name. For example, increase the memory limit to 512Mi and the CPU limit to 2, pod name-web2.
 
Apply the changes:
kubectl apply -f myapp-pod.yaml
 
Verify Changes
enable metrix server
minikube addons enable metrics-server
 
wait for 2 min
 
check CPU utilization
kubectl top pod pod-name
 
kubectl describe node minikube
 
Part 4: Cleanup
Delete the Pod
After the practice, clean up by deleting the pod:
kubectl delete -f myapp-pod.yaml

 
Node Scheduling
Part 1: Node Affinity
Node Affinity is used to influence the scheduling of pods onto nodes based on node labels.

Label a Node
First, label a node in your cluster:
Kubectl get nodes
kubectl label nodes minikube  disktype=ssd
kubectl label nodes minikube-m02 disktype=nvme
kubectl label nodes minikube-m03 disktype=hdd


Create a Pod with Node Affinity
Write a YAML file (nginx-affinity.yaml) with a pod that has node affinity:

apiVersion: v1
kind: Pod
metadata:
  name: nginx-ssd
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: disktype
            operator: In
            values:
            - ssd
  containers:
  - name: nginx
    image: nginx

Deploy the pod:
kubectl apply -f nginx-affinity.yaml
Verify 
Kubectl get pods -o wide 

change the yaml file, 
	podname nginx-ssd to  nginx-hdd
	values change ssd to hdd 
apply the file and check the resukt
same try to nvme

kubectl delete pod  nginx-ssd  nginx-hdd  nginx-nvme
 
 
Taints and Tolerations in Kubernetes
Objective
Learn to use taints and tolerations to control pod scheduling on Kubernetes nodes.

Prerequisites
A running Kubernetes cluster with 3 nodes.
kubectl command-line tool installed and configured.
Part 1: Tainting a Node
Taint a Node
Apply a taint to a node using the following command:
kubectl get nodes
kubectl taint nodes minikube size=small:NoSchedule
kubectl taint nodes minikube-m02 size=medium:NoSchedule
kubectl taint nodes minikube-m03 size=large:NoSchedule
<chnage node with minikube node names>

Replace <node> with the name of a node in your cluster.
This taint instructs Kubernetes not to schedule any pods on this node unless they tolerate the size=large taint.

Part 2: Creating a Pod with Tolerations
Define a Pod with Tolerations
Create a file named tolerant-pod.yaml with the following content:
apiVersion: v1
kind: Pod
metadata:
  name: tolerant-pod
spec:
  containers:
  - name: nginx
    image: nginx
  tolerations:
  - key: "size"
    operator: "Equal"
    value: "large"
    effect: "NoSchedule"
This configuration defines a pod that tolerates the size=large taint, allowing it to be scheduled on the tainted node.

Create the Pod
Deploy the pod using:
kubectl apply -f tolerant-pod.yaml

Verify Pod Scheduling
Check if the pod is running:
kubectl get pods -o wide
The pod should be scheduled successfully despite the taint because it has the matching toleration.

Part 3: Modify the file tolerant-pod.yaml
Change pod name and value for tolerance, use small, create pod. Do the same for value medium.
Observe Pod Behavior
kubectl get pods
The new pod without the toleration for the current taint (size=medium) should remain unscheduled.
Part 5: Cleanup
Remove the Taint from the Node
kubectl taint nodes node1 size=small:NoSchedule-
kubectl taint nodes node2 size=medium:NoSchedule-
kubectl taint nodes node3 size=large:NoSchedule-
Remove All pods 

 
Practice Guide: Kubernetes Namespaces & Microservice Isolation
Topic
Kubernetes Namespace Management and Resource Isolation
Objective
Learn how to organize a microservices architecture using Kubernetes namespaces. You will deploy three distinct services (ui-app, kart, and payment-gateway), each in its own dedicated namespace. You will then test their accessibility using NodePort services, learn how to switch your default kubectl context, and perform a clean removal of the resources.
Prerequisites
●	Environment: A running Minikube cluster.
●	Tools: kubectl installed and configured.
Step-by-Step Instructions
Step 1: Create the Namespaces
By default, Kubernetes places resources in the default namespace. We will create three new, logically separated environments.
kubectl create namespace ui-app
kubectl create namespace kart
kubectl create namespace payment-gateway

Verify they were created successfully:
kubectl get namespaces

Step 2: Deploy the UI Application
We will deploy the main frontend application into the ui-app namespace and expose it using a NodePort service.
Create the YAML file:
vi ui-app.yaml
1.	
Paste the following configuration: (Press i to insert, paste the code, press Esc, type :wq, and hit Enter)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ui-deployment
  namespace: ui-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ui
  template:
    metadata:
      labels:
        app: ui
    spec:
      containers:
      - name: web
        image: hashicorp/http-echo
        args: ["-text=Welcome to the Main UI App Frontend!"]
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: ui-service
  namespace: ui-app
spec:
  type: NodePort
  selector:
    app: ui
  ports:
  - port: 80
    targetPort: 5678
2.	
Apply the configuration:
kubectl apply -f ui-app.yaml
3.	
Step 3: Deploy the Kart Service
Next, deploy the shopping cart microservice into the kart namespace with a NodePort service.
Create the YAML file:
vi kart-app.yaml
1.	
Paste the following configuration:
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kart-deployment
  namespace: kart
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kart
  template:
    metadata:
      labels:
        app: kart
    spec:
      containers:
      - name: web
        image: hashicorp/http-echo
        args: ["-text=You are on the Shopping Kart Service."]
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: kart-service
  namespace: kart
spec:
  type: NodePort
  selector:
    app: kart
  ports:
  - port: 80
    targetPort: 5678
2.	
Apply the configuration:
kubectl apply -f kart-app.yaml
3.	
Step 4: Deploy the Payment Gateway
Finally, deploy the highly sensitive payment service into the payment-gateway namespace with a NodePort service.
Create the YAML file:
vi payment-app.yaml
1.	
Paste the following configuration:
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payment-deployment
  namespace: payment-gateway
spec:
  replicas: 1
  selector:
    matchLabels:
      app: payment
  template:
    metadata:
      labels:
        app: payment
    spec:
      containers:
      - name: web
        image: hashicorp/http-echo
        args: ["-text=You are on the Secure Payment Gateway."]
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: payment-service
  namespace: payment-gateway
spec:
  type: NodePort
  selector:
    app: payment
  ports:
  - port: 80
    targetPort: 5678
2.	
Apply the configuration:
kubectl apply -f payment-app.yaml
3.	
Verification & Context Management
1. Verify and Access Services via Browser
Since we are using NodePort, Kubernetes automatically assigns a port in the 30000-32767 range to each service. We will use the Minikube node IP and these assigned ports to test our applications.
Get the Minikube IP: Find the IP address of your Minikube cluster:
minikube ip

(Copy this IP address, e.g., 192.168.49.2)
Get the NodePorts for each service: Run the following commands and look at the PORT(S) column. You will see something like 80:<NODE_PORT>/TCP. Take note of the <NODE_PORT> for each.
kubectl get svc -n ui-app
kubectl get svc -n kart
kubectl get svc -n payment-gateway

Test the Services: Open your web browser and navigate to the combinations of your Minikube IP and the respective NodePorts:
●	UI App: http://<MINIKUBE_IP>:<UI_NODE_PORT> (Expected Output: "Welcome to the Main UI App Frontend!")
●	Kart Service: http://<MINIKUBE_IP>:<KART_NODE_PORT> (Expected Output: "You are on the Shopping Kart Service.")
●	Payment Gateway: http://<MINIKUBE_IP>:<PAYMENT_NODE_PORT> (Expected Output: "You are on the Secure Payment Gateway.")
(Shortcut: Minikube can also automatically fetch the URL for you. Try running minikube service ui-service -n ui-app --url to get the exact web address!)
2. Context Switching
Notice how in the previous steps, we had to type -n ui-app or -n kart every single time? If you are working on a specific microservice all day, this gets tedious. You can change your default namespace context.
Check standard pods (defaults to the default namespace):
kubectl get pods
1.	(It will likely say "No resources found in default namespace.")
Change your current context to the payment-gateway namespace:
kubectl config get-contexts
kubectl config set-context --current --namespace=payment-gateway
2.	
Check pods again (without specifying -n):
kubectl get pods
3.	(Now you should see the payment-deployment pod running! Your terminal is now "locked" into the payment-gateway namespace).
Switch back to the default namespace:
kubectl config set-context --current --namespace=default
4.	
3. Namespace Cleanup
One of the biggest advantages of namespaces is how easy it is to tear down an entire environment. Instead of deleting deployments and services one by one, you just delete the namespace.
kubectl delete namespace ui-app kart payment-gateway

(Note: Deleting a namespace can take a minute or two as Kubernetes gracefully shuts down all pods inside them. Once complete, all the resources we just built are cleanly wiped away).

 
Using Volumes in Pods
Using an emptyDir Volume
 
Create a Pod with an emptyDir volume to share data between containers:
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: myfrontend
        	image: nginx
        	volumeMounts:
    	 	- mountPath: /var/www/html
        	name: myvolume
  volumes:
  - name: myvolume
        	emptyDir: {}
 
Verify :
kubectl get pod
kubectl describe pod mypod
check for volume configuration
 
 
 
 
Using a hostPath Volume
minikube ssh -n minikube-m02
sudo su -
> mkdir /mnt/data
> touch /mnt/data/config.txt
> echo “some text” > /mnt/data/config.txt
>exit
> exit
 
kubectl lable node minikube-m02 nodetype=worker1
Useful for accessing host filesystem, typically for advanced use cases:
 
apiVersion: v1
kind: Pod
metadata:
  name: app2
spec:
  containers:
	- image: nginx
  	name:  con1
  	volumeMounts:
    	- name: testvolume
      	mountPath: /mnt/data
  affinity:
	nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      	nodeSelectorTerms:
        	- matchExpressions:
          	- key: nodetype
            	operator: In
            	values:
              	- worker1
  volumes:
	- name: testvolume
  	hostPath:
    	path: /mnt/data
    	type: Directory
 
 
 
 
 
Apply the file
kubectl exec -it app2
cd /mnt/data
ls
cat config.txt
exit

 
Practice Guide: Persistent Volumes and Shared Storage on a Specific Node

Kubernetes Storage: PV, PVC, hostPath, and Node Affinity
Objective
In this practice, you will create a Persistent Volume (PV) that is physically pinned to the minikube-m02 node using its local filesystem (hostPath). You will then create a Persistent Volume Claim (PVC) to request this storage. Finally, you will deploy two pods (a "writer" and a "reader") scheduled specifically on minikube-m02 that both mount the exact same PVC to share data in real-time.
Prerequisites
● 	Environment: A multi-node Minikube cluster where the second node is named minikube-m02.
● 	Tools: kubectl installed and configured.
Step-by-Step Instructions
Step 1: Verify Your Nodes
Before creating node-specific resources, verify that the target node exists and is ready.
kubectl get nodes
 
(Ensure minikube-m02 appears in the list and is Ready)
Step 2: Create the Persistent Volume (PV)
We will create a PV that uses a directory on the minikube-m02 host machine. We use nodeAffinity so Kubernetes knows this storage only exists on that specific node.
1.	Create the PV YAML file:
vi local-pv.yaml
 
2.	Paste the following configuration:
(Press i to insert, paste, then press Esc, type :wq, and hit Enter)
apiVersion: v1
kind: PersistentVolume
metadata:
 name: local-pv-m02
spec:
 capacity:
   storage: 1Gi
 volumeMode: Filesystem
 accessModes:
 - ReadWriteOnce
 persistentVolumeReclaimPolicy: Retain
 storageClassName: local-storage
 hostPath:
   path: /mnt/data/practice-pv
   type: DirectoryOrCreate
 nodeAffinity:
   required:
     nodeSelectorTerms:
     - matchExpressions:
      - key: kubernetes.io/hostname
        operator: In
        values:
        - minikube-m02


 
Description: This creates a 1GB PV named local-pv-m02. The hostPath type DirectoryOrCreate means it will automatically create /mnt/data/practice-pv on the actual minikube-m02 Linux machine. The nodeAffinity block strictly restricts this volume to only be accessible from minikube-m02.
3.	Apply the PV configuration:
kubectl apply -f local-pv.yaml
 
Step 3: Create the Persistent Volume Claim (PVC)
Now we create a PVC to claim the storage we just defined.
1.	Create the PVC YAML file:
vi local-pvc.yaml
 
2.	Paste the following configuration:
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
 name: shared-pvc
spec:
 accessModes:
 - ReadWriteOnce
 storageClassName: local-storage
 resources:
   requests:
     storage: 1Gi
 
Description: This PVC requests 1GB of storage from the local-storage class. Kubernetes will look for a matching PV and bind this claim to local-pv-m02.
3.	Apply the PVC configuration:
kubectl apply -f local-pvc.yaml
 
Step 4: Create the Writer Pod
We will create a pod that writes the current date and time to a file in the shared volume every 5 seconds.
1.	Create the Writer Pod YAML file:
vi writer-pod.yaml
 
2.	Paste the following configuration:
apiVersion: v1
kind: Pod
metadata:
 name: writer-pod
spec:
 nodeSelector:
   kubernetes.io/hostname: minikube-m02
 containers:
 - name: writer
   image: alpine
   command: ["/bin/sh", "-c"]
   args: ["while true; do date >> /data/shared.txt; echo 'Wrote date to file'; sleep 5; done"]
   volumeMounts:
   - name: shared-storage
     mountPath: /data
 volumes:
 - name: shared-storage
   persistentVolumeClaim:
     claimName: shared-pvc

 
Description: This pod uses nodeSelector to force it to run on minikube-m02. It mounts our shared-pvc to the /data directory inside the container and continuously writes text to /data/shared.txt.
3.	Apply the Writer configuration:
kubectl apply -f writer-pod.yaml
 
Step 5: Create the Reader Pod
Now, we create a second pod that mounts the exact same PVC and reads the file the first pod is generating.
1.	Create the Reader Pod YAML file:
vi reader-pod.yaml
 
2.	Paste the following configuration:
apiVersion: v1
kind: Pod
metadata:
 name: reader-pod
spec:
 nodeSelector:
   kubernetes.io/hostname: minikube-m02
 containers:
 - name: reader
   image: alpine
   command: ["/bin/sh", "-c"]
   args: ["tail -f /data/shared.txt"]
   volumeMounts:
   - name: shared-storage
     mountPath: /data
 volumes:
 - name: shared-storage
   persistentVolumeClaim:
     claimName: shared-pvc
Description: Just like the writer, this pod is pinned to minikube-m02 and mounts the shared-pvc. Instead of writing, it uses tail -f to continuously read and print the contents of /data/shared.txt to its logs.
3.	Apply the Reader configuration:
kubectl apply -f reader-pod.yaml
 
Verification
1. Check the PV and PVC Binding Status
Ensure the claim successfully bound to your volume.
kubectl get pv,pvc
 
(Expected Output: The STATUS column for both the PV and PVC should say Bound)
2. Verify Pod Placement
Check that both pods are running and are physically located on the correct node.
kubectl get pods -o wide
 
(Expected Output: Both writer-pod and reader-pod should show Running, and the NODE column must show minikube-m02 for both).
3. Verify Shared Data
The ultimate test! The reader-pod should be actively outputting the dates written by the writer-pod. Check the reader's logs:
kubectl logs -f reader-pod
 
(Expected Output: You should see a live, updating stream of timestamps. Press Ctrl+C to exit the log stream).
4. (Optional) Check the Minikube Host Node Directly
Because we used a hostPath, the data is physically sitting on the minikube-m02 VM. You can SSH into that specific node and check the directory:
minikube ssh -n minikube-m02
cat /mnt/data/practice-pv/shared.txt
exit
 
helm create nginx-chart
Open the file values.yaml from nginx-chart directory
 
 Changes are as follwing
replicaCount: 4
 
image:
  repository: nginx
  # This sets the pull policy for images.
  pullPolicy: IfNotPresent
  # Overrides the image tag whose default is the chart appVersion.
  tag: "stable-perl"
 
 
service:
  # This sets the service type more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types
  type: NodePort
  # This sets the ports more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/#field-spec-ports
  port: 80
 
 
 
resources:
  # We usually recommend not to specify default resources and to leave this as a conscious
  # choice for the user. This also increases chances charts run on environments with little
  # resources, such as Minikube. If you do want to specify resources, uncomment the following
  # lines, adjust them as necessary, and remove the curly braces after 'resources:'.
   limits:
 	cpu: 200m
 	memory: 300Mi
   requests:
 	cpu: 100m
 	memory: 128Mi
 
 
 
autoscaling:
  enabled: true
  minReplicas: 4
  maxReplicas: 8
  targetCPUUtilizationPercentage: 80
 
 
Save and exit from file
 helm install nginx nginx-chart
kubectl get all
 
edit values.yaml
Change tag from  stable-perl to mainline-perl
  edit Chart.yaml
Change 1.16.0 to 1.18.0
 
 
   helm upgrade nginx nginx-chart
   helm history nginx
kubectl get pods
kubectl describe pod <any-pod-id>
and check image
 
   helm rollback nginx 1
kubectl describe pod <any-pod-id>
check image
   helm history nginx
 helm uninstall nginx
 
 
 
Helm Reposiroty: https://artifacthub.io/

 





Setup minikube on web: https://github.com/codespaces/new/kubernetes/minikube?quickstart=1
signup /sing in with github 

and create code space, 

 



Practice Guide: Local AI with Docker Model Runner
Topic
Using the Native Docker Model Runner CLI for Local Inference and Extending to Kubernetes
Objective
In this practice, you will learn how to enable and use the official Docker Model Runner plugin. You will install the runner, pull the ultra-lightweight SmolLM2 model (360 million parameters), and interact with it using both one-shot commands and an interactive chat session. Finally, you will extend your skills by deploying the same model into a Kubernetes cluster.
Prerequisites
●	Environment: A host machine running Windows, macOS, or Linux.
●	Tools: Docker Desktop 4.40+ (for Mac/Windows) or Docker Engine (for Linux) installed.
●	Kubernetes (For Step 4): A running Minikube cluster and kubectl installed.
Step-by-Step Instructions
Step 1: Install Docker Model Runner
For Linux (Docker Engine): You don't need Docker Desktop on Linux; you just need to install the plugin for your existing Docker Engine.
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release -y

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-model-plugin -y

Verify Installation (All OS): You can verify the installation is successful by checking the plugin version in your terminal.
docker model version
Step 2: Pull the Lightest Model
Once DMR is enabled, you can interact with it using the standard Docker CLI format. We will pull the 360-million parameter version of SmolLM2.
Open your terminal and run:
docker model pull ai/smollm2
Note: This will download the model weights (approx. 256 MB) to your local machine. It only loads into memory when you actively use it.

Step 3: Run the Model
You have two main ways to interact with the model right from your command line:
Option A: One-Shot Prompt If you just want a quick answer without opening a chat session, pass your prompt directly in the command:
docker model run ai/smollm2 "Why is the sky blue? Answer in a single sentence."
(Expected Output: The model will briefly process the request and return a single sentence explaining the sky's color, then exit back to your standard terminal prompt).
Option B: Interactive Chat Mode If you want to have a back-and-forth conversation, simply run the model without a prompt:
docker model run ai/smollm2
(Expected Output: This will drop you into an interactive terminal interface where you can chat with SmolLM2 in real-time. Type your questions, and it will stream the responses back to you locally! Press Ctrl+C or type an exit command to leave the chat session when you are done).
Step 4: Extend the Practice to Kubernetes
Since the docker model CLI is specifically designed for your local machine, running the same model inside a Kubernetes cluster requires us to deploy a containerized model runner. We will deploy the ollama server and instruct it to host the smollm2 model.
1.	Create the Deployment & Service YAML:
Create a file named smollm2-k8s.yaml:
vi smollm2-k8s.yaml
Paste the following configuration into the file:
apiVersion: apps/v1
kind: Deployment
metadata:
  name: smollm2-runner
  namespace: default
spec:
  replicas: 1
  selector:
	matchLabels:
  	app: smollm2
  template:
	metadata:
  	labels:
    	app: smollm2
	spec:
  	containers:
  	- name: runner
    	image: ollama/ollama:latest
    	ports:
    	- containerPort: 11434
---
apiVersion: v1
kind: Service
metadata:
  name: smollm2-service
  namespace: default
spec:
  selector:
	app: smollm2
  ports:
  - port: 80
	targetPort: 11434
2.	Apply the configuration:
3.  kubectl apply -f smollm2-k8s.yaml
4.	Pull the model inside the cluster: Wait for the pod to be running (kubectl get pods), then execute a command inside the container to pull the smollm2 weights:
5.  kubectl exec -it deploy/smollm2-runner -- ollama pull smollm2
6.	Interact with the Model via Kubernetes: Expose the service to your local machine using port-forwarding:
7.  kubectl port-forward svc/smollm2-service 11434:80
Open a new terminal window and send an API request to your Kubernetes-hosted model:
curl http://localhost:11434/api/generate -d '{
  "model": "smollm2",
  "prompt": "Why is the sky blue? Answer in a single sentence.",
  "stream": false
}'
(Expected Output: You will receive a JSON response containing the generated answer from the pod).
8.	Kubernetes Cleanup: Once finished, delete the Kubernetes resources to free up cluster memory:
9.  kubectl delete -f smollm2-k8s.yaml
 


shub





hamrdalvi/application
shubhamrdalvi/applicati
