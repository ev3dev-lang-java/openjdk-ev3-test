FROM ev3dev/ev3dev-stretch-ev3-generic

# Use this when there is a need for input during docker image building process
ENV DEBIAN_FRONTEND noninteractive

# Install required OS and testing tools
RUN apt-get update \
  && apt-get install -qq -y --no-install-recommends \
    apt-utils \
    build-essential \
    git \
    ant \
    ant-contrib \
  && rm -rf /var/lib/apt/lists/*

# Install Perl modules for test framework
RUN echo yes | cpan install JSON Text::CSV

# Shell script to automate test execution
COPY ./mktest.sh /mktest.sh

CMD /bin/bash /mktest.sh
