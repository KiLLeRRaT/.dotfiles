#!/usr/bin/env bash

op inject -i docker-compose.yml.op-inject | sudo docker compose -f - up
