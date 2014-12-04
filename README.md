# docker sickrage by StudioEtrange

* Run sickrage inside a docker container built upon debian
* Based on sickrage github source code
* Choice of sickrage version
* Use supervisor to manage sickrage process
* By default sickrage configuration files will be in /data/sickrage


## Sample Usage

for running latest dev version of sickrage :

	docker run -d -v $(pwd):/data -p 8081:8081 studioetrange/docker-sickrage

for running sickrage v3.3.3 :

	docker run -d -v $(pwd):/data -p 8081:8081 studioetrange/docker-sickrage:v3.3.3

then go to http://localhost:8081

## Version and Tag

* Each tag is a different version of sickrage
* latest is the development version from sickrage git repository. But you should build the image yourself OR use /opt/sickrage-update.sh to have an uptodate image.

## Instruction

### build from github source

	git pull https://github.com/StudioEtrange/docker-sickrage
	cd docker-sickrage
	docker build -t=studioetrange/docker-sickrage .

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

	Go to http://localhost:SICKRAGE_HTTP_PORT/

### Supervisor

	Go to http://localhost:SUPERVISOR_HTTP_WEB/
