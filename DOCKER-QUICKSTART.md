# 🚀 Démarrage Ultra-Rapide avec Docker

## Installation en 3 commandes

```bash
# 1. Rendre le script exécutable
chmod +x start.sh

# 2. Démarrer tout
./start.sh

# 3. Ouvrir http://localhost:3000
```

C'est tout ! 🎉

## Ou avec Make (encore plus simple)

```bash
make install
```

---

## Ce qui se passe en arrière-plan

1. ✅ Docker télécharge l'image Ollama (~1.5 GB)
2. ✅ Build de l'application Next.js
3. ✅ Démarrage d'Ollama sur le port 11434
4. ✅ Téléchargement automatique du modèle `codellama` (~4 GB)
5. ✅ Démarrage de l'app sur le port 3000

**Durée totale** : 5-15 minutes selon votre connexion internet

---

## Commandes Essentielles

```bash
# Voir les logs
./start.sh logs
# ou
make logs

# Arrêter
./start.sh stop
# ou
make stop

# Redémarrer
./start.sh restart
# ou
make restart

# Télécharger un autre modèle
./start.sh pull-model llama3
# ou
make pull-model MODEL=llama3

# Tout nettoyer
./start.sh clean
# ou
make clean
```

---

## Vérifications

### ✅ Ollama fonctionne ?
```bash
curl http://localhost:11434/api/tags
```

### ✅ L'app fonctionne ?
```bash
curl http://localhost:3000
```

### ✅ Voir le statut
```bash
./start.sh status
# ou
make status
```

---

## Problèmes ?

### Port déjà utilisé
```bash
# Modifier docker-compose.yml ligne 11
# Changer "3000:3000" en "8080:3000"
```

### Manque de mémoire
```bash
# Utiliser un modèle plus léger
./start.sh pull-model codellama:7b
```

### Ollama ne démarre pas
```bash
./start.sh logs ollama
```

---

## Aide Complète

- **Guide Docker complet** : [DOCKER.md](DOCKER.md)
- **Guide général** : [README.md](README.md)
- **Démarrage rapide** : [QUICKSTART.md](QUICKSTART.md)

---

## Support

Questions ? johan@nantares.consulting
