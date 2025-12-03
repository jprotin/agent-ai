# 🔧 Fix - Erreur 500 sur l'API Chat

## 🔴 Symptôme
```
Failed to load resource: the server responded with a status of 500 (Internal Server Error)
```

Dans le navigateur, l'erreur apparaît lors de l'envoi d'un message dans le chat.

## ✅ Diagnostic (2 minutes)

### Étape 1 : Lancer le Script de Diagnostic

```bash
chmod +x diagnose.sh
./diagnose.sh
```

Ce script va vérifier :
- Les conteneurs sont en cours d'exécution
- Ollama répond sur le port 11434
- L'app peut contacter Ollama
- Les modèles sont installés
- L'API fonctionne

### Étape 2 : Voir les Logs de l'Application

```bash
# Logs en temps réel
docker logs -f ai-agent-app

# Ou via start.sh
./start.sh logs
```

Cherchez des messages comme :
- `Cannot connect to Ollama`
- `ECONNREFUSED`
- `fetch failed`
- `OllamaService`

## 🎯 Solutions par Cause

### Cause 1 : Ollama n'est pas démarré

**Symptôme dans les logs** :
```
[OllamaService] Connection error: fetch failed
```

**Solution** :
```bash
# Vérifier l'état
docker ps | grep ollama

# Si Ollama n'est pas running
./start.sh restart

# Attendre 30 secondes
sleep 30

# Vérifier
curl http://localhost:11434/api/tags
```

### Cause 2 : Aucun Modèle Installé

**Symptôme dans les logs** :
```
model 'codellama' not found
```

**Solution** :
```bash
# Lister les modèles
docker exec ai-agent-ollama ollama list

# Si vide, installer codellama
docker exec ai-agent-ollama ollama pull codellama

# Attendre 5-10 minutes
# Vérifier
docker exec ai-agent-ollama ollama list
```

### Cause 3 : Problème de Réseau Docker

**Symptôme dans les logs** :
```
[OllamaService] Base URL: http://ollama:11434
Connection check result: FAILED
```

**Solution A** : Vérifier la connectivité réseau
```bash
# Depuis le conteneur app, tester Ollama
docker exec ai-agent-app wget -O- http://ollama:11434/api/tags

# Si ça échoue, tester avec localhost
docker exec ai-agent-app wget -O- http://localhost:11434/api/tags
```

**Solution B** : Recréer le réseau
```bash
# Arrêter tout
./start.sh stop

# Supprimer le réseau
docker network rm ai-agent-network

# Redémarrer
./start.sh
```

### Cause 4 : Variable d'Environnement Incorrecte

**Symptôme dans les logs** :
```
[OllamaService] Base URL: http://localhost:11434
OLLAMA_BASE_URL env: undefined
```

**Solution** : Vérifier la configuration
```bash
# Vérifier les variables d'environnement de l'app
docker exec ai-agent-app env | grep OLLAMA

# Devrait afficher :
# OLLAMA_BASE_URL=http://ollama:11434

# Si absent, éditer docker-compose.nohealth.yml
# et vérifier la section environment de app:
#   environment:
#     - OLLAMA_BASE_URL=http://ollama:11434
```

Puis redémarrer :
```bash
./start.sh restart
```

### Cause 5 : Port 11434 Bloqué

**Symptôme** :
```bash
curl http://localhost:11434/api/tags
# curl: (7) Failed to connect to localhost port 11434: Connection refused
```

**Solution** :
```bash
# Vérifier que rien d'autre n'utilise le port
lsof -i :11434
netstat -an | grep 11434

# Voir les logs Ollama
docker logs ai-agent-ollama

# Redémarrer Ollama
docker restart ai-agent-ollama
sleep 20
curl http://localhost:11434/api/tags
```

## 🔍 Tests Manuels

### Test 1 : Ollama depuis l'Hôte

```bash
# Doit retourner la liste des modèles
curl http://localhost:11434/api/tags
```

### Test 2 : Ollama depuis le Conteneur App

```bash
# Doit aussi retourner la liste des modèles
docker exec ai-agent-app wget -O- http://ollama:11434/api/tags
```

### Test 3 : API Check

```bash
# Doit retourner {"connected":true}
curl http://localhost:3000/api/chat?action=check
```

### Test 4 : Envoi d'un Message de Test

```bash
curl -X POST http://localhost:3000/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "user", "content": "Hello"}
    ],
    "model": "codellama"
  }'
```

Si ça retourne une erreur, elle sera plus détaillée dans les logs.

## 🚀 Procédure de Résolution Complète

```bash
# 1. Diagnostic
./diagnose.sh

# 2. Voir les logs en temps réel (dans un autre terminal)
./start.sh logs

# 3. Selon le diagnostic, appliquer la solution correspondante

# 4. Si rien ne fonctionne, redémarrage complet
./start.sh stop
docker network rm ai-agent-network 2>/dev/null
docker rm -f ai-agent-ollama ai-agent-app 2>/dev/null
./start.sh

# 5. Attendre le démarrage complet
sleep 60

# 6. Vérifier à nouveau
./diagnose.sh
```

## 📊 Checklist de Vérification

- [ ] Les conteneurs `ai-agent-ollama` et `ai-agent-app` sont running
- [ ] `curl http://localhost:11434/api/tags` retourne du JSON
- [ ] Au moins un modèle est installé (`docker exec ai-agent-ollama ollama list`)
- [ ] L'app peut contacter Ollama (`docker exec ai-agent-app wget -O- http://ollama:11434/api/tags`)
- [ ] L'API check retourne `{"connected":true}`
- [ ] Pas d'erreur dans les logs (`docker logs ai-agent-app`)

## 🆘 Si Rien ne Fonctionne

### Collecter les Informations

```bash
# Créer un fichier de debug
echo "=== Conteneurs ===" > debug-500.txt
docker ps -a >> debug-500.txt

echo -e "\n=== Logs Ollama ===" >> debug-500.txt
docker logs ai-agent-ollama --tail 50 >> debug-500.txt

echo -e "\n=== Logs App ===" >> debug-500.txt
docker logs ai-agent-app --tail 50 >> debug-500.txt

echo -e "\n=== Test Ollama ===" >> debug-500.txt
curl http://localhost:11434/api/tags >> debug-500.txt 2>&1

echo -e "\n=== Test API ===" >> debug-500.txt
curl http://localhost:3000/api/chat?action=check >> debug-500.txt 2>&1

echo -e "\n=== Variables Env ===" >> debug-500.txt
docker exec ai-agent-app env | grep OLLAMA >> debug-500.txt

cat debug-500.txt
```

### Solution de Dernier Recours

```bash
# Nettoyage TOTAL (supprime aussi les modèles)
docker-compose -f docker-compose.nohealth.yml down -v
docker system prune -a -f

# Redémarrage propre
./start.sh

# Les modèles devront être retéléchargés (~5-10 minutes)
```

## 💡 Prévention

Pour éviter ce problème :

1. **Toujours arrêter proprement** :
   ```bash
   ./start.sh stop
   ```

2. **Attendre le démarrage complet** :
   Après `./start.sh`, attendez 1-2 minutes avant d'utiliser l'app

3. **Vérifier régulièrement** :
   ```bash
   ./diagnose.sh
   ```

## 📚 Documentation Associée

- **diagnose.sh** - Script de diagnostic automatique
- **TROUBLESHOOTING.md** - Guide général de dépannage
- **DOCKER.md** - Configuration Docker

---

**TL;DR** :
```bash
./diagnose.sh          # Diagnostic
./start.sh logs        # Voir les logs
./start.sh restart     # Redémarrer si nécessaire
```
