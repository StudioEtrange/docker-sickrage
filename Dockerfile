FROM studioetrange/docker-debian:wheezy
MAINTAINER StudioEtrange <nomorgan@gmail.com>


# DEBIAN packages : SICKRAGE dependencies install ----------
RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
						python-cheetah \
	&& rm -rf /var/lib/apt/lists/*
	

# SICKBEARD install -------------
ENV SICKRAGE_VERSION develop

WORKDIR /opt/sickrage
RUN git clone https://github.com/SiCKRAGETV/SickRage /opt/sickrage && git checkout $SICKRAGE_VERSION

# SICKRAGE update script
COPY sickrage-update.sh /opt/sickrage-update.sh
RUN chmod +x /opt/sickrage-update.sh

# SUPERVISOR -------------
COPY supervisord-sickrage.conf /etc/supervisor/conf.d/supervisord-sickrage.conf

# DOCKER -------------
VOLUME /data

# Supervisord web interface -------
EXPOSE 9999
# sickrage http port
EXPOSE 8081

# run command by default
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]
