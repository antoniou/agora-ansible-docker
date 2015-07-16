#!/bin/bash
set -x
sleep 10
# Create database if not exists
echo 'Creating database if one does not exist'
python app.py --createdb
sleep 10
