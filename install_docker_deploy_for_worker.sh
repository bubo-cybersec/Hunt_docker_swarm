#!/bin/bash
## create directories where indices will be store
mkdir hunt_docker_swarm
cd hunt_docker_swarm
mkdir data1
mkdir data2 
mkdir master1
mkdir certs
mkdir logstash_pipeline

echo "ip of manager docker:"
read ip
echo "user with sudoers role:"
read sudoersuser

until [[ -n $ip || -z $sudoersuser || $password ]];
    do
        sleep 5
    done
    
scp -r -v $sudoersuser@$ip:/home/$sudoersuser/hunt_docker_swarm/certs/* /home/$sudoersuser/hunt_docker_swarm/certs/
scp -r -v $sudoersuser@$ip:/home/$sudoersuser/hunt_docker_swarm/logstash_pipeline/* /home/$sudoersuser/hunt_docker_swarm/logstash_pipeline/
scp -r -v $sudoersuser@$ip:/home/$sudoersuser/hunt_docker_swarm/process_ioc.rb  /home/$sudoersuser/hunt_docker_swarm/

echo "docker token give by manager (token + ip:port)"
read token

sudo docker swarm join --token $token