FROM ubuntu:16.04
MAINTAINER Heri Rakotomalala <heri@studiozenkai.com>

RUN apt-get update

# Install ruby dependencies
RUN apt-get install -y wget curl \
    build-essential git git-core \
    zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev


# Install ruby-install
RUN cd /tmp &&\
  wget -O ruby-install-0.6.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.6.0.tar.gz &&\
  tar -xzvf ruby-install-0.6.0.tar.gz &&\
  cd ruby-install-0.6.0/ &&\
  make install

# Install MRI Ruby
RUN ruby-install ruby 2.4.0

# Add Ruby binaries to $PATH
ENV PATH /opt/rubies/ruby-2.4.0/bin:$PATH

# Add options to gemrc
RUN echo "install: --no-document\nupdate: --no-document" > ~/.gemrc

# Install bundler
RUN gem install bundler

RUN apt-get update

# Install nodejs
RUN apt-get install -qq -y nodejs

# Intall software-properties-common for add-apt-repository
RUN apt-get install -qq -y software-properties-common

# Install Nginx.
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN apt-get install -o Dpkg::Options::=--force-confdef -y nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN chown -R www-data:www-data /var/lib/nginx

# Add default nginx config
ADD nginx-sites.conf /etc/nginx/sites-enabled/default

# Install foreman
RUN gem install foreman