#!/bin/bash
# Script pour installer les modèles Ollama nécessaires

set -e

echo "=== Installation des modèles Ollama ==="
echo ""

# Vérifier que le conteneur Ollama est en cours d'exécution
if ! docker ps | grep -q ai-agent-ollama; then
    echo "❌ Le conteneur Ollama n'est pas en cours d'exécution."
    echo "   Démarrez-le avec: docker compose up -d ollama"
    exit 1
fi

echo "✓ Conteneur Ollama en cours d'exécution"
echo ""

# Attendre qu'Ollama soit prêt
echo "Attente du démarrage d'Ollama..."
for i in {1..30}; do
    if docker exec ai-agent-ollama curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        echo "✓ Ollama est prêt!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ Timeout: Ollama n'a pas démarré dans les temps"
        exit 1
    fi
    echo "  Tentative $i/30..."
    sleep 2
done

echo ""

# Lister les modèles existants
echo "Modèles actuellement installés:"
docker exec ai-agent-ollama ollama list

echo ""
echo "=== Installation des modèles recommandés ==="
echo ""

# Fonction pour installer un modèle
install_model() {
    local model=$1
    echo "📦 Installation du modèle: $model"
    if docker exec ai-agent-ollama ollama pull "$model"; then
        echo "✓ Modèle $model installé avec succès!"
    else
        echo "❌ Erreur lors de l'installation de $model"
        return 1
    fi
    echo ""
}

# Proposer l'installation de différents modèles
echo "Choisissez les modèles à installer:"
echo "1. codellama (recommandé pour le code, ~3.8 GB)"
echo "2. llama3 (modèle général performant, ~4.7 GB)"
echo "3. qwen2.5-coder (excellent pour le code, ~4.7 GB)"
echo "4. deepseek-coder (spécialisé code, ~3.8 GB)"
echo "5. Tous les modèles ci-dessus"
echo "6. Installer un modèle personnalisé"
echo ""

read -p "Votre choix (1-6): " choice

case $choice in
    1)
        install_model "codellama"
        ;;
    2)
        install_model "llama3"
        ;;
    3)
        install_model "qwen2.5-coder"
        ;;
    4)
        install_model "deepseek-coder"
        ;;
    5)
        install_model "codellama"
        install_model "llama3"
        install_model "qwen2.5-coder"
        install_model "deepseek-coder"
        ;;
    6)
        read -p "Nom du modèle: " custom_model
        install_model "$custom_model"
        ;;
    *)
        echo "Choix invalide"
        exit 1
        ;;
esac

echo ""
echo "=== Installation terminée ==="
echo ""
echo "Modèles installés:"
docker exec ai-agent-ollama ollama list

echo ""
echo "✓ Vous pouvez maintenant utiliser l'application!"
echo "  Accédez à http://localhost:3000"
