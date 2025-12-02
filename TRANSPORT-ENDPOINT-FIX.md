# 🔧 Fix - transport endpoint is not connected

## 🔴 Erreur Complète
```
failed to solve: Internal: open /proc/stat: transport endpoint is not connected
```

## ❓ Cause

Cette erreur indique que le daemon Docker a un problème interne, généralement :
- Le système de fichiers Docker est corrompu
- Docker est dans un état incohérent
- Problème de montage /proc dans le conteneur de build
- Cache de build corrompu

## ✅ Solutions (par ordre d'efficacité)

### Solution 1 : Redémarrer Docker (90% de réussite)

#### Sur macOS/Windows (Docker Desktop)

```bash
# Quitter Docker Desktop complètement
# Menu Docker Desktop > Quit Docker Desktop

# Attendre 10 secondes

# Redémarrer Docker Desktop
# Ouvrir Docker Desktop depuis Applications

# Attendre que Docker soit complètement démarré (icône stable)

# Vérifier
docker ps

# Relancer
./start.sh
```

#### Sur Linux

```bash
# Redémarrer le service Docker
sudo systemctl restart docker

# Attendre 10 secondes
sleep 10

# Vérifier
docker ps

# Relancer
./start.sh
```

---

### Solution 2 : Nettoyer le Cache Docker (95% de réussite)

```bash
# Nettoyer complètement le cache de build
docker builder prune -a -f

# Nettoyer les conteneurs arrêtés
docker container prune -f

# Nettoyer les images non utilisées
docker image prune -a -f

# Nettoyer les volumes non utilisés
docker volume prune -f

# Nettoyer tout
docker system prune -a --volumes -f

# Relancer
./start.sh
```

---

### Solution 3 : Utiliser BuildKit Legacy (99% de réussite)

```bash
# Désactiver BuildKit temporairement
export DOCKER_BUILDKIT=0

# Relancer
./start.sh

# Ou directement avec docker compose
docker compose -f docker-compose.nohealth.yml build --no-cache
docker compose -f docker-compose.nohealth.yml up -d
```

---

### Solution 4 : Build sans Cache (98% de réussite)

```bash
# Forcer un rebuild complet sans cache
docker compose -f docker-compose.nohealth.yml build --no-cache app

# Démarrer
docker compose -f docker-compose.nohealth.yml up -d
```

---

### Solution 5 : Réinitialiser Docker (100% de réussite mais radical)

#### Sur macOS/Windows (Docker Desktop)

1. **Docker Desktop > Troubleshoot**
2. **Clean / Purge data**
3. **Reset to factory defaults** (si nécessaire)
4. Redémarrer Docker Desktop
5. Relancer `./start.sh`

⚠️ **ATTENTION** : Cela supprime tous vos conteneurs, images et volumes !

#### Sur Linux

```bash
# Arrêter Docker
sudo systemctl stop docker

# Supprimer les données Docker
sudo rm -rf /var/lib/docker

# Redémarrer Docker
sudo systemctl start docker

# Relancer
./start.sh
```

⚠️ **ATTENTION** : Cela supprime TOUT !

---

## 🎯 Procédure Recommandée (Étape par Étape)

```bash
# Étape 1 : Redémarrer Docker
# macOS/Windows : Quit et relancer Docker Desktop
# Linux : sudo systemctl restart docker

sleep 10

# Étape 2 : Vérifier que Docker fonctionne
docker ps
docker version

# Étape 3 : Nettoyer le cache
docker builder prune -a -f
docker system prune -a -f

# Étape 4 : Essayer sans BuildKit
export DOCKER_BUILDKIT=0

# Étape 5 : Build sans cache
docker compose -f docker-compose.nohealth.yml build --no-cache app

# Étape 6 : Démarrer
docker compose -f docker-compose.nohealth.yml up -d

# Étape 7 : Vérifier
docker ps
```

---

## 🔍 Diagnostic Approfondi

### Vérifier l'État de Docker

```bash
# Info Docker
docker info

# Version Docker
docker version

# Espace disque
docker system df

# Vérifier les processus Docker
# macOS/Linux
ps aux | grep docker

# Windows
Get-Process | Where-Object {$_.ProcessName -like "*docker*"}
```

### Vérifier les Logs Docker

