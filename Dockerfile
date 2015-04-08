MAINTAINER Benjamin Stickel

# Mountable Volumes Defined
VOLUME ["/data"]

# Working Directory
WORKDIR /data

# Expose Ports for Functionality
EXPOSE 9200
EXPOSE 9300
