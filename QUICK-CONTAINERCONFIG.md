# ⚡ SOLUTION RAPIDE - Erreur ContainerConfig

## 🔴 L'Erreur
```
ERROR: for ollama  'ContainerConfig'
KeyError: 'ContainerConfig'
```

## ✅ Solution en 3 Commandes (1 minute)

```bash
# 1. Nettoyer les conteneurs corrompus
./clean-all.sh

# 2. Redémarrer proprement
./start.sh

# 3. Suivre les logs
./start.sh logs
```

## 🎯 Alternative avec start.sh

```bash
# Nettoyer seulement les conteneurs (garde les modèles)
./start.sh clean-containers

# Redémarrer
./start.sh
```

## 🚨 Si Vous Êtes Pressé

```bash
# Commande unique qui nettoie ET redémarre
docker stop ai-agent-ollama ai-agent-ollama-setup ai-agent-app 2>/dev/null; \
docker rm -f ai-agent-ollama ai-agent-ollama-setup ai-agent-app 2>/dev/null; \
docker container prune -f; \
./start.sh
```

## 📖 Pourquoi Ça Arrive

Vous avez probablement :
- Arrêté Docker Desktop brutalement
- Eu un crash pendant que les conteneurs tournaient
- Lancé plusieurs fois `docker-compose up` sans nettoyer

## 🛡️ Pour Éviter Ce Problème

```bash
# Toujours arrêter proprement
./start.sh stop

# Au lieu de fermer Docker Desktop directement
```

## 📚 Plus d'Infos

Voir `CONTAINERCONFIG-FIX.md` pour le guide complet.

---

**C'est tout ! Après ces commandes, ça devrait fonctionner.** 🎉
