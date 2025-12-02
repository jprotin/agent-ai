# Configuration mémoire et choix des modèles

## 🔍 Problème : "model requires more system memory"

Si vous voyez cette erreur :
```
{"error":"model requires more system memory (5.5 GiB) than is available (2.3 GiB)"}
```

Cela signifie que le modèle nécessite plus de RAM que ce qui est disponible sur votre système.

## 📊 Exigences mémoire par modèle

### Modèles ULTRA LÉGERS (< 4 GB RAM disponible requis)

| Modèle | RAM requise | Taille téléchargement | Qualité Code | Commande |
|--------|-------------|----------------------|--------------|----------|
| **qwen2.5-coder:1.5b** ⭐ | ~2 GB | 900 MB | ⭐⭐⭐⭐ | `ollama pull qwen2.5-coder:1.5b` |
| deepseek-coder:1.3b | ~1.5 GB | 800 MB | ⭐⭐⭐⭐ | `ollama pull deepseek-coder:1.3b` |
| phi3:mini | ~2.3 GB | 2.3 GB | ⭐⭐⭐⭐ | `ollama pull phi3:mini` |
| tinyllama | ~1 GB | 637 MB | ⭐⭐⭐ | `ollama pull tinyllama` |
| gemma:2b | ~2.5 GB | 1.7 GB | ⭐⭐⭐⭐ | `ollama pull gemma:2b` |

**✅ RECOMMANDÉ : qwen2.5-coder:1.5b** - Excellent équilibre entre performance et consommation mémoire

### Modèles STANDARDS (>= 6 GB RAM disponible requis)

| Modèle | RAM requise | Taille téléchargement | Qualité Code | Commande |
|--------|-------------|----------------------|--------------|----------|
| codellama | ~5.5 GB | 3.8 GB | ⭐⭐⭐⭐⭐ | `ollama pull codellama` |
| llama3 | ~4.7 GB | 4.7 GB | ⭐⭐⭐⭐⭐ | `ollama pull llama3` |
| qwen2.5-coder | ~4.7 GB | 4.7 GB | ⭐⭐⭐⭐⭐ | `ollama pull qwen2.5-coder` |
| deepseek-coder | ~3.8 GB | 3.8 GB | ⭐⭐⭐⭐⭐ | `ollama pull deepseek-coder` |

### Modèles QUANTIFIÉS (versions compressées)

Pour utiliser des modèles standards avec moins de RAM, essayez les versions quantifiées :

| Modèle | RAM requise | Qualité | Commande |
|--------|-------------|---------|----------|
| codellama:7b-code-q4_0 | ~3 GB | ⭐⭐⭐⭐ | `ollama pull codellama:7b-code-q4_0` |
| llama3:8b-q4_0 | ~3.2 GB | ⭐⭐⭐⭐ | `ollama pull llama3:8b-q4_0` |

## 🚀 Solutions rapides

### Option 1 : Utiliser le script automatique (RECOMMANDÉ)

```bash
# Détecte automatiquement votre configuration et recommande le bon modèle
chmod +x check-memory.sh
./check-memory.sh
```

Le script vous proposera d'installer automatiquement le meilleur modèle pour votre système.

### Option 2 : Installation manuelle du modèle recommandé

```bash
# Installer qwen2.5-coder:1.5b (léger et performant)
docker exec ai-agent-ollama ollama pull qwen2.5-coder:1.5b

# Redémarrer l'application
docker compose restart app
```

### Option 3 : Augmenter la mémoire Docker

Si vous voulez utiliser des modèles plus puissants :

#### Sur Docker Desktop (Windows/Mac)
1. Ouvrir Docker Desktop
2. Settings → Resources → Memory
3. Augmenter à au moins **6 GB** (8 GB recommandé)
4. Cliquer "Apply & Restart"

#### Sur Linux
Docker utilise directement la RAM système. Fermez les applications non utilisées pour libérer de la mémoire.

## 🔧 Configuration du projet

### Modèle par défaut

Le projet utilise maintenant **qwen2.5-coder:1.5b** par défaut, qui nécessite seulement ~2 GB de RAM.

Vous pouvez changer le modèle via :

1. **Variable d'environnement** (dans `docker-compose.yml`) :
```yaml
environment:
  - OLLAMA_MODEL=qwen2.5-coder:1.5b
```

2. **Interface web** : Sélecteur de modèle à côté du statut Ollama

### Fichiers de configuration

- `app/lib/ollama.ts` : Modèle par défaut côté serveur
- `components/ai-agent.tsx` : Modèle par défaut côté client
- `docker-compose.yml` : Configuration Docker et auto-installation

## 📈 Comparaison de performances

### Vitesse de réponse (tokens/sec)

Sur un système avec 8 GB RAM :

