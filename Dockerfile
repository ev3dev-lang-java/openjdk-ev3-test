FROM ev3dev/ev3dev-stretch-ev3-generic

# Add non-root user for QEMU
RUN adduser robot sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Use this when there is a need for input during docker image building process
ENV DEBIAN_FRONTEND noninteractive

# Install required OS and testing tools
RUN apt-get update && \
    apt-get install -qq -y --no-install-recommends \
      make curl apt-utils git ant build-essential ant-contrib libtext-csv-perl libjson-perl sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy qemu & scripts to the container
COPY mktest.sh /opt/jdktest/
RUN chown -R 1000:1000 /opt && \
    chmod -R 777       /opt

# Set startup script
USER robot
CMD [ "/bin/bash", "/opt/jdktest/mktest.sh" ]
