FROM ev3dev/ev3dev-stretch-ev3-generic

# copy qemu & scripts to the container
#COPY qemu-arm-static /usr/bin/qemu-arm-static
COPY java-wrapper mktest.sh /opt/jdktest/

# Use this when there is a need for input during docker image building process
ENV DEBIAN_FRONTEND noninteractive

# Install required OS and testing tools
RUN [ "/bin/sh", "-c", "apt-get update && apt-get install -qq -y --no-install-recommends apt-utils build-essential git ant ant-contrib && rm -rf /var/lib/apt/lists/*"]

# Install Perl modules for test framework
RUN [ "/bin/sh", "-c", "echo yes | cpan install JSON Text::CSV" ]

CMD [ "/bin/bash", "/opt/jdktest/mktest.sh" ]
