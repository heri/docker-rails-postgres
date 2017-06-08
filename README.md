# Rails(+ Nginx, Unicorn) Dockerfile

Docker based on digitalocean config:

* unicorn, nginx, foreman, imagemagick, postgres

# Usage

* Install docker 

* Add file `nginx-sites.conf` and `unicorn.rb` to your app

* Create `Dockerfile` in project root :

```
# Dockerfile
FROM heri/docker-rails-postgres:v1.0
MAINTAINER heri(heri@studiozenkai.com)
# Rails App directory
WORKDIR /app

# Add default unicorn config
ADD unicorn.rb /app/config/unicorn.rb

# Add default foreman config
ADD Procfile /app/Procfile

RUN apt-get update
RUN apt-get -qq -y install libmagickwand-dev imagemagick

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --force-yes libpq-dev

#(required) Install Rails App
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --without development test
ADD . /app

#(required) nginx port number
EXPOSE 80

ENV RAILS_ENV production

CMD bundle exec rake assets:precompile && foreman start -f Procfile
```

* Do not forget to add `unicorn` gem in your project 

## Build and run docker

```
# build your dockerfile
$ docker build -t your/project .

# run container
$ docker run -d -p 80:80 -e SECRET_KEY_BASE=secretkey your/project
```

# Log check using docker logs

Add below line to `config/environments/production.rb`

`config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))`

# Customize Nginx, Unicorn, foreman config

## Nginx

```
# your Dockerfile
...
ADD config/your-custom-nginx.conf /etc/nginx/sites-enabled/default
...
```

## Unicorn

place your unicorn config in `config/unicorn.rb`

## foreman

place your Procfile in app root