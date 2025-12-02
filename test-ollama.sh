#!/bin/bash
# Script pour tester Ollama et identifier le problème

echo "=== Test de connexion à Ollama ==="
echo ""

echo "1. Test de l'endpoint /api/tags"
curl -s http://localhost:11434/api/tags | jq '.' 2>/dev/null || curl -s http://localhost:11434/api/tags

echo ""
echo ""
echo "2. Liste des modèles installés"
docker exec ai-agent-ollama ollama list

echo ""
echo ""
echo "3. Test de l'endpoint /api/chat avec codellama"
curl -s http://localhost:11434/api/chat -d '{
  "model": "codellama",
  "messages": [
    {
      "role": "user",
      "content": "Hello"
    }
  ],
  "stream": false
}' | jq '.' 2>/dev/null || curl -s http://localhost:11434/api/chat -d '{
  "model": "codellama",
  "messages": [
    {
      "role": "user",
      "content": "Hello"
    }
  ],
  "stream": false
}'

echo ""
echo ""
echo "4. Vérifier si le modèle codellama est bien téléchargé"
docker exec ai-agent-ollama ls -lh /root/.ollama/models/

echo ""
echo ""
echo "5. Tenter de pull le modèle codellama"
docker exec ai-agent-ollama ollama pull codellama

echo ""
echo "=== Test terminé ==="
