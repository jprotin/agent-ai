#!/bin/bash
# Script pour diagnostiquer l'erreur 500

echo "=== Logs du conteneur app ==="
docker compose logs app --tail=100

echo ""
echo "=== Vérification des fichiers dans le conteneur ==="
docker compose exec app ls -la /app/

echo ""
echo "=== Vérification du dossier lib dans le conteneur ==="
docker compose exec app ls -la /app/lib/ 2>/dev/null || echo "Dossier lib/ non trouvé!"

echo ""
echo "=== Vérification de la structure standalone ==="
docker compose exec app find /app -name "ollama*" 2>/dev/null

echo ""
echo "=== Test de connexion à Ollama depuis le conteneur app ==="
docker compose exec app wget -q -O- http://ollama:11434/api/tags 2>/dev/null | head -20 || echo "Impossible de se connecter à Ollama"
