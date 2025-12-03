# 🏥 Fix - Erreur "Container is unhealthy"

## 🔴 Erreur Complète
```
Creating ai-agent-ollama ... done
ERROR: for ollama-setup  Container "4303abcfde14" is unhealthy.
ERROR: for app  Container "4303abcfde14" is unhealthy.
ERROR: Encountered errors while bringing up the project.
```

## ❓ Cause
Le conteneur Ollama démarre mais le healthcheck échoue, empêchant les autres services de démarrer.

Cela arrive quand :
- Ollama met plus de temps que prévu à démarrer
- Le healthcheck est trop strict
- curl n'est pas disponible dans le conteneur
- Le port 11434 n'est pas prêt assez vite

## ✅ Solution Immédiate (Recommandée)

### Option 1 : Version Sans Healthcheck (Par Défaut)

Le script `start.sh` utilise maintenant automatiquement `docker-compose.nohealth.yml` qui n'a pas de healthcheck :

```bash
# Nettoyer d'abord
docker-compose down -v

# Redémarrer (utilise automatiquement la version sans healthcheck)
./start.sh
```

### Option 2 : Commande Directe

```bash
# Nettoyer
docker-compose down -v

# Utiliser la version sans healthcheck
docker-compose -f docker-compose.nohealth.yml up -d
```

### Option 3 : Attente Manuelle

Si vous voulez utiliser la version avec healthcheck :

```bash
# 1. Démarrer seulement Ollama
docker-compose up -d ollama

# 2. Attendre 30-60 secondes
sleep 60

# 3. Vérifier qu'Ollama est prêt
curl http://localhost:11434/api/tags

# 4. Démarrer le reste
docker-compose up -d
```

## 🔍 Diagnostic

### Vérifier l'état du conteneur Ollama

```bash
# Voir les conteneurs
docker ps -a

# Voir les logs d'Ollama
docker logs ai-agent-ollama

# Vérifier le healthcheck
docker inspect ai-agent-ollama | grep -A 10 Health
```

### Tester manuellement le healthcheck

```bash
# Entrer dans le conteneur
docker exec -it ai-agent-ollama sh

# Tester la commande healthcheck
curl -f http://localhost:11434/api/tags

# Si curl n'existe pas, installer
apk add curl
curl -f http://localhost:11434/api/tags
```

## 📊 Versions Disponibles

| Fichier | Healthcheck | Complexité | Fiabilité |
|---------|-------------|------------|-----------|
| docker-compose.nohealth.yml | ❌ Non | Faible | ⭐⭐⭐⭐⭐ |
| docker-compose.simple.yml | ✅ Oui | Moyenne | ⭐⭐⭐⭐ |
| docker-compose.yml | ✅ Oui | Haute | ⭐⭐⭐ |

**Recommandation** : Utilisez `docker-compose.nohealth.yml` (par défaut avec `./start.sh`)

## 🛠️ Corrections Appliquées

### Dans docker-compose.nohealth.yml

1. **Pas de healthcheck** - Évite complètement le problème
2. **Attente active** - ollama-setup attend activement qu'Ollama réponde
3. **Messages clairs** - Affiche la progression du téléchargement

### Dans docker-compose.simple.yml et docker-compose.yml

1. **Healthcheck amélioré** :
   - `start_period: 60s` au lieu de 40s (plus de temps au démarrage)
   - `retries: 10` au lieu de 3 (plus de tentatives)
   - `interval: 10s` au lieu de 30s (vérifie plus souvent)

2. **Attente active** :
   - Les services attendent activement qu'Ollama réponde
   - Boucle de 30 tentatives avec sleep de 2 secondes
   - Messages de progression

## 🚀 Démarrage Pas à Pas

```bash
# 1. Nettoyer complètement
docker-compose down -v
docker system prune -f

# 2. Vérifier les fichiers
ls -la docker-compose.nohealth.yml

# 3. Démarrer
./start.sh

# 4. Suivre les logs (dans un autre terminal)
docker-compose -f docker-compose.nohealth.yml logs -f

# 5. Attendre que vous voyiez :
#    - "Ollama est prêt!"
#    - "Téléchargement du modèle codellama..."
#    - "Configuration terminée!"

# 6. Vérifier que tout fonctionne
curl http://localhost:11434/api/tags
curl http://localhost:3000
```

## ⏱️ Temps d'Attente Normaux

- **Ollama démarre** : 10-30 secondes
- **Téléchargement codellama** : 5-10 minutes (première fois)
- **Build de l'app** : 2-5 minutes (première fois)
- **Démarrages suivants** : 10-20 secondes

## 🔧 Si le Problème Persiste

### Solution 1 : Démarrer Manuellement dans l'Ordre

```bash
# 1. Seulement Ollama
docker-compose -f docker-compose.nohealth.yml up -d ollama

# 2. Attendre et vérifier
sleep 30
curl http://localhost:11434/api/tags

# 3. Télécharger le modèle manuellement
docker exec ai-agent-ollama ollama pull codellama

# 4. Démarrer l'app
docker-compose -f docker-compose.nohealth.yml up -d app
```

### Solution 2 : Augmenter les Ressources Docker

```bash
# Docker Desktop > Settings > Resources
# - CPU: Minimum 4 cores
# - RAM: Minimum 8 GB
# - Disk: Minimum 20 GB
```

### Solution 3 : Vérifier les Ports

```bash
# Vérifier que 11434 est libre
lsof -i :11434

# Si occupé, arrêter le processus ou changer le port
# Dans docker-compose.nohealth.yml:
# ports:
#   - "11435:11434"  # Utiliser 11435 au lieu de 11434
```

## 📝 Logs à Examiner

```bash
# Logs d'Ollama (doit montrer le serveur démarré)
docker logs ai-agent-ollama

# Logs du setup (doit montrer le téléchargement)
docker logs ai-agent-ollama-setup

# Logs de l'app (doit montrer Next.js démarré)
docker logs ai-agent-app
```

## ✅ Vérification que Tout Fonctionne

```bash
# 1. Tous les conteneurs tournent
docker ps | grep ai-agent

# 2. Ollama répond
curl http://localhost:11434/api/tags

# 3. Le modèle est installé
docker exec ai-agent-ollama ollama list

# 4. L'app répond
curl http://localhost:3000

# 5. Ouvrir dans le navigateur
open http://localhost:3000  # macOS
xdg-open http://localhost:3000  # Linux
```

## 🆘 Support

Si rien ne fonctionne :

```bash
# Collecter les infos de debug
docker-compose -f docker-compose.nohealth.yml logs > debug-logs.txt
docker ps -a >> debug-logs.txt
docker inspect ai-agent-ollama >> debug-logs.txt

# Envoyer à johan@nantares.consulting
```

---

**TL;DR** : Utilisez `./start.sh` qui utilise maintenant `docker-compose.nohealth.yml` par défaut et évite complètement les problèmes de healthcheck ! 🎯
