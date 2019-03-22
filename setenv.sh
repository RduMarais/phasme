#!/bin/bash

sudo apt-get upgrade nodejs

#npm : node modules manager
sudo apt-get install npm

# install truffle
# romain : j'ai eu des problèmes de permissions donc go sudo
sudo npm install -g truffle

# install ganache, a personal blockchain for dev purposes
npm install -g ganache-cli

# à la fin, on peut le remplacer par une blockchain en GUI, avec :
# git clone https://github.com/trufflesuite/ganache.git
# npm install
# npm start

truffle init

rm ./contracts/Migrations.sol
wget https://raw.githubusercontent.com/RduMarais/Roulette.sol/master/Roulette.sol -O ./contracts/Roulette.sol

# compile
truffle compile --network http://127.0.0.1:9545/

# setup truffle-config.js

# start client
truffle develop
# start truffle develop