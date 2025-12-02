#!/bin/bash

# Script pour installer rapidement un modèle Ollama
# Usage: ./install-model.sh [nom-du-modele]

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

MODEL=${1:-codellama}

echo -e "${BLUE}=== Installation du modèle $MODEL ===${NC}\n"

# Vérifier qu'Ollama tourne
if ! docker ps | grep -q ai-agent-ollama; then
    echo -e "${RED}✗ Le conteneur Ollama n'est pas en cours d'exécution${NC}"
    echo -e "${YELLOW}Démarrez-le avec: ./start.sh${NC}"
    exit 1
fi

echo -e "${BLUE}Vérification de la connexion à Ollama...${NC}"
if ! docker exec ai-agent-ollama curl -s http://localhost:11434/api/tags > /dev/null; then
    echo -e "${RED}✗ Ollama ne répond pas${NC}"
    echo -e "${YELLOW}Attendez quelques secondes et réessayez${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Ollama est accessible${NC}\n"

echo -e "${BLUE}Téléchargement du modèle $MODEL...${NC}"
echo -e "${YELLOW}Cela peut prendre 5-10 minutes selon votre connexion${NC}"
echo -e "${YELLOW}Taille approximative:${NC}"
case $MODEL in
    codellama)
        echo "  - codellama: ~4 GB"
        ;;
    llama3)
        echo "  - llama3: ~5 GB"
        ;;
    deepseek-coder)
        echo "  - deepseek-coder: ~4 GB"
        ;;
    mistral)
        echo "  - mistral: ~4 GB"
        ;;
    *)
        echo "  - $MODEL: taille variable"
        ;;
esac

echo ""
echo -e "${YELLOW}Ne fermez pas ce terminal pendant le téléchargement${NC}\n"

# Lancer le téléchargement avec affichage en temps réel
docker exec -it ai-agent-ollama ollama pull $MODEL

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ Modèle $MODEL installé avec succès!${NC}\n"
    
    echo -e "${BLUE}Modèles disponibles:${NC}"
    docker exec ai-agent-ollama ollama list
    
    echo ""
    echo -e "${GREEN}Vous pouvez maintenant utiliser l'application!${NC}"
    echo -e "Ouvrez ${BLUE}http://localhost:3000${NC} dans votre navigateur"
else
    echo ""
    echo -e "${RED}✗ Erreur lors de l'installation du modèle${NC}"
    echo -e "${YELLOW}Vérifiez votre connexion internet et réessayez${NC}"
    exit 1
fi
