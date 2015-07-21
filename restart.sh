#!/bin/bash

rm -rf logs/*
rm -rf keys/*
rm -rf certs/*
rm -rf tests/*
vagrant ssh -c 'sudo -u eorchestra psql -c "delete from authority ; delete from session; delete from election;delete from message; delete from query_queue;  delete from task;"'
vagrant provision

while true;
do
  tail -f logs/*
  sleep 2
done