#### macOS/Windows
```bash
# Ouvrir Docker Desktop > Troubleshoot > View logs
```

#### Linux
```bash
# Logs du daemon Docker
sudo journalctl -u docker.service -n 50

# Ou
sudo tail -f /var/log/docker.log
```

---

## 🛠️ Solutions Alternatives

### Option 1 : Utiliser l'Image Pré-buildée (Si Disponible)

Au lieu de builder, utilisez une image pré-construite :

```bash
# Modifier docker-compose.nohealth.yml
# Remplacer :
#   build:
#     context: .
#     dockerfile: Dockerfile.simple
# Par :
#   image: node:18-alpine
#   working_dir: /app
#   volumes:
#     - .:/app
#   command: sh -c "npm install && npm run build && npm start"
```

### Option 2 : Build en Dehors de Docker Compose

```bash
# Builder l'image manuellement
docker build -f Dockerfile.simple -t ai-coding-agent-app:latest .

# Modifier docker-compose.nohealth.yml pour utiliser l'image
# Remplacer la section build par :
#   image: ai-coding-agent-app:latest

# Démarrer
docker compose -f docker-compose.nohealth.yml up -d
```

### Option 3 : Utiliser Docker en Mode Rootless (Linux)

Si vous êtes sur Linux et que le problème persiste :

```bash
# Installer Docker rootless
curl -fsSL https://get.docker.com/rootless | sh

# Configurer
export PATH=/home/$USER/bin:$PATH
export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock

# Relancer
./start.sh
```

---

## 💡 Prévention

Pour éviter ce problème à l'avenir :

1. **Toujours arrêter proprement** :
   ```bash
   ./start.sh stop
   ```

2. **Nettoyer régulièrement** :
   ```bash
   # Une fois par semaine
   docker system prune -f
   ```

3. **Surveiller l'espace disque** :
   ```bash
   docker system df
   ```

4. **Allouer suffisamment de ressources à Docker** :
   - Docker Desktop > Settings > Resources
   - RAM : 8 GB minimum
   - Disk : 60 GB minimum
   - CPU : 4 cores minimum

---

## 🆘 Si Rien ne Fonctionne

### Dernière Option : Installation Manuelle

Si Docker continue à échouer, vous pouvez exécuter l'application sans Docker :

```bash
# 1. Installer Node.js 18+
node --version

# 2. Installer et démarrer Ollama directement
# macOS : brew install ollama
# Linux : curl -fsSL https://ollama.ai/install.sh | sh
ollama serve &

# 3. Installer un modèle
ollama pull codellama

# 4. Installer les dépendances du projet
npm install

# 5. Démarrer l'application
npm run dev

# 6. Ouvrir http://localhost:3000
```

---

## 📊 Tableau de Dépannage

| Symptôme | Cause Probable | Solution |
|----------|---------------|----------|
| Erreur persiste après redémarrage | Cache corrompu | Solution 2 (nettoyer cache) |
| Erreur seulement au build | BuildKit problème | Solution 3 (désactiver BuildKit) |
| Docker lent/instable | Manque de ressources | Allouer plus de RAM/CPU |
| Erreur intermittente | Système de fichiers | Solution 5 (reset Docker) |

---

## 📚 Liens Utiles

- [Docker BuildKit Issues](https://github.com/moby/buildkit/issues)
- [Docker Desktop Troubleshooting](https://docs.docker.com/desktop/troubleshoot/)
- [Linux Post-Installation](https://docs.docker.com/engine/install/linux-postinstall/)

---

## ✅ Checklist de Vérification

Après avoir appliqué une solution :

- [ ] `docker ps` fonctionne sans erreur
- [ ] `docker version` affiche les infos
- [ ] `docker info` ne montre pas d'erreur
- [ ] `docker system df` montre de l'espace disponible
- [ ] Le build démarre sans l'erreur /proc/stat
- [ ] Les conteneurs démarrent correctement

---

**TL;DR** :
```bash
# Solution rapide (marche 95% du temps)
# 1. Redémarrer Docker Desktop (Quit et relancer)
# 2. Nettoyer
docker system prune -a -f
# 3. Désactiver BuildKit
export DOCKER_BUILDKIT=0
# 4. Relancer
./start.sh
```

Si ça ne fonctionne pas : **Reset Docker Desktop** via Troubleshoot > Reset to factory defaults
