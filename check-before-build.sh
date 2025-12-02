#!/bin/bash

# Script de vérification avant le build Docker
# Usage: ./check-before-build.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Vérification pré-build ===${NC}\n"

# Vérifier Docker
echo -ne "Vérification de Docker... "
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker n'est pas installé${NC}"
    exit 1
else
    echo -e "${GREEN}✓${NC}"
fi

# Vérifier Docker Compose
echo -ne "Vérification de Docker Compose... "
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}✗ Docker Compose n'est pas installé${NC}"
    exit 1
else
    echo -e "${GREEN}✓${NC}"
fi

# Vérifier que Docker est démarré
echo -ne "Vérification que Docker est démarré... "
if ! docker info &> /dev/null; then
    echo -e "${RED}✗ Docker n'est pas démarré${NC}"
    echo -e "${YELLOW}Démarrez Docker Desktop ou lancez 'sudo systemctl start docker'${NC}"
    exit 1
else
    echo -e "${GREEN}✓${NC}"
fi

# Vérifier les fichiers nécessaires
echo -ne "Vérification de package.json... "
if [ ! -f "package.json" ]; then
    echo -e "${RED}✗ Fichier manquant${NC}"
    exit 1
else
    echo -e "${GREEN}✓${NC}"
fi

# Vérifier/Créer package-lock.json
echo -ne "Vérification de package-lock.json... "
if [ ! -f "package-lock.json" ]; then
    echo -e "${YELLOW}✗ Fichier manquant, génération...${NC}"
    npm install --package-lock-only
    if [ -f "package-lock.json" ]; then
        echo -e "  ${GREEN}✓ package-lock.json généré${NC}"
    else
        echo -e "  ${RED}✗ Échec de la génération${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓${NC}"
fi

# Vérifier Dockerfile
echo -ne "Vérification du Dockerfile... "
if [ ! -f "Dockerfile" ]; then
    echo -e "${RED}✗ Fichier manquant${NC}"
    exit 1
else
    echo -e "${GREEN}✓${NC}"
fi

# Vérifier docker-compose.yml
echo -ne "Vérification de docker-compose.yml... "
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}✗ Fichier manquant${NC}"
    exit 1
else
    echo -e "${GREEN}✓${NC}"
fi

# Vérifier le répertoire output
echo -ne "Vérification du répertoire output... "
if [ ! -d "output" ]; then
    echo -e "${YELLOW}✗ Répertoire manquant, création...${NC}"
    mkdir -p output
    echo -e "  ${GREEN}✓ Répertoire créé${NC}"
else
    echo -e "${GREEN}✓${NC}"
fi

# Vérifier l'espace disque disponible
echo -ne "Vérification de l'espace disque... "
AVAILABLE_SPACE=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
if [ "$AVAILABLE_SPACE" -lt 10 ]; then
    echo -e "${YELLOW}⚠ Espace faible (${AVAILABLE_SPACE}GB)${NC}"
    echo -e "  ${YELLOW}Au moins 10GB recommandés pour les images et modèles${NC}"
else
    echo -e "${GREEN}✓ ${AVAILABLE_SPACE}GB disponible${NC}"
fi

# Vérifier les ports
echo -ne "Vérification du port 3000... "
if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo -e "${YELLOW}⚠ Port déjà utilisé${NC}"
    echo -e "  ${YELLOW}Arrêtez le service qui utilise le port 3000 ou modifiez docker-compose.yml${NC}"
else
    echo -e "${GREEN}✓ Libre${NC}"
fi

echo -ne "Vérification du port 11434... "
if lsof -Pi :11434 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo -e "${YELLOW}⚠ Port déjà utilisé${NC}"
    echo -e "  ${YELLOW}Arrêtez Ollama local ou modifiez docker-compose.yml${NC}"
else
    echo -e "${GREEN}✓ Libre${NC}"
fi

# Vérifier la RAM disponible
echo -ne "Vérification de la RAM disponible... "
if [ "$(uname)" == "Darwin" ]; then
    # macOS
    AVAILABLE_RAM=$(vm_stat | grep "Pages free" | awk '{print int($3 * 4096 / 1024 / 1024 / 1024)}')
elif [ -f /proc/meminfo ]; then
    # Linux
    AVAILABLE_RAM=$(free -g | awk '/^Mem:/{print $7}')
else
    AVAILABLE_RAM="?"
fi

if [ "$AVAILABLE_RAM" != "?" ]; then
    if [ "$AVAILABLE_RAM" -lt 4 ]; then
        echo -e "${YELLOW}⚠ RAM faible (${AVAILABLE_RAM}GB)${NC}"
        echo -e "  ${YELLOW}Au moins 8GB recommandés${NC}"
    else
        echo -e "${GREEN}✓ ${AVAILABLE_RAM}GB disponible${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Impossible de vérifier${NC}"
fi

echo -e "\n${GREEN}=== Toutes les vérifications sont OK! ===${NC}"
echo -e "${BLUE}Vous pouvez lancer: ./start.sh${NC}\n"
