FROM debian:latest

RUN mkdir -p /data


RUN apt-get update
RUN apt-get -y install curl gnupg2 vim zip unzip
#awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-`uname -m`.zip" -o "$TMPDIR/awscliv2.zip"
RUN unzip "$TMPDIR/awscliv2.zip"
RUN "$TMPDIR/aws/install"

RUN echo 'deb http://repo.aptly.info/ squeeze main' | tee /etc/apt/sources.list.d/aptly.list

RUN curl -s https://www.aptly.info/pubkey.txt | gpg --dearmor > /etc/apt/trusted.gpg.d/aptly.gpg
RUN apt-get update
RUN apt-get -y install aptly

WORKDIR /data

ADD *.sh /usr/local/sbin/
ADD aptly-cmd /usr/local/sbin/

# RUN /usr/local/sbin/init_environment.sh