## import bubo files 
sudo git clone https://github.com/bubo-cybersec/hunt_docker_swarm
cd hunt_docker_swarm
sudo git clone https://github.com/bubo-cybersec/logstash_pipeline
cd ..
sudo chown -R admin-bubo:admin-bubo hunt_docker_swarm/
cd hunt_docker_swarm

## create directories where indices will be store
sudo mkdir data1
sudo mkdir data2 
sudo mkdir master1

## create certificates and add misp token
sudo chmod +x generation_certs.sh
./generation_certs.sh

sudo chown -R admin-bubo:admin-bubo *

## init of docker swarm cluster
ip=$(hostname -I | grep -Eo '^([0-9]{1,3}[\.]){3}[0-9]{1,3}')

sudo docker swarm init --advertise-addr $ip