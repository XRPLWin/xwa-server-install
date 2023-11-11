#!/bin/bash

base=/root/deploy

sudo apt update
sudo apt install supervisor
systemctl restart supervisor
