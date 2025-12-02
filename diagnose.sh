#!/bin/bash

# Script de diagnostic pour vérifier que tout fonctionne
# Usage: ./diagnose.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Diagnostic de l'Agent IA ===${NC}\n"

# 1. Vérifier les conteneurs
echo -e "${BLUE}[1/7] Conteneurs Docker${NC}"
OLLAMA_RUNNING=$(docker ps --filter "name=ai-agent-ollama" --filter "status=running" --format "{{.Names}}" | wc -l)
APP_RUNNING=$(docker ps --filter "name=ai-agent-app" --filter "status=running" --format "{{.Names}}" | wc -l)

if [ "$OLLAMA_RUNNING" -eq 1 ]; then
    echo -e "  ${GREEN}✓${NC} Ollama est en cours d'exécution"
else
    echo -e "  ${RED}✗${NC} Ollama n'est pas en cours d'exécution"
    docker ps -a | grep ai-agent-ollama
fi

if [ "$APP_RUNNING" -eq 1 ]; then
    echo -e "  ${GREEN}✓${NC} App est en cours d'exécution"
else
    echo -e "  ${RED}✗${NC} App n'est pas en cours d'exécution"
    docker ps -a | grep ai-agent-app
fi

echo ""

# 2. Tester Ollama depuis l'hôte
echo -e "${BLUE}[2/7] Connectivité Ollama depuis l'hôte${NC}"
if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo -e "  ${GREEN}✓${NC} Ollama répond sur http://localhost:11434"
else
    echo -e "  ${RED}✗${NC} Ollama ne répond pas sur http://localhost:11434"
fi

echo ""

# 3. Tester Ollama depuis le conteneur app
echo -e "${BLUE}[3/7] Connectivité Ollama depuis le conteneur app${NC}"
if docker exec ai-agent-app wget -q -O- http://ollama:11434/api/tags > /dev/null 2>&1; then
    echo -e "  ${GREEN}✓${NC} App peut contacter Ollama via http://ollama:11434"
else
    echo -e "  ${RED}✗${NC} App ne peut pas contacter Ollama via http://ollama:11434"
    echo -e "  ${YELLOW}Tentative avec localhost...${NC}"
    if docker exec ai-agent-app wget -q -O- http://localhost:11434/api/tags > /dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} App peut contacter Ollama via http://localhost:11434"
        echo -e "  ${YELLOW}⚠${NC} La variable OLLAMA_BASE_URL devrait être http://localhost:11434"
    else
        echo -e "  ${RED}✗${NC} Aucune connectivité Ollama depuis l'app"
    fi
fi

echo ""

# 4. Vérifier les modèles installés
echo -e "${BLUE}[4/7] Modèles Ollama installés${NC}"
MODELS=$(docker exec ai-agent-ollama ollama list 2>/dev/null | tail -n +2 | wc -l)
if [ "$MODELS" -gt 0 ]; then
    echo -e "  ${GREEN}✓${NC} $MODELS modèle(s) installé(s)"
    docker exec ai-agent-ollama ollama list | sed 's/^/  /'
else
    echo -e "  ${RED}✗${NC} Aucun modèle installé"
    echo -e "  ${YELLOW}Pour installer codellama:${NC}"
    echo -e "    docker exec ai-agent-ollama ollama pull codellama"
fi

echo ""

# 5. Tester l'application web
echo -e "${BLUE}[5/7] Application Web${NC}"
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo -e "  ${GREEN}✓${NC} App répond sur http://localhost:3000"
else
    echo -e "  ${RED}✗${NC} App ne répond pas sur http://localhost:3000"
fi

echo ""

# 6. Tester l'API de chat
echo -e "${BLUE}[6/7] API de Chat${NC}"
CHECK_RESULT=$(curl -s http://localhost:3000/api/chat?action=check)
if echo "$CHECK_RESULT" | grep -q '"connected":true'; then
    echo -e "  ${GREEN}✓${NC} API de chat peut contacter Ollama"
elif echo "$CHECK_RESULT" | grep -q '"connected":false'; then
    echo -e "  ${RED}✗${NC} API de chat ne peut pas contacter Ollama"
    echo -e "  ${YELLOW}Réponse:${NC} $CHECK_RESULT"
else
    echo -e "  ${RED}✗${NC} Erreur lors du test de l'API"
    echo -e "  ${YELLOW}Réponse:${NC} $CHECK_RESULT"
fi

echo ""

# 7. Vérifier les logs récents
echo -e "${BLUE}[7/7] Logs récents (dernières erreurs)${NC}"
echo -e "${YELLOW}Logs Ollama:${NC}"
docker logs ai-agent-ollama --tail 5 2>&1 | sed 's/^/  /'

echo -e "\n${YELLOW}Logs App:${NC}"
docker logs ai-agent-app --tail 10 2>&1 | grep -i error | sed 's/^/  /' || echo -e "  ${GREEN}Aucune erreur récente${NC}"

echo ""
echo -e "${BLUE}=== Résumé ===${NC}"

# Calcul du score
SCORE=0
[ "$OLLAMA_RUNNING" -eq 1 ] && ((SCORE++))
[ "$APP_RUNNING" -eq 1 ] && ((SCORE++))
curl -s http://localhost:11434/api/tags > /dev/null 2>&1 && ((SCORE++))
docker exec ai-agent-app wget -q -O- http://ollama:11434/api/tags > /dev/null 2>&1 && ((SCORE++))
[ "$MODELS" -gt 0 ] && ((SCORE++))
curl -s http://localhost:3000 > /dev/null 2>&1 && ((SCORE++))
echo "$CHECK_RESULT" | grep -q '"connected":true' && ((SCORE++))

echo -e "Score: ${SCORE}/7"

if [ "$SCORE" -eq 7 ]; then
    echo -e "${GREEN}✓ Tout fonctionne correctement!${NC}"
    echo -e "\nVous pouvez utiliser l'application sur ${GREEN}http://localhost:3000${NC}"
elif [ "$SCORE" -ge 5 ]; then
    echo -e "${YELLOW}⚠ Quelques problèmes détectés${NC}"
    echo -e "\nConsultez les détails ci-dessus pour résoudre les problèmes."
else
    echo -e "${RED}✗ Plusieurs problèmes détectés${NC}"
    echo -e "\nActions recommandées:"
    [ "$OLLAMA_RUNNING" -eq 0 ] && echo -e "  - Démarrer Ollama: ${YELLOW}./start.sh${NC}"
    [ "$MODELS" -eq 0 ] && echo -e "  - Installer un modèle: ${YELLOW}docker exec ai-agent-ollama ollama pull codellama${NC}"
    echo -e "  - Voir les logs: ${YELLOW}./start.sh logs${NC}"
fi

echo ""
