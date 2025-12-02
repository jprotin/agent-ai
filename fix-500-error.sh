#!/bin/bash
# Script de diagnostic et correction complète

set -e

echo "═══════════════════════════════════════════════════════════════"
echo "    DIAGNOSTIC ET CORRECTION DE L'ERREUR 500"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "📋 ÉTAPE 1: Vérification des modèles installés"
echo "─────────────────────────────────────────────────────────────"
echo ""
echo "Modèles actuellement installés dans Ollama:"
docker exec ai-agent-ollama ollama list
echo ""

# Demander quel modèle installer si aucun n'est présent
MODEL_COUNT=$(docker exec ai-agent-ollama ollama list | tail -n +2 | wc -l)
if [ "$MODEL_COUNT" -eq 0 ]; then
    echo -e "${RED}❌ Aucun modèle installé !${NC}"
    echo ""
    echo "Installation automatique de qwen2.5-coder:1.5b..."
    docker exec ai-agent-ollama ollama pull qwen2.5-coder:1.5b
    echo -e "${GREEN}✓ Modèle installé${NC}"
    echo ""
else
    echo -e "${GREEN}✓ Modèles trouvés${NC}"
    echo ""
fi

echo "═══════════════════════════════════════════════════════════════"
echo "📋 ÉTAPE 2: Vérification de la configuration actuelle"
echo "─────────────────────────────────────────────────────────────"
echo ""

# Vérifier quelle version de l'app est en cours d'exécution
echo "Logs de démarrage de l'application (recherche du modèle utilisé):"
docker logs ai-agent-app 2>&1 | grep -A 3 "OllamaService] Initialized" | tail -20
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo "📋 ÉTAPE 3: Reconstruction de l'application"
echo "─────────────────────────────────────────────────────────────"
echo ""

read -p "Voulez-vous reconstruire l'application avec la nouvelle configuration? (o/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Oo]$ ]]; then
    echo "🔨 Arrêt des conteneurs..."
    docker compose down
    echo ""

    echo "🔨 Reconstruction de l'image (cela peut prendre 2-3 minutes)..."
    docker compose build --no-cache app
    echo ""

    echo "🚀 Redémarrage des services..."
    docker compose up -d
    echo ""

    echo "⏳ Attente du démarrage de l'application (30 secondes)..."
    sleep 30
    echo ""

    echo "═══════════════════════════════════════════════════════════════"
    echo "📋 ÉTAPE 4: Vérification après reconstruction"
    echo "─────────────────────────────────────────────────────────────"
    echo ""

    echo "Nouveau modèle utilisé par l'application:"
    docker logs ai-agent-app 2>&1 | grep -A 3 "OllamaService] Initialized" | tail -4
    echo ""

    echo "Test de l'API chat:"
    RESPONSE=$(docker exec ai-agent-ollama curl -s http://localhost:11434/api/chat -d '{
      "model": "qwen2.5-coder:1.5b",
      "messages": [{"role": "user", "content": "Hello"}],
      "stream": false
    }' 2>&1)

    if echo "$RESPONSE" | grep -q "requires more system memory"; then
        echo -e "${RED}❌ Erreur: Mémoire insuffisante${NC}"
        echo ""
        echo "Le modèle nécessite plus de RAM que disponible."
        echo "Essayez un modèle plus léger:"
        echo "  docker exec ai-agent-ollama ollama pull tinyllama"
        echo ""
    elif echo "$RESPONSE" | grep -q "error"; then
        echo -e "${RED}❌ Erreur lors du test${NC}"
        echo "$RESPONSE"
        echo ""
    else
        echo -e "${GREEN}✓ API chat fonctionne !${NC}"
        echo ""
    fi

    echo "═══════════════════════════════════════════════════════════════"
    echo "📋 RÉSUMÉ"
    echo "─────────────────────────────────────────────────────────────"
    echo ""

    # Vérifier l'état final
    if docker logs ai-agent-app 2>&1 | tail -50 | grep -q "qwen2.5-coder:1.5b"; then
        echo -e "${GREEN}✓ Application reconstruite avec succès${NC}"
        echo -e "${GREEN}✓ Modèle par défaut: qwen2.5-coder:1.5b${NC}"
        echo ""
        echo "🎉 Testez maintenant sur http://localhost:3000"
        echo ""
        echo "Si l'erreur 500 persiste:"
        echo "  1. Vérifiez les logs: docker compose logs -f app"
        echo "  2. Vérifiez la console du navigateur (F12)"
        echo "  3. Essayez de sélectionner manuellement le modèle dans l'interface"
    else
        echo -e "${YELLOW}⚠️  La reconstruction s'est terminée mais le modèle par défaut n'est pas confirmé${NC}"
        echo ""
        echo "Vérifiez les logs complets:"
        echo "  docker compose logs app | tail -100"
    fi
else
    echo "Reconstruction annulée."
    echo ""
    echo "SOLUTION ALTERNATIVE:"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo "Si vous ne voulez pas reconstruire, essayez de:"
    echo "1. Ouvrir http://localhost:3000"
    echo "2. Chercher le sélecteur de modèle à côté de 'Connecté à Ollama'"
    echo "3. Sélectionner 'qwen2.5-coder:1.5b' manuellement"
    echo "4. Essayer d'uploader une spécification"
    echo ""
    echo "Ou utilisez les variables d'environnement:"
    echo "  docker compose down"
    echo "  # Éditez docker-compose.yml et vérifiez:"
    echo "  #   - OLLAMA_MODEL=qwen2.5-coder:1.5b"
    echo "  docker compose up -d"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "Pour plus d'aide, consultez:"
echo "  - MEMORY-REQUIREMENTS.md"
echo "  - FIXING-404-ERROR.md"
echo "═══════════════════════════════════════════════════════════════"
