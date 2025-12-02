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
echo "┌─────────────────────────────────────────────────────────────┐"
echo "│                    MODÈLES ULTRA LÉGERS                     │"
echo "│              (Recommandés si < 4 GB RAM disponible)         │"
echo "├─────────────────────────────────────────────────────────────┤"
echo "│ 1. qwen2.5-coder:1.5b  (⭐ RECOMMANDÉ - Code, ~2 GB RAM)   │"
echo "│ 2. deepseek-coder:1.3b (Code spécialisé, ~1.5 GB RAM)      │"
echo "│ 3. tinyllama           (Ultra compact, ~1 GB RAM)          │"
echo "│ 4. phi3:mini           (Performant, ~2.3 GB RAM)           │"
echo "└─────────────────────────────────────────────────────────────┘"
echo ""
echo "┌─────────────────────────────────────────────────────────────┐"
echo "│                    MODÈLES STANDARDS                        │"
echo "│              (Nécessitent >= 6 GB RAM disponible)           │"
echo "├─────────────────────────────────────────────────────────────┤"
echo "│ 5. codellama           (Code général, ~5.5 GB RAM)         │"
echo "│ 6. llama3              (Usage général, ~4.7 GB RAM)        │"
echo "│ 7. qwen2.5-coder       (Excellent code, ~4.7 GB RAM)       │"
echo "│ 8. deepseek-coder      (Code spécialisé, ~3.8 GB RAM)      │"
echo "└─────────────────────────────────────────────────────────────┘"
echo ""
echo "┌─────────────────────────────────────────────────────────────┐"
echo "│                         OPTIONS                             │"
echo "├─────────────────────────────────────────────────────────────┤"
echo "│ 9. Installer tous les modèles ultra légers (1-4)           │"
echo "│ 10. Installer un modèle personnalisé                       │"
echo "│ 0. Quitter                                                  │"
echo "└─────────────────────────────────────────────────────────────┘"
echo ""

read -p "Votre choix (0-10): " choice

case $choice in
    1)
        install_model "qwen2.5-coder:1.5b"
        ;;
    2)
        install_model "deepseek-coder:1.3b"
        ;;
    3)
        install_model "tinyllama"
        ;;
    4)
        install_model "phi3:mini"
        ;;
    5)
        echo "⚠️  Attention: codellama nécessite ~5.5 GB RAM"
        read -p "Continuer? (o/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Oo]$ ]]; then
            install_model "codellama"
        fi
        ;;
    6)
        echo "⚠️  Attention: llama3 nécessite ~4.7 GB RAM"
        read -p "Continuer? (o/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Oo]$ ]]; then
            install_model "llama3"
        fi
        ;;
    7)
        echo "⚠️  Attention: qwen2.5-coder nécessite ~4.7 GB RAM"
        read -p "Continuer? (o/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Oo]$ ]]; then
            install_model "qwen2.5-coder"
        fi
        ;;
    8)
        echo "⚠️  Attention: deepseek-coder nécessite ~3.8 GB RAM"
        read -p "Continuer? (o/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Oo]$ ]]; then
            install_model "deepseek-coder"
        fi
        ;;
    9)
        install_model "qwen2.5-coder:1.5b"
        install_model "deepseek-coder:1.3b"
        install_model "tinyllama"
        install_model "phi3:mini"
        ;;
    10)
        read -p "Nom du modèle: " custom_model
        install_model "$custom_model"
        ;;
    0)
        echo "Installation annulée"
        exit 0
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
