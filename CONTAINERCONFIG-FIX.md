# 🔧 Fix - Erreur "ContainerConfig" KeyError

## 🔴 Erreur Complète
```
ERROR: for ollama  'ContainerConfig'
KeyError: 'ContainerConfig'
```

## ❓ Cause
Un ancien conteneur Docker est dans un état corrompu. Cela arrive quand :
- Un conteneur a été arrêté brutalement
- La configuration Docker a changé entre deux démarrages
- Les métadonnées du conteneur sont corrompues
- Une version précédente a laissé des conteneurs orphelins

## ✅ Solution Immédiate (2 minutes)

### Méthode 1 : Script de Nettoyage (RECOMMANDÉE)

```bash
# Rendre le script exécutable
chmod +x clean-all.sh

# Lancer le nettoyage
./clean-all.sh

# Redémarrer
./start.sh
```

### Méthode 2 : Commandes Manuelles

```bash
# 1. Arrêter tous les conteneurs ai-agent
docker stop ai-agent-ollama ai-agent-ollama-setup ai-agent-app 2>/dev/null || true

# 2. Supprimer tous les conteneurs ai-agent
docker rm -f ai-agent-ollama ai-agent-ollama-setup ai-agent-app 2>/dev/null || true

# 3. Nettoyer les conteneurs orphelins
docker container prune -f

# 4. Supprimer le réseau
docker network rm ai-agent-network 2>/dev/null || true

# 5. Supprimer l'image de l'app
docker rmi ai-coding-agent-app 2>/dev/null || true

# 6. Redémarrer proprement
./start.sh
```

### Méthode 3 : Nettoyage avec docker-compose

```bash
# Arrêter et supprimer tout (SANS supprimer le volume des modèles)
docker-compose -f docker-compose.nohealth.yml down

# Nettoyer les conteneurs orphelins
docker container prune -f

# Redémarrer
./start.sh
```

## ⚠️ Nettoyage Complet (Si rien ne fonctionne)

**ATTENTION : Cela supprimera aussi les modèles téléchargés**

```bash
# Tout supprimer Y COMPRIS les volumes
docker-compose -f docker-compose.nohealth.yml down -v

# Nettoyer le système Docker
docker system prune -a -f

# Redémarrer (les modèles devront être retéléchargés)
./start.sh
```

## 🔍 Diagnostic

### Vérifier l'état des conteneurs

```bash
# Voir tous les conteneurs (y compris arrêtés)
docker ps -a | grep ai-agent

# Voir les détails d'un conteneur problématique
docker inspect ai-agent-ollama
```

### Identifier le conteneur corrompu

```bash
# Trouver les conteneurs avec des problèmes
docker ps -a --filter "status=dead"
docker ps -a --filter "status=exited"

# Supprimer un conteneur spécifique par ID
docker rm -f 4303abcfde14
```

## 📊 Pourquoi Cette Erreur Arrive

1. **Arrêt brutal** : Docker Desktop a été fermé pendant que les conteneurs tournaient
2. **Mise à jour Docker** : Version de Docker/docker-compose a changé
3. **Corruption** : Problème système (crash, redémarrage forcé)
4. **Conflit de nom** : Tentative de recréer un conteneur qui existe déjà

## 🛡️ Prévention

### Toujours arrêter proprement

```bash
# Au lieu de fermer Docker Desktop directement
./start.sh stop

# Ou
docker-compose -f docker-compose.nohealth.yml down
```

### Vérifier régulièrement l'état

```bash
# Voir les conteneurs actifs
docker ps

# Voir tous les conteneurs
docker ps -a

# Nettoyer les conteneurs arrêtés
docker container prune -f
```

## 🚀 Procédure de Démarrage Propre

```bash
# 1. Vérifier qu'aucun conteneur ai-agent ne tourne
docker ps | grep ai-agent

# 2. Si des conteneurs existent, les nettoyer
./clean-all.sh

# 3. Démarrer proprement
./start.sh

# 4. Vérifier que tout démarre bien
docker ps
./start.sh logs
```

## 🔄 Si l'Erreur Persiste

### Option 1 : Supprimer le conteneur corrompu par son ID

```bash
# Trouver l'ID exact dans l'erreur (ex: 4303abcfde14)
docker rm -f 4303abcfde14

# Redémarrer
./start.sh
```

### Option 2 : Réinitialiser Docker complètement

**macOS/Windows (Docker Desktop)** :
1. Docker Desktop → Settings → Troubleshoot → Clean / Purge data
2. Redémarrer Docker Desktop
3. `./start.sh`

**Linux** :
```bash
# Arrêter Docker
sudo systemctl stop docker

# Nettoyer
docker system prune -a --volumes -f

# Redémarrer Docker
sudo systemctl start docker

# Relancer l'app
./start.sh
```

### Option 3 : Utiliser des noms de conteneurs différents

Modifier temporairement les noms dans docker-compose.nohealth.yml :

```yaml
services:
  ollama:
    container_name: ai-agent-ollama-v2  # Ajouter -v2
```

## ✅ Vérification Finale

Après nettoyage et redémarrage :

```bash
# 1. Vérifier que les conteneurs démarrent
docker ps

# 2. Voir les logs
docker-compose -f docker-compose.nohealth.yml logs -f

# 3. Tester l'accès
curl http://localhost:11434/api/tags
curl http://localhost:3000
```

## 📝 Commandes de Debug Utiles

```bash
# Voir l'espace disque Docker
docker system df

# Voir les volumes
docker volume ls

# Voir les réseaux
docker network ls

# Inspecter le volume Ollama (vérifier qu'il existe)
docker volume inspect ai-coding-agent_ollama_data

# Voir les images
docker images | grep ai-agent
```

## 🆘 Support

Si le nettoyage ne résout pas le problème :

```bash
# Collecter les infos
docker ps -a > debug.txt
docker images >> debug.txt
docker volume ls >> debug.txt
docker network ls >> debug.txt
docker system df >> debug.txt

# Envoyer debug.txt à johan@nantares.consulting
```

---

**TL;DR** : 
```bash
./clean-all.sh
./start.sh
```

Cette séquence nettoie tout et redémarre proprement ! 🎯
