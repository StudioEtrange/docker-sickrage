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

## Available docker tag

	latest, 4.0.22, 4.0.19

Available tag for studioetrange/docker-sickrage:TAG

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

## Access points

### sickrage

	http://localhost:SICKRAGE_HTTP_PORT/

### Supervisor

	http://localhost:SUPERVISOR_HTTP_WEB/

## Notes on Github / Docker Hub Repository

* This github repository is linked to an automated build in docker hub registry.

	https://registry.hub.docker.com/u/studioetrange/docker-sickrage/

* _update.sh_ is an admin script which update and add new sickrage versions. This script do not auto create missing tag in docker hub webui. It is only for admin/owner purpose.
