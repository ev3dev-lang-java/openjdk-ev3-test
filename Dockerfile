FROM ev3dev/ev3dev-stretch-ev3-generic

# copy qemu & scripts to the container
COPY java-wrapper mktest.sh /opt/jdktest/

# Use this when there is a need for input during docker image building process
ENV DEBIAN_FRONTEND noninteractive

# Install required OS and testing tools
RUN apt-get update && \
    apt-get install -qq -y --no-install-recommends \
      apt-utils build-essential git ant ant-contrib libtext-csv-perl libjson-perl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#CMD [ "/bin/bash", "/opt/jdktest/mktest.sh" ]
RUN ["chmod", "+x", "/opt/jdktest/mktest.sh"]
