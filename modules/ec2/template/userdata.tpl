#!/bin/bash

# Inputs
AWS_TAG="${aws_tag}"
AWS_KEY="${aws_key}"
DATACENTER="${datacenter}"
BIND_ADDR="${bind_addr}"

# Consul config setup
sed -i -e "s/{BIND_ADDR}/$${BIND_ADDR}/g" /etc/consul.d/consul.hcl
sed -i -e "s/{AWS_TAG}/$${AWS_TAG}/g" /etc/consul.d/consul.hcl
sed -i -e "s/{AWS_KEY}/$${AWS_KEY}/g" /etc/consul.d/consul.hcl
sed -i -e "s/{DATACENTER}/$${DATACENTER}/g" /etc/consul.d/consul.hcl

# Starting consul
sudo systemctl enable consul
sudo systemctl start consul

# # Starting redis
# sudo systemctl enable redis-server
# sudo systemctl start redis-server