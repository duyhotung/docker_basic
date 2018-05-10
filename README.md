# Docker Amazon Linux LAMP
Creates a newbiz stack image using the official Amazon Linux image for Docker

* Apache 2.4
* PHP 7.2.4
* MySQL 5.7
* PHP composer latest
* MySQL client

## Prerequisite
Install docker to your local pc via the instruction in [Docker](https://docs.docker.com/install/)
## Getting Started
This container is recommended for development use, to mirror or mimic development of an AWS EC2 instance running Amazon Linux.

### Build Image
Navigate to directory containing docker file. If downloading from Docker Hub, move on to "Create Container" section.
```
docker build -t imageName .
```
### Create Container
You will most likely want to develop on your local machine. Create your directory structure on your local machine and figure out where you want your web root to reside. Update the -v ~/www:/var/www/html with the path to your working directory. You can obviously change this to include multiple filepath mappings, where needed.
```
# Custom Image Build
docker run -ti --name newbiz -p 80:80 -p 443:443 -p 3306:3306  -v ~/www:/var/www/html -d imagesName
```

### Working with MySQL
By default, the root user doesn't have a password. Run the following to set the root user password.
```
docker exec -ti --privileged newbiz mysql_secure_installation
```
### Login as ec2-user
```
docker exec -ti -u ec2-user newbiz bash
```

### Use built Image from DockerHub
You can use the Image built by DockerHub:
```
docker pull duyho/docker_basic
```
