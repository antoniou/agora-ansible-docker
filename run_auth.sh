#!/bin/bash

vagrant up --no-provision && vagrant provision &
vagrant rsync-auto
