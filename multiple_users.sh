#! /bin/bash

for i in {1..20}
do 
        curl $(minikube ip):$NODE_PORT
done 

