

####################################
####kubectl commands ###############
####################################
#NOTE: kubectl is used to enable remote access to running containers on the AKS server that is hosting the negative news solution

#install kubectl
Install-Script -Name install-kubectl -Scope CurrentUser -Force
install-kubectl.ps1 C:\Users\caridza\

#place config file containing all info on cluster you want to monitor for connecting to the cluster in .kube folder (will be in the directory where you downloaded kubectl)
#current location of config for CT cluster 
C:\Users\caridza\.kube\config

#kubectl version 
kubectl version 
kubectl cluster-info

#see all pod infor (helpful for seeing the cluster objects, names, etc) 
kubectl describe pod 

#see logs for negnews (latest logs, not sure how to see previous logs) 
kubectl logs negnews

#Inerrogate the mongodb container to see information 
#Then cd into data folder: 
kubectl exec -it mongodb /bin/bash
cd bitnami/mongodb/data/db/

#clear mongo collection using kubectl
#bash into python container
kubectl exec -it negnews /bin/bash
> python 
> from pymongo import MongoClient
> client = MongoClient("mongodb://mongo-service")
> db = client['negative_news']
> db.drop_collection("scrape_feed")

#check negnews deployment logs 
https://eysbp.visualstudio.com/FSO%20-%20NegNews/_releaseProgress?_a=release-environment-logs&releaseId=11&environmentId=16

#check container logs 
Kubectl logs -f negnews 

#check pod logs 
Kubectl get pods

#check pod status 
kubectl Describe pod negnews

#bash into running mongo container 
kubectl exec -it mongodb /bin/bash 

#bash into active negative news container 
kubectl exec -it negnews /bin/bash

####################################
####Docker compose commands#########
####################################
#help 
docker-compose --help 
#detailed help on specific command 
docker-compose command --help 

#docker compose(only needed for multi-container solutions) 
#NOTE: every time you make changes to the docker-compose.yaml file you must rebuild or rerun docker compose up
#must be executed in the root directory containing docker-compose.yml file (one up from DTCC_Docker_V1) 
#Note: will only build image if the image does not exist, if it exists it will not rebuild the image each time u start the application 
docker-compose up 

#build images when using compose 
#will rebuild any images that have changed since last build (will do this every time u start application) 
docker-compose up --build 

#initiate a build with no cache 
docker-compose build --no-cache

#shut down all containers associated with docker_compose.yaml
docker-compose down 

#identify all docker endpoints in use 
docker network inspect {negative_news_default}
docker network disconnect -f {network} {endpoint-name}

#############################
###DOCKER BUILD PROCESSES####
#############################
	#build process 
	docker build -t "kycc8:dockerfile" . #build within folder of container DTCC_Docker_V1 

	#load docker image with specfied port(2 examples)
	#Note: if you want a transiant container append --rm to end of docker run command . this will remove the container after it stops 
	docker run -it -p 6006:6006 kycc8:dockerfile 

	#exec into image 
	docker exec -ti imagename /bin/bash

	#create iamge from container 
	docker commit ContainerID 
	
	#save image and load image saves an image to a tar archive stream to STDOUT with allparent layers, tags, and versions 
	#docker save image_name 
	docker save -o <path for generated tar file> <image name> 
	
	#load an image from a tar archive as STDIN, including images and tags
	#docker load image_name
	docker load -i <path to image tar file> 
	
	

##########################################
###########DOCKER COMMANDS################
##########################################
#Tool for enabling autoupdating of dockerfiles after changes 
	#https://github.com/robbyrussell/oh-my-zsh

#SOURCING AND RUNNING EXISTING IMAGES FROM DOCKERHUB OR GIT REPO 
	#login to docker 
	docker login 
	
	#search registrary for specific image 
	docker search 
	
	#pull base ubintu linux docker image from registry to local machine 
	docker pull phusion/baseimage

	#run an image from dockerhub behind EY Portal (you dont need to pull the iamge explicitly, here it is done with the reference to "jupyter/datascience-notebook:9b06df75e445"
	#/$PWD : maps the directory where you are running image from to /home/zack/work within the image being run 
	docker run --rm -p 10000:8888 -e JUPYTER_ENABLE_LAB=yes -v /$PWD:/home/zack/work jupyter/datascience-notebook:9b06df75e445 --env HTTP_PROXY="http://amweb.ey.net:8080"

#DOCKER NETWORK INFORMATION 
	#network info
	docker network ls 
	docker network nspect 
	
	#get IP of a container 
	docker inspect containerID | grep IPAddress | cut -d '"' -f 4

	#get port mapping for a contianer 
	docker inspect -f '{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' <containername>

