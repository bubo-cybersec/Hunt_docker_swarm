#!/bin/bash

#this script will install everything that is needed to make the bubo hunt work

## replace max_map_count=262144
sudo echo "vm.max_map_count=262144" > /etc/sysctl.conf
sudo sysctl --system

## install dependencies
sudo apt-get install apt-transport-https ca-certificates curl gnupg software-properties-common lsb-release ssh

## add Docker’s official GPG key:
sudo mkdir -p /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

## add docker repository to apt sources
sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

## install docker, docker-compose
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin