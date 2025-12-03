# 🚀 Installation Rapide d'un Modèle

## Pourquoi pas de modèle ?

Le service `ollama-setup` devrait installer `codellama` automatiquement au premier démarrage, mais parfois :
- Il échoue silencieusement
- La connexion internet est lente/coupée
- Ollama n'était pas prêt à temps

## ✅ Solution Rapide (5-10 minutes)

### Option 1 : Script Automatique (RECOMMANDÉ)

```bash
# Installer codellama (recommandé pour le code)
./install-model.sh codellama

# Ou un autre modèle
./install-model.sh llama3
./install-model.sh deepseek-coder
./install-model.sh mistral
```

### Option 2 : Commande Directe

```bash
# Installer codellama
docker exec -it ai-agent-ollama ollama pull codellama

# Attendre 5-10 minutes...
# Vérifier l'installation
docker exec ai-agent-ollama ollama list
```

### Option 3 : Via start.sh

```bash
./start.sh pull-model codellama
```

## 📊 Modèles Recommandés

| Modèle | Taille | Spécialité | Recommandé pour |
|--------|--------|-----------|-----------------|
| **codellama** | ~4 GB | Code | Génération de code (DEFAULT) |
| **deepseek-coder** | ~4 GB | Code | Excellent pour le code |
| **llama3** | ~5 GB | Général | Bon équilibre |
| **mistral** | ~4 GB | Général | Rapide et efficace |
| **qwen2.5-coder** | ~4 GB | Code | Nouveau, très bon |

## 🔍 Vérifier les Modèles Installés

```bash
# Lister les modèles
docker exec ai-agent-ollama ollama list

# Devrait afficher quelque chose comme :
# NAME              ID              SIZE      MODIFIED
# codellama:latest  8fdf8f752f6e    3.8 GB    2 minutes ago
```

## 🐛 Vérifier Pourquoi ollama-setup a Échoué

```bash
# Voir les logs du service setup
docker logs ai-agent-ollama-setup

# Redémarrer le service setup manuellement
docker-compose -f docker-compose.nohealth.yml up ollama-setup

# Ou recréer le service
docker-compose -f docker-compose.nohealth.yml rm -f ollama-setup
docker-compose -f docker-compose.nohealth.yml up -d ollama-setup
docker logs -f ai-agent-ollama-setup
```

## ⚡ Installation Ultra-Rapide

```bash
# Tout en une seule ligne
docker exec ai-agent-ollama ollama pull codellama && \
docker exec ai-agent-ollama ollama list && \
echo "✓ Modèle installé ! Rechargez http://localhost:3000"
```

## 🎯 Après Installation

1. **Vérifier** :
   ```bash
   docker exec ai-agent-ollama ollama list
   ```

2. **Tester l'API** :
   ```bash
   curl http://localhost:3000/api/chat?action=models
   ```

3. **Recharger l'application** :
   - Ouvrir http://localhost:3000
   - Sélectionner le modèle dans le dropdown
   - Envoyer un message de test

## 📝 Installer Plusieurs Modèles

```bash
# Installer plusieurs modèles pour avoir le choix
docker exec ai-agent-ollama ollama pull codellama
docker exec ai-agent-ollama ollama pull llama3
docker exec ai-agent-ollama ollama pull deepseek-coder

# Vérifier
docker exec ai-agent-ollama ollama list
```

## 💾 Espace Disque Requis

- **1 modèle** : ~5 GB
- **2-3 modèles** : ~15 GB
- **5+ modèles** : ~25 GB

Vérifier l'espace disponible :
```bash
df -h
docker system df
```

## 🗑️ Supprimer un Modèle

```bash
# Supprimer un modèle pour libérer de l'espace
docker exec ai-agent-ollama ollama rm nom-du-modele

# Exemple
docker exec ai-agent-ollama ollama rm llama3
```

## 🔄 Mettre à Jour un Modèle

```bash
# Les modèles sont régulièrement mis à jour
docker exec ai-agent-ollama ollama pull codellama
```

## 🆘 Problèmes Courants

### "pull model manifest: Get ... connection refused"

**Cause** : Problème réseau ou Ollama pas complètement démarré

**Solution** :
```bash
# Attendre un peu
sleep 30

# Réessayer
docker exec ai-agent-ollama ollama pull codellama
```

### "Error: model requires more system memory"

**Cause** : Pas assez de RAM

**Solution** :
- Utiliser un modèle plus petit (codellama:7b au lieu de codellama:34b)
- Augmenter la RAM allouée à Docker (Settings > Resources)
- Fermer d'autres applications

### Le Téléchargement est Très Lent

**Cause** : Connexion internet lente

**Solution** :
- Soyez patient (5-10 minutes normalement)
- Utiliser une meilleure connexion
- Le téléchargement peut être repris s'il est interrompu

## ✅ Checklist Post-Installation

- [ ] `docker exec ai-agent-ollama ollama list` montre au moins 1 modèle
- [ ] `curl http://localhost:3000/api/chat?action=models` retourne des modèles
- [ ] Le dropdown de sélection de modèle dans l'app n'est pas vide
- [ ] Un message de test dans le chat reçoit une réponse

---

**TL;DR** :
```bash
./install-model.sh codellama
# Attendre 5-10 minutes
# Recharger http://localhost:3000
```

C'est tout ! 🎉
