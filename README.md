positive
========

PositiveBid on Rails


# postgres install instructions
brew install postgresql
psql postgres
  create reloe positive;
  alter role positive login createdb;


# app install instructions
bundle install

rake db:create
rake db:setup


