FROM alpine

ARG server_dir=/opt/minecraft
ARG exec_user=kevin

# Minecraft Port
EXPOSE 25565

# Install required packages and create group and user
USER root
RUN apk --update add bash screen util-linux openjdk17-jre \
	&& addgroup -g 1000 ${exec_user} \
	&& adduser -H -D -G ${exec_user} -u 1000 ${exec_user} \
	&& mkdir -p ${server_dir} \
	&& chown ${exec_user}:${exec_user} ${server_dir}
# add launcher script
COPY launch.sh /usr/local/bin/launch.sh
COPY install.sh /usr/local/bin/install.sh


# Mountpoints: Settings files and Minecraft directory
VOLUME ["/opt/minecraft:${server_dir}"]

# exec program
USER ${exec_user}
WORKDIR ${server_dir}
STOPSIGNAL TERM

RUN pwd
RUN ls -lah
RUN whoami

ENTRYPOINT ["/usr/local/bin/launch.sh"]
