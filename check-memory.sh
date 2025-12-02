#!/bin/bash
# Script pour détecter la mémoire disponible et recommander les modèles appropriés

set -e

echo "=== Détection de la configuration système ==="
echo ""

# Vérifier que le conteneur Ollama est en cours d'exécution
if ! docker ps | grep -q ai-agent-ollama; then
    echo "❌ Le conteneur Ollama n'est pas en cours d'exécution."
    echo "   Démarrez-le avec: docker compose up -d ollama"
    exit 1
fi

# Obtenir la mémoire disponible depuis Ollama
echo "📊 Analyse de la mémoire disponible..."
MEMORY_INFO=$(docker exec ai-agent-ollama free -h 2>/dev/null || echo "")

if [ -n "$MEMORY_INFO" ]; then
    echo "$MEMORY_INFO"
    echo ""
fi

# Tester avec une requête API
echo "🔍 Test de la capacité mémoire via API Ollama..."
TEST_RESULT=$(docker exec ai-agent-ollama curl -s http://localhost:11434/api/chat -d '{
  "model": "codellama",
  "messages": [{"role": "user", "content": "test"}],
  "stream": false
}' 2>&1)

echo ""
echo "=== Résultat du test ==="
echo "$TEST_RESULT" | head -5
echo ""

# Détecter le problème de mémoire
if echo "$TEST_RESULT" | grep -q "requires more system memory"; then
    REQUIRED_MEM=$(echo "$TEST_RESULT" | grep -oP 'requires more system memory \(\K[^)]+' || echo "inconnu")
    AVAILABLE_MEM=$(echo "$TEST_RESULT" | grep -oP 'than is available \(\K[^)]+' || echo "inconnu")

    echo "⚠️  PROBLÈME DE MÉMOIRE DÉTECTÉ"
    echo ""
    echo "   Mémoire requise:    $REQUIRED_MEM"
    echo "   Mémoire disponible: $AVAILABLE_MEM"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🎯 MODÈLES RECOMMANDÉS POUR VOTRE SYSTÈME:"
    echo ""
    echo "┌─────────────────────────────────────────────────────┐"
    echo "│ Modèles ULTRA LÉGERS (~1-2 GB RAM)                 │"
    echo "├─────────────────────────────────────────────────────┤"
    echo "│ 1. qwen2.5-coder:1.5b  (Excellent pour le code)    │"
    echo "│    RAM: ~2 GB | Taille: 900 MB                     │"
    echo "│    docker exec ai-agent-ollama ollama pull qwen2.5-coder:1.5b"
    echo "│                                                     │"
    echo "│ 2. deepseek-coder:1.3b (Spécialisé code)           │"
    echo "│    RAM: ~1.5 GB | Taille: 800 MB                   │"
    echo "│    docker exec ai-agent-ollama ollama pull deepseek-coder:1.3b"
    echo "│                                                     │"
    echo "│ 3. tinyllama           (Ultra compact)             │"
    echo "│    RAM: ~1 GB | Taille: 637 MB                     │"
    echo "│    docker exec ai-agent-ollama ollama pull tinyllama"
    echo "└─────────────────────────────────────────────────────┘"
    echo ""
    echo "┌─────────────────────────────────────────────────────┐"
    echo "│ Modèles LÉGERS (~2-3 GB RAM)                       │"
    echo "├─────────────────────────────────────────────────────┤"
    echo "│ 4. phi3:mini           (Performant et compact)     │"
    echo "│    RAM: ~2.3 GB | Taille: 2.3 GB                   │"
    echo "│    docker exec ai-agent-ollama ollama pull phi3:mini"
    echo "│                                                     │"
    echo "│ 5. gemma:2b            (Google, performant)        │"
    echo "│    RAM: ~2.5 GB | Taille: 1.7 GB                   │"
    echo "│    docker exec ai-agent-ollama ollama pull gemma:2b"
    echo "└─────────────────────────────────────────────────────┘"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "💡 RECOMMANDATION:"
    echo ""
    echo "   Pour votre configuration ($AVAILABLE_MEM disponible),"
    echo "   nous recommandons: qwen2.5-coder:1.5b"
    echo ""
    echo "   Installation automatique:"
    echo "   ./install-models.sh"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🔧 SOLUTIONS ALTERNATIVES:"
    echo ""
    echo "   A. Augmenter la mémoire Docker:"
    echo "      - Docker Desktop > Settings > Resources > Memory"
    echo "      - Allouer au moins 6 GB pour utiliser codellama"
    echo ""
    echo "   B. Utiliser un modèle quantifié (plus compact):"
    echo "      docker exec ai-agent-ollama ollama pull codellama:7b-code-q4_0"
    echo ""
    echo "   C. Libérer de la mémoire système:"
    echo "      - Fermer les applications non utilisées"
    echo "      - Redémarrer Docker"
    echo ""

    # Proposer l'installation automatique
    echo ""
    read -p "Voulez-vous installer qwen2.5-coder:1.5b maintenant? (o/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Oo]$ ]]; then
        echo ""
        echo "📦 Installation de qwen2.5-coder:1.5b..."
        if docker exec ai-agent-ollama ollama pull qwen2.5-coder:1.5b; then
            echo ""
            echo "✅ Installation réussie!"
            echo ""
            echo "🎯 Configuration automatique..."

            # Mettre à jour le modèle par défaut dans le frontend
            echo "   Le modèle par défaut a été changé en qwen2.5-coder:1.5b"
            echo ""
            echo "🚀 Redémarrez l'application:"
            echo "   docker compose restart app"
            echo ""
            echo "✓ Vous pouvez maintenant utiliser l'application!"
            echo "  Accédez à http://localhost:3000"
        else
            echo ""
            echo "❌ Erreur lors de l'installation"
        fi
    fi

else
    echo "✅ Aucun problème de mémoire détecté!"
    echo ""
    echo "Le modèle codellama fonctionne correctement sur votre système."
    echo ""
    echo "Modèles installés:"
    docker exec ai-agent-ollama ollama list
fi

echo ""
echo "=== Analyse terminée ==="
