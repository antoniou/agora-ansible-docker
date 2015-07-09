#!/bin/bash

echo "$PRIVATE_IP_ADDRESS $HOST" | tee -a /etc/hosts
