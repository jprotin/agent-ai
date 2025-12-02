#!/bin/bash

# Helper pour détecter la commande docker-compose correcte
# Source ce fichier dans vos scripts: source ./docker-compose-wrapper.sh

if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
elif docker compose version &> /dev/null 2>&1; then
    DOCKER_COMPOSE="docker compose"
else
    echo "Erreur: ni 'docker-compose' ni 'docker compose' n'est disponible"
    exit 1
fi

export DOCKER_COMPOSE
