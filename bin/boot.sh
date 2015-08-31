#!/usr/bin/env bash

cd $HOME/app
build_env=${EMBER_ENV:-production}
node_modules/ember-cli/bin/ember build --environment $build_env | indent
cd $HOME

ruby $HOME/config/htpasswd.rb
erb $HOME/config/nginx.conf.erb > $HOME/config/nginx.conf

mkdir -p $HOME/logs/nginx
touch $HOME/logs/nginx/access.log $HOME/logs/nginx/error.log

(tail -f -n 0 $HOME/logs/nginx/*.log &)

exec $HOME/vendor/nginx/sbin/nginx -p $HOME -c $HOME/config/nginx.conf
