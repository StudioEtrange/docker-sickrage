# docker sickrage by StudioEtrange

* Run sickrage inside a docker container built upon debian
* Based on sickrage github source code
* Choice of sickrage version
* Use supervisor to manage sickrage process
* By default sickrage configuration files will be in /data/sickrage


## Sample Usage

for running latest version of sickrage :

	docker run -d -v $(pwd):/data -p 8081:8081 studioetrange/docker-sickrage:latest

then go to http://localhost:8081

## Version and Tag

* docker-tag:latest or github-branch:master ==> latest stable sickrage version available through this repository
* docker-tag:X.X.X or github-branch:X.X.X ==> sickrage version X.X.X
* docker-tag:dev or github-branch:dev ==> development version from sickrage git repository

In dev case, to have an uptodate image you should
* build the docker image yourself (see build from github souce below)
* OR launch in the container the script /opt/sickrage-update.sh


## Instruction

### build from github source

	git pull https://github.com/StudioEtrange/docker-sickrage
	cd docker-sickrage
	docker build -t="studioetrange/docker-sickrage"	 .

### retrieve image from docker registry

	docker pull studioetrange/docker-sickrage

### run sickrage 

	docker run -v DATA_DIR:/data -p SICKRAGE_HTTP_PORT:8081 -p SUPERVISOR_HTTP_WEB:9999 studioetrange/docker-sickrage:SICKRAGE_VERSION

### run sickrage daemonized

	docker run -d -v DATA_DIR:/data -p SICKRAGE_HTTP_PORT:8081 -p SUPERVISOR_HTTP_WEB:9999 studioetrange/docker-sickrage:SICKRAGE_VERSION


### run a shell inside this container (without sickrage running)

	docker run -i -t studioetrange/docker-sickrage

## Access point

### sickrage

	http://localhost:SICKRAGE_HTTP_PORT/

### Supervisor

	http://localhost:SUPERVISOR_HTTP_WEB/
