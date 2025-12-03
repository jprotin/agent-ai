# ⚡ QUICKFIX - Erreur npm ci

## 🔴 Erreur
```
ERROR: failed to solve: process "/bin/sh -c npm ci" did not complete successfully: exit code: 1
```

## ✅ Solution Immédiate (30 secondes)

### Option 1 : Utiliser la Version Simple (RECOMMANDÉ)

```bash
# Extraire l'archive
tar -xzf ai-coding-agent.tar.gz
cd ai-coding-agent

# Démarrer avec la version simple (par défaut maintenant)
chmod +x start.sh
./start.sh
```

Le script utilise automatiquement `docker-compose.simple.yml` qui évite l'erreur.

### Option 2 : Commande Directe

```bash
# Utiliser directement le compose file simple
docker-compose -f docker-compose.simple.yml up -d --build
```

### Option 3 : Si vous voulez la version optimisée

```bash
# Forcer l'utilisation de la version optimisée
COMPOSE_FILE_OVERRIDE=1 ./start.sh
```

## 🎯 Qu'est-ce qui a été corrigé ?

### Fichiers Créés
1. **Dockerfile.simple** - Version simplifiée sans multi-stage
2. **docker-compose.simple.yml** - Configuration pour la version simple
3. **BUILD-TROUBLESHOOTING.md** - Guide complet de dépannage

### Modifications
1. **Dockerfile** - Utilise `npm install` au lieu de `npm ci`
2. **start.sh** - Utilise automatiquement la version simple par défaut

## 📊 Différences entre les Versions

| Aspect | Version Simple | Version Optimisée |
|--------|---------------|-------------------|
| Build | ✅ Plus fiable | ⚠️ Peut échouer |
| Taille | ~500MB | ~100MB |
| Vitesse | Rapide | Plus rapide |
| Usage | Dev/Debug | Production |

## 🧪 Tester que ça Fonctionne

```bash
# 1. Démarrer
./start.sh

# 2. Attendre ~30 secondes

# 3. Vérifier
curl http://localhost:3000
curl http://localhost:11434/api/tags

# 4. Voir les logs
./start.sh logs
```

## 🆘 Si ça Échoue Encore

```bash
# Voir exactement où ça bloque
docker-compose -f docker-compose.simple.yml build --progress=plain app

# Collecter les infos
docker version > debug.txt
docker-compose -f docker-compose.simple.yml logs >> debug.txt

# Envoyer debug.txt à johan@nantares.consulting
```

## 📝 Notes Techniques

La version simple :
- N'utilise pas de build multi-stage
- Installe toutes les dépendances
- Moins optimisée mais beaucoup plus robuste
- Parfaite pour le développement

La version optimisée :
- Build multi-stage (base -> deps -> builder -> runner)
- Image finale minimale
- Meilleure pour la production
- Plus sensible aux erreurs de build

## ✨ Commandes Utiles

```bash
# Démarrer (version simple par défaut)
./start.sh

# Démarrer (version optimisée)
COMPOSE_FILE_OVERRIDE=1 ./start.sh

# Arrêter
./start.sh stop

# Logs
./start.sh logs

# Statut
./start.sh status

# Nettoyer et recommencer
./start.sh clean
./start.sh
```

---

**TL;DR** : Utilisez `./start.sh` qui utilise maintenant automatiquement la version simplifiée et fiable ! 🚀