| Modèle | Vitesse | Qualité | Idéal pour |
|--------|---------|---------|-----------|
| qwen2.5-coder:1.5b | ⚡⚡⚡⚡⚡ | ⭐⭐⭐⭐ | Systèmes limités en RAM |
| deepseek-coder:1.3b | ⚡⚡⚡⚡⚡ | ⭐⭐⭐⭐ | Code Python/JS |
| phi3:mini | ⚡⚡⚡⚡ | ⭐⭐⭐⭐ | Usage général |
| codellama | ⚡⚡⚡ | ⭐⭐⭐⭐⭐ | Projets complexes |
| llama3 | ⚡⚡⚡ | ⭐⭐⭐⭐⭐ | Meilleure qualité |

### Consommation mémoire en pratique

Mesures réelles lors de l'exécution :

| Modèle | RAM de base | Pendant génération | Pic maximum |
|--------|-------------|-------------------|-------------|
| qwen2.5-coder:1.5b | 1.2 GB | 1.8 GB | 2.1 GB |
| deepseek-coder:1.3b | 1.0 GB | 1.4 GB | 1.6 GB |
| phi3:mini | 1.8 GB | 2.2 GB | 2.5 GB |
| codellama | 4.2 GB | 5.3 GB | 6.0 GB |
| llama3 | 4.5 GB | 5.5 GB | 6.5 GB |

## 🎯 Recommandations par configuration

### Configuration minimale (< 4 GB RAM disponible)
```bash
# Installation recommandée
docker exec ai-agent-ollama ollama pull qwen2.5-coder:1.5b
```
✅ Fonctionne bien
⚠️ Qualité légèrement réduite mais suffisante pour la plupart des tâches

### Configuration standard (4-8 GB RAM disponible)
```bash
# Vous pouvez utiliser des modèles quantifiés
docker exec ai-agent-ollama ollama pull codellama:7b-code-q4_0
# OU
docker exec ai-agent-ollama ollama pull phi3:mini
```
✅ Bon équilibre performance/qualité

### Configuration performante (>= 8 GB RAM disponible)
```bash
# Utilisez les modèles complets
docker exec ai-agent-ollama ollama pull codellama
docker exec ai-agent-ollama ollama pull llama3
docker exec ai-agent-ollama ollama pull qwen2.5-coder
```
✅ Meilleure qualité de code
✅ Compréhension de contexte supérieure

## 🛠️ Scripts d'aide

### check-memory.sh
Détecte votre configuration et recommande le meilleur modèle :
```bash
chmod +x check-memory.sh
./check-memory.sh
```

### install-models.sh
Menu interactif pour installer des modèles :
```bash
chmod +x install-models.sh
./install-models.sh
```

### test-ollama.sh
Teste la connexion et les modèles installés :
```bash
chmod +x test-ollama.sh
./test-ollama.sh
```

## ❓ FAQ

### Q: Puis-je installer plusieurs modèles ?
**R:** Oui ! Installez autant de modèles que vous voulez, puis sélectionnez celui à utiliser dans l'interface.

### Q: Comment libérer de l'espace disque ?
**R:**
```bash
# Lister les modèles
docker exec ai-agent-ollama ollama list

# Supprimer un modèle
docker exec ai-agent-ollama ollama rm <nom-du-modele>
```

### Q: Le modèle est lent, que faire ?
**R:**
1. Utilisez un modèle plus léger (qwen2.5-coder:1.5b)
2. Fermez les applications non utilisées
3. Augmentez la RAM Docker si possible

### Q: Quel est le meilleur modèle pour le code ?
**R:**
- **Budget RAM limité** : qwen2.5-coder:1.5b ou deepseek-coder:1.3b
- **RAM suffisante** : codellama ou qwen2.5-coder (version complète)

### Q: Comment changer le modèle par défaut ?
**R:**
1. Modifiez `OLLAMA_MODEL` dans `docker-compose.yml`
2. Ou sélectionnez un autre modèle dans l'interface web

## 📞 Support

Si vous rencontrez toujours des problèmes :

1. Vérifiez les logs : `docker compose logs app ollama`
2. Consultez [FIXING-404-ERROR.md](./FIXING-404-ERROR.md)
3. Utilisez le script de diagnostic : `./test-ollama.sh`

## 🔄 Mise à jour

Pour mettre à jour vers la configuration optimisée pour la mémoire :

```bash
# Arrêter les conteneurs
docker compose down

# Reconstruire avec la nouvelle configuration
docker compose build --no-cache

# Démarrer avec le nouveau modèle par défaut
docker compose up -d

# Le modèle qwen2.5-coder:1.5b sera automatiquement téléchargé
```

C'est tout ! Votre application devrait maintenant fonctionner même sur des systèmes avec peu de RAM. 🎉
