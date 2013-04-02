positive
========

PositiveBid on Rails

Developed with support from Nesta http://www.nesta.org.uk/ 
and the Cabinet Office.

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

# Auction and Lot Model State Machine

The Auction and Lot models use the state_machine gem https://github.com/pluginaweek/state_machine

The graphical diagram of the states can be updated by running 

  rake state_machine:draw CLASS=Lot,Auction

also maybe "brew install graphviz"

# Start
./script/rails s
npm start -g nodevent

# go to homepage  ( local.host set to 127.0.0.1 in /etc/hosts )
open http://local.host:3000/   # for twitter login
open http://localhost:3000/    # for google login