#DOCKER VOLUMES 
#Docker volumes are free-floating filesystems. They don’t have to be connected to a particular container. 
#You should use volumes mounted from data-only containers for portability
	#create volume 
	docker volume create 
	#remove volume 
	docker volume rm 
	#see volume 
	docker volume ls 
	#inspect volume 
	docker volume inspect 
	
#BASIC DOCKER COMMANDS
	#list enviornment settings 
	docker run --rm ubuntu env
	
	#list all running containers 
		docker container ls 
	
	#list all running and stopped containers 
		docker contianer ps -a 
		
	#list all dangling images 
	docker images -f dangling=true
	
	#inspect image(great to figure out if container is using volumes, and identifying IP addresses)
		docker inspect image_name
	
	#show history of an image 
		docker history imageID
		
	#tag an image to a specific name 
		docker tag imageID <tag2Name>
	
	#get events from container 
		docker events containerID 
	
	#show public facing port of a container 
		docker port containerID 
	
	#show running processes in a container 
		docker top ContainerID 
	
	#show containers resource usage stats 
		docker stats ContainerID 
	
	#show changed files in the containers File System 
		docker diff ContainerID 
		
	#start a stopped container 
		docker start -a containerID
	
	#stop a running container 
		docker stop containerID
	
	#restart a container 
		docker restart containerID
	
	#pause/unpause a running container (freezing it in place) 
		docker pause containerID 
		docker unpause containerID
	
	#block until running container stops
		docker wait containerID
	
	#KILL running container 
		docker kill containerID
	
	#connect to a running contianer 
		docker attach contianerID 
		
	#remove a specific image using the imageid
		docker rmi ImageID

	#remove all unused images that are stopped 
		docker ps -aq --no-trunc -f status=exited | xargs docker rm

	#remove all unused docker images 
		docker image prune 
	#remove all images without a container associated with them 
		docker image prune -a 

	#remove all exited containers 
	docker rm $(docker ps -qa --filter "status=exited")
	
	#kill containers
		docker container kill 222d056d96da
	#kill all running containers
		docker kill $(docker ps -q)
	#Delete old containers 
		docker ps -a | grep 'weeks ago' | awk '{print $1}' | xargs docker rm
	#Delete stopped containers 
		docker rm -v `docker ps -a -q -f status=exited`
	#Delete Dangling Images 
		docker rmi $(docker images -q -f dangling=true)
	#delete all images 
		docker rmi $(docker images -q)
		
	#view all docker volumes 
		docker volume ls 
		
	#delete dangling Volumes (DONT DO THIS, BECUASE ALOT OF THE TIME CONTAINERS WILL NOT BE ASSOCIATED WITH THE VOLUME UNLESS THEY ARE SPUN UP)
		docker volume rmi $(docker volume ls -q -f dangling=true)
		docker volume prune	
	
	#clean up entire system in one command (all containers and voulmes) 
	#Note: this does not remove volumes, becuase volumes tend to store data , and not always are associated with a container	
		docker system prune
	
#docker check commands (they are immutable)
#https://docs.docker.com/engine/reference/commandline/logs/#usage 
#docker cheatsheet:https://github.com/wsargent/docker-cheat-sheet
	#will return 1 or 0 you will have to write this into the docker (try to load docker , if > 3m then red) 
	docker healthcheck 
	#stats on container 
	docker stats <container>
	docker stats $(docker ps --format '{{.Names}}') #containers listed by name 
	
	#get logs from a container 
	docker logs #write a switch to the commands (-v --quite to prevent writting so many logs) 
	docker logs -f #connenct to the container and see the logs streaming as they are populating (debug process as running) 
	docker logs -t #follow tail, instead of just showing me the last 10 lines, it shows the last 10 lines and any new lines 
	#
	
#saving and loading docker images (including any mounted volumes) 
#note: covers docker_compose situation
#https://stackoverflow.com/questions/47855990/docker-compose-save-load-images-to-another-host
	#inspect image(great to figure out if container is using volumes)
	docker inspect image_name 

	#view data in volume 
	docker run -it --rm -v jenkins-home:/vol busybox ls -l /vol

	#convert contianer filesystem into tarball archive stream to STDOUT 
	docker export contianerID 
	
	#save all images from a docker compose yaml file 
	#https://gist.github.com/jcataluna/1dc2f31694a1c301ab34dac9ccb385ea
	docker save -o services.img $images

	
