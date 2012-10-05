positive
========

PositiveBid on Rails


# postgres install instructions
brew install postgresql
psql postgres
  create role positive;
  alter role positive login createdb;

# 
brew install imagemagick


# app install instructions
bundle install

rake db:create
rake db:setup

# NoDevent

## install
brew install redis
npm install -g nodevent

## start
./script/rails s
npm start -g nodevent

