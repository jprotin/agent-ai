# Agent IA de Développement - Docker

Guide d'installation et d'utilisation avec Docker Compose.

## 🐳 Prérequis

- **Docker** 20.10+ ([Installer Docker](https://docs.docker.com/get-docker/))
- **Docker Compose** 2.0+ (inclus avec Docker Desktop)
- **Minimum 8 GB RAM** (16 GB recommandé pour les gros modèles)
- **10 GB d'espace disque libre** (pour les modèles IA)

## 🚀 Démarrage Rapide

### Option 1 : Utiliser le script (Recommandé)

```bash
# Rendre le script exécutable (une seule fois)
chmod +x start.sh

# Démarrer l'application
./start.sh

# L'application sera disponible sur http://localhost:3000
# Ollama API sur http://localhost:11434
```

### Option 2 : Docker Compose manuel

```bash
# Démarrer tous les services
docker-compose up -d

# Voir les logs
docker-compose logs -f

# Arrêter les services
docker-compose down
```

## 📋 Commandes du Script

```bash
./start.sh start           # Démarrer tous les services
./start.sh stop            # Arrêter tous les services
./start.sh restart         # Redémarrer
./start.sh logs            # Voir les logs en temps réel
./start.sh status          # Statut des services
./start.sh pull-model llama3  # Télécharger un modèle
./start.sh list-models     # Lister les modèles installés
./start.sh rebuild         # Reconstruire l'application
./start.sh clean           # Tout nettoyer
./start.sh shell           # Shell dans le conteneur app
./start.sh ollama-shell    # Shell dans le conteneur ollama
```

## 🏗️ Architecture Docker

### Services

1. **ollama** - Serveur Ollama pour l'IA locale
   - Port: 11434
   - Volume: `ollama_data` (persistance des modèles)
   
2. **ollama-setup** - Télécharge automatiquement le modèle `codellama`
   - S'exécute une fois au premier démarrage
   - Peut être relancé manuellement pour d'autres modèles

3. **app** - Application Next.js
   - Port: 3000
   - Volume: `./output` monté pour accès aux fichiers générés

### Volumes

- `ollama_data` : Stocke les modèles téléchargés (persistant)
- `./output` : Fichiers de code générés (bind mount)

## 🔧 Configuration

### Variables d'Environnement

Créer un fichier `.env` à la racine si nécessaire :

```env
# Port de l'application (défaut: 3000)
APP_PORT=3000

# Port d'Ollama (défaut: 11434)
OLLAMA_PORT=11434

# URL d'Ollama depuis l'application
OLLAMA_BASE_URL=http://ollama:11434
```

### Modèles Recommandés

```bash
# Modèle pour le code (léger, 7B)
./start.sh pull-model codellama

# Modèle généraliste (performant, 8B)
./start.sh pull-model llama3

# Spécialiste du code (excellent, 6.7B)
./start.sh pull-model deepseek-coder

# Grand modèle généraliste (33B, nécessite beaucoup de RAM)
./start.sh pull-model llama3:70b
```

### GPU Support (Optionnel)

Pour utiliser un GPU NVIDIA, décommentez dans `docker-compose.yml` :

```yaml
ollama:
  deploy:
    resources:
      reservations:
        devices:
          - driver: nvidia
            count: 1
            capabilities: [gpu]
```

Prérequis : [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

## 📊 Utilisation

1. **Démarrer l'application**
   ```bash
   ./start.sh
   ```

2. **Ouvrir le navigateur**
   ```
   http://localhost:3000
   ```

3. **Vérifier la connexion**
   - Le bandeau doit afficher "Connecté à Ollama" en vert
   - Sélectionner le modèle dans le dropdown

4. **Uploader une spécification**
   - Utiliser l'exemple : `examples/spec-calculatrice.md`
   - Ou créer votre propre spécification

5. **Générer du code**
   - L'agent analyse automatiquement
   - Répondre aux questions
   - Cliquer sur "Générer le Code"
   - Les fichiers sont dans `./output/`

## 🔍 Monitoring

### Logs en Temps Réel

```bash
# Tous les services
./start.sh logs

# Un service spécifique
docker-compose logs -f app
docker-compose logs -f ollama
```

### Statut des Services

```bash
./start.sh status
```

### Ressources Utilisées

```bash
docker stats
```

## 🐛 Dépannage

### Problème : "Ollama non accessible"

**Solution 1 : Vérifier que le conteneur fonctionne**
```bash
docker-compose ps
docker-compose logs ollama
```

**Solution 2 : Redémarrer Ollama**
```bash
docker-compose restart ollama
sleep 10  # Attendre le démarrage
```

### Problème : Pas de modèles disponibles

```bash
# Vérifier les modèles installés
./start.sh list-models

# Télécharger un modèle
./start.sh pull-model codellama
```

### Problème : L'application ne démarre pas

```bash
# Voir les logs détaillés
docker-compose logs app

# Reconstruire l'image
./start.sh rebuild
./start.sh restart
```

### Problème : Manque de mémoire

```bash
# Utiliser un modèle plus léger
./start.sh pull-model codellama:7b

# Ou augmenter la RAM allouée à Docker
# Docker Desktop > Settings > Resources > Memory
```

### Problème : Fichiers non générés

```bash
# Vérifier les permissions du dossier output
ls -la output/

# Créer le dossier si nécessaire
mkdir -p output
chmod 777 output
```

### Problème : Port déjà utilisé

```bash
# Modifier le port dans docker-compose.yml
# Changer "3000:3000" par "8080:3000" par exemple

# Ou arrêter le service qui utilise le port
lsof -i :3000
kill -9 <PID>
```

## 🧹 Maintenance

### Nettoyer les Conteneurs Arrêtés

```bash
docker-compose down
```

### Nettoyer Complètement (ATTENTION : supprime les modèles)

```bash
./start.sh clean
```

### Mettre à Jour l'Application

```bash
# Récupérer les dernières modifications
git pull

# Reconstruire
./start.sh rebuild
./start.sh restart
```

### Sauvegarder les Modèles

```bash
# Backup du volume Ollama
docker run --rm -v ai-coding-agent_ollama_data:/data -v $(pwd):/backup \
  alpine tar czf /backup/ollama-backup.tar.gz -C /data .
```

### Restaurer les Modèles

```bash
# Restore du volume Ollama
docker run --rm -v ai-coding-agent_ollama_data:/data -v $(pwd):/backup \
  alpine tar xzf /backup/ollama-backup.tar.gz -C /data
```

## 📈 Performance

### Temps de Chargement des Modèles

| Modèle | Taille | RAM nécessaire | Vitesse |
|--------|--------|----------------|---------|
| codellama:7b | ~4 GB | 8 GB | Rapide |
| llama3:8b | ~5 GB | 8 GB | Rapide |
| deepseek-coder:6.7b | ~4 GB | 8 GB | Très rapide |
| llama3:70b | ~40 GB | 64 GB | Lent |

### Optimisations

1. **Utiliser un SSD** pour les volumes Docker
2. **Allouer suffisamment de RAM** à Docker Desktop
3. **Garder un seul modèle** pour économiser l'espace
4. **Utiliser un GPU** si disponible pour 5-10x plus rapide

## 🔐 Sécurité

### Réseau

Les services sont isolés dans un réseau Docker interne. Seuls les ports 3000 et 11434 sont exposés sur localhost.

### Volumes

Le dossier `./output` est monté en lecture/écriture. Les fichiers générés y sont accessibles depuis l'hôte.

### Production

Pour la production, considérez :
- Utiliser des secrets Docker pour les credentials
- Ajouter un reverse proxy (nginx, traefik)
- Configurer HTTPS
- Limiter les ressources avec `deploy.resources`

## 📚 Ressources

- [Documentation Ollama](https://ollama.ai/docs)
- [Documentation Docker](https://docs.docker.com/)
- [Liste des modèles Ollama](https://ollama.ai/library)
- [Next.js Documentation](https://nextjs.org/docs)

## 🆘 Support

En cas de problème :
1. Vérifier les logs : `./start.sh logs`
2. Consulter la section Dépannage
3. Ouvrir une issue sur GitHub
4. Contact : johan@nantares.consulting
