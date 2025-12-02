#!/bin/bash

# Script de nettoyage complet pour résoudre les problèmes de conteneurs corrompus
# Usage: ./clean-all.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Nettoyage Complet Docker ===${NC}\n"

# Fonction pour demander confirmation
confirm() {
    read -p "$(echo -e ${YELLOW}$1 ${NC}[y/N]) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Annulé.${NC}"
        exit 1
    fi
}

# Avertissement
echo -e "${YELLOW}ATTENTION: Cette opération va:${NC}"
echo "  - Arrêter tous les conteneurs ai-agent"
echo "  - Supprimer tous les conteneurs ai-agent"
echo "  - Supprimer les réseaux ai-agent"
echo "  - Supprimer les images ai-agent"
echo ""
echo -e "${RED}Les modèles Ollama seront CONSERVÉS dans le volume.${NC}"
echo ""

confirm "Voulez-vous continuer?"

echo ""
echo -e "${BLUE}[1/6]${NC} Arrêt de tous les conteneurs ai-agent..."
docker stop ai-agent-ollama ai-agent-ollama-setup ai-agent-app 2>/dev/null || true

echo -e "${BLUE}[2/6]${NC} Suppression des conteneurs ai-agent..."
docker rm -f ai-agent-ollama ai-agent-ollama-setup ai-agent-app 2>/dev/null || true

echo -e "${BLUE}[3/6]${NC} Suppression des conteneurs orphelins..."
docker container prune -f

echo -e "${BLUE}[4/6]${NC} Suppression du réseau ai-agent..."
docker network rm ai-agent-network 2>/dev/null || true

echo -e "${BLUE}[5/6]${NC} Suppression de l'image ai-agent-app..."
docker rmi ai-coding-agent-app 2>/dev/null || true
docker rmi ai-coding-agent_app 2>/dev/null || true

echo -e "${BLUE}[6/6]${NC} Nettoyage des images intermédiaires..."
docker image prune -f

echo ""
echo -e "${GREEN}✓ Nettoyage terminé avec succès!${NC}"
echo ""
echo -e "${BLUE}Vous pouvez maintenant redémarrer:${NC}"
echo -e "  ${GREEN}./start.sh${NC}"
echo ""
echo -e "${YELLOW}Note:${NC} Le volume ollama_data contenant vos modèles a été conservé."
echo "Pour supprimer aussi les modèles: ${RED}docker volume rm ai-coding-agent_ollama_data${NC}"
