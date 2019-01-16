# NOTE : not maintained : use https://github.com/StudioEtrange/docker-medusa instead

# docker sickrage by StudioEtrange

* Run sickrage inside a docker container built upon debian
* Based on sickrage github source code
* Choice of sickrage version
* Use supervisor to manage sickrage process
* By default sickrage configuration files will be in a /data/sickrage _(You should map a docker volume to /data)_


## Sample Usage

for running latest version of sickrage :

	docker run -d -v $(pwd):/data -p 8081:8081 studioetrange/docker-sickrage:latest

then go to http://localhost:8081

It will pull lastest version from docker hub registry.

## Docker tags

Available tag for studioetrange/docker-sickrage:__TAG__

	latest, 4.0.22, 4.0.19

Current latest tag is version __4.0.22__

## Instruction

### build from github repository

	git pull https://github.com/StudioEtrange/docker-sickrage
	cd docker-sickrage
	docker build -t="studioetrange/docker-sickrage" .

### retrieve image from docker registry

	docker pull studioetrange/docker-sickrage

### run sickrage 
	
	docker run -v DATA_DIR:/data -p SICKRAGE_HTTP_PORT:8081 -p SUPERVISOR_HTTP_WEB:9999 studioetrange/docker-sickrage:SICKRAGE_VERSION

### run sickrage daemonized

	docker run -d -v DATA_DIR:/data -p SICKRAGE_HTTP_PORT:8081 -p SUPERVISOR_HTTP_WEB:9999 studioetrange/docker-sickrage:SICKRAGE_VERSION

### run a shell inside this container (without sickrage running)

	docker run -i -t studioetrange/docker-sickrage bash

## Access points

### sickrage

	http://localhost:SICKRAGE_HTTP_PORT/

### supervisor

	http://localhost:SUPERVISOR_HTTP_WEB/

## Notes on Github / Docker Hub Repository

* This github repository is linked to an automated build in docker hub registry.

	https://hub.docker.com/r/studioetrange/docker-sickrage/

* _update.sh_ is only an admin script which update and add new versions. This script do not auto create missing tag in docker hub webui. It is only for admin/owner purpose.