# get the random host port assigned to the container on port 8888
docker port notebook 8888
0.0.0.0:32769

# get the notebook token from the logs
docker logs --tail 3 notebook


#copy file within container to local 
	scp -r /postprocess_datadic.pk tempsudo@10.246.59.29: /home/nlpsomnath/NegNews/zackc/Misc Notebooks/NN_VM/lib/python3.7/site-packages/negative_news/test/output/
	scp -r /03-04-19-02-46-31 tempsudo@10.246.59.29: /home/nlpsomnath/NegNews/zackc/Misc Notebooks/NN_VM/lib/python3.7/site-packages/negative_news/test/output/
	scp -r  03-04-19-13-12-18 tempsudo@10.246.59.29: "/home/nlpsomnath/NegNews/zackc/ContainerOutput/3_4_19/Batch0/"







#building new docker 
#1.incorporate all code updates to folder outside docker 
#2.do a docker build from the directory where all the code sits (docker sees everything in the docker file, and all folders below the folder the docker file is built in)(give image a name and a tag) 
#3.do a docker run to build a container from the image (give the container a name as well or the name will be random 2 words, containerid) 
docker container ls #list all containers runnings 

#develop script locally -> run docker build  
#export an entire container to .gz for transport 
docker export NAME | gzip > NAME.gz

#more exported docker to new location 
scp NAME.gz USERNAME@SERVER_IP:/home/USERNAME

#Open docker 
docker exec -ti nn_bot_run bash

#test the api
#1.load docker
#note: to exit docker (CTRL + P + Q)
docker exec -ti nn_bot_run bash

#2.test functionality on local host
curl http://localhost:6006/sql


#identify all dockers 
docker ps 

#shutdown docker that si currently running 
docker rm -f nn_bot_run

#image: blueprint for container (docker build) 
#container: actual docker instance (docker rn) 

#rebuild docker image(-t name of docker image , . represents that we want it to be built in the current directory, always build from directory with the Dockerfile in it)
#--name : refers to name of the container u want to crate 
# nn_bot_credit is refering to the image you want to base the container from 
#docker run -dti -v /home/docadmin/ZackC/NegNews:/NNfolder --name nn_bot_mvo --net=host nn_bot_credit #spin up a new docker with existing container (MAXIM PROVIDED)
docker build -t "nn_bot_credit:Dockerfile" .
docker run -dti -v /home/docadmin/ZackC/NegNews:/NNfolder --name nn_bot_mvo --net=host nn_bot_new 
docker exec -ti nn_bot_mvo bash

# Add jfrog loc to docker image
# Snytax: run wget remoteaddress localaddress
# Note: ASSUME your local directory is the local directory in the docker
# Note: THIS MUST BE IN THE DOCKER FILE AS PART OF THE BUILD COMMAND
RUN wget http://fsoartifactory.northcentralus.cloudapp.azure.com/artifactory/webapp/#/artifacts/browse/tree/EffectivePermission/Negative-News/filename /NNfolder/sourcefile

#build image (check images ->docker image list)
#PORTS 
#Note: We open all ports , may need to open only a specific port 
#ScrapyD: port 6800
#api: port 6001 (if started in python) , xxxx(if started by gunicorn,this will always be the port used)
#api: port 6000(for doc admin)  , port 5000 (sentinile) 
docker run -dti -v /outsidedockerloc:/dockerloctomapnondockerfiles --name nn_bot_run --net=host nn_bot
docker run -dti -v /:/NNfolder --name nn_bot_run --net=host nn_bot
docker run  /:/NNfolder --name nn_bot_run --net=host nn_bot

#spin up a new docker with existing container (MAXIM PROVIDED)
docker run -dti -v /home/docadmin/ZackC/NegNews:/NNfolder --name nn_bot_mvo --net=host nn_bot_new 


#shell syntax for use in docker command CMD[sh,file.sh]
sh -c 'echo $(pwd)'
sh -c 'echo $(java -version)'

#drives 
#Sentile: /ci/data 
#Docadmin: /pdf


#spedule spier run 
curl http://localhost:6800/schedule.json -d project=myproject -d spider=spider2

#location where docker stores all images 
#Docker for Windows saves the images and data volumes in a shared public folder 
#C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks\MobyLinuxVM.vhdx





#Note:Images are just templates for docker containers 
#registry vs repo:
	#Repo: is a hosted collection of tagged images that together create teh file system for a container 
	#Registry: a host, a server that stores repositories and provides an HTTP API for managing and uploading and downloading of repositories 
