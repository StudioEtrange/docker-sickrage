# docker sickrage by StudioEtrange

* Run sickrage inside a docker container built upon debian
* Based on sickrage github source code
* Choice of sickrage version
* Use supervisor to manage sickrage process
* By default sickrage configuration files will be in a /data/sickrage (You should map a docker volume to /data)


## Sample Usage

for running latest version of sickrage :

	docker run -d -v $(pwd):/data -p 8081:8081 studioetrange/docker-sickrage:latest

then go to http://localhost:8081

## Version and Tag

* docker-tag:latest ==> latest stable sickrage version available through this repository
* github-branch:master ==> work in progress based on latest stable sickrage version available through this repository

In dev case, to have an uptodate image you should
* build the docker image yourself (see build from github souce below)
* OR launch in the container the script /opt/sickrage-update.sh


## Instruction

### build from this github repository

	git pull https://github.com/StudioEtrange/docker-sickrage
	cd docker-sickrage
	docker build -t="studioetrange/docker-sickrage" .

### retrieve image from docker registry

	docker pull studioetrange/docker-sickrage

### run sickrage 
	
	docker run -v DATA_DIR:/data -p SICKRAGE_HTTP_PORT:8081 -p SUPERVISOR_HTTP_WEB:9999 studioetrange/docker-sickrage:SICKRAGE_VERSION

_Note : you have to choose a DATA_DIR, SICKRAGE_HTTP_PORT, SUPERVISOR_HTTP_WEB and SICKRAGE_VERSION_

### run sickrage daemonized

	docker run -d -v DATA_DIR:/data -p SICKRAGE_HTTP_PORT:8081 -p SUPERVISOR_HTTP_WEB:9999 studioetrange/docker-sickrage:SICKRAGE_VERSION

_Note : you have to choose a DATA_DIR, SICKRAGE_HTTP_PORT, SUPERVISOR_HTTP_WEB and SICKRAGE_VERSION_

### run a shell inside this container (without sickrage running)

	docker run -i -t studioetrange/docker-sickrage bash

## Access point

### sickrage

	http://localhost:SICKRAGE_HTTP_PORT/

### Supervisor

	http://localhost:SUPERVISOR_HTTP_WEB/

## Github / docker repository

This github repository is linked to an automated build in docker offical registry.

	https://registry.hub.docker.com/u/studioetrange/docker-sickrage/

_update.sh_ update and add new sickrage versions managed through this github repository, but you can use it only if you have owner access to this docker registry. 
