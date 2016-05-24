FROM ubuntu:trusty
MAINTAINER Ammar Askar <ammar@yelp.com>

RUN apt-get update
RUN apt-get -y install build-essential git libboost-dev libboost-test-dev libboost-program-options-dev libboost-system-dev libboost-filesystem-dev libevent-dev automake libtool flex bison pkg-config g++ libssl-dev golang
