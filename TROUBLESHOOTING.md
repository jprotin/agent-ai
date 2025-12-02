# 🔧 Troubleshooting - Erreurs de Build Docker

## Erreur : "npm ci failed to complete successfully: exit code: 1"

### Cause
Le fichier `package-lock.json` est manquant ou corrompu.

### Solution 1 : Générer le package-lock.json

```bash
# Dans le dossier du projet
npm install --package-lock-only

# Puis rebuild
./start.sh rebuild
```

### Solution 2 : Le Dockerfile gère déjà ce cas

Le Dockerfile a été mis à jour pour utiliser `npm install` si `package-lock.json` n'existe pas.

---

## Erreur : "no space left on device"

### Cause
Docker manque d'espace disque.

### Solution

```bash
# Nettoyer les images non utilisées
docker system prune -a

# Voir l'espace utilisé
docker system df

# Augmenter l'espace dans Docker Desktop
# Settings > Resources > Disk image size
```

---

## Erreur : "Cannot connect to the Docker daemon"

### Cause
Docker n'est pas démarré.

### Solution

```bash
# Linux
sudo systemctl start docker

# macOS/Windows
# Démarrer Docker Desktop depuis les applications
```

---

## Erreur : "port is already allocated"

### Cause
Le port 3000 ou 11434 est déjà utilisé.

### Solution 1 : Trouver et arrêter le processus

```bash
# Voir qui utilise le port 3000
lsof -i :3000
# ou
netstat -an | grep 3000

# Tuer le processus
kill -9 <PID>
```

### Solution 2 : Changer le port dans docker-compose.yml

```yaml
app:
  ports:
    - "8080:3000"  # Au lieu de "3000:3000"
```

---

## Erreur : "network ai-agent-network not found"

### Cause
Le réseau Docker n'existe pas ou est corrompu.

### Solution

```bash
# Nettoyer et recréer
docker-compose down
docker network prune
docker-compose up -d
```

---

## Erreur : "permission denied" sur ./output

### Cause
Problème de permissions sur le dossier output.

### Solution

```bash
# Créer et donner les permissions
mkdir -p output
chmod 755 output

# Si le problème persiste (Linux)
sudo chown -R $USER:$USER output
```

---

## Erreur : Build très lent ou qui se bloque

### Cause
Cache Docker corrompu ou connexion internet lente.

### Solution

```bash
# Rebuild sans cache
docker-compose build --no-cache app

# Ou avec le script
./start.sh rebuild
```

---

## Erreur : "ENOTFOUND registry.npmjs.org"

### Cause
Problème de réseau ou de DNS.

### Solution

```bash
# Vérifier la connexion internet
ping google.com

# Vérifier que Docker a accès au réseau
docker run --rm alpine ping -c 1 registry.npmjs.org

# Redémarrer Docker
# macOS/Windows : Redémarrer Docker Desktop
# Linux : sudo systemctl restart docker
```

---

## Erreur : "Module not found" dans l'application

### Cause
Dépendances manquantes ou problème de build.

### Solution

```bash
# Reconstruire complètement
./start.sh clean
./start.sh start

# Ou manuellement
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

---

## Erreur : L'application démarre mais ne répond pas

### Vérifications

```bash
# 1. Vérifier que le conteneur tourne
docker-compose ps

# 2. Voir les logs
docker-compose logs app

# 3. Tester depuis le conteneur
docker-compose exec app wget -O- http://localhost:3000

# 4. Vérifier le healthcheck
docker inspect ai-agent-app | grep -A 10 Health
```

### Solution

```bash
# Redémarrer l'app
docker-compose restart app

# Ou tout redémarrer
./start.sh restart
```

---

## Erreur : Ollama ne se connecte pas

### Vérifications

```bash
# 1. Vérifier qu'Ollama tourne
docker-compose ps ollama

# 2. Tester l'API Ollama
curl http://localhost:11434/api/tags

# 3. Voir les logs
docker-compose logs ollama
```

### Solution

```bash
# Redémarrer Ollama
docker-compose restart ollama

# Attendre 10 secondes
sleep 10

# Vérifier à nouveau
curl http://localhost:11434/api/tags
```

---

## Erreur : "Failed to pull model"

### Cause
Problème réseau ou espace disque insuffisant.

### Solution

```bash
# Vérifier l'espace disque
df -h

# Voir les logs de téléchargement
docker-compose logs ollama-setup

# Réessayer manuellement
docker-compose exec ollama ollama pull codellama
```

---

## Erreur : Version de Docker trop ancienne

### Vérification

```bash
docker --version
docker-compose --version
```

### Solution

Mettre à jour Docker :
- **macOS/Windows** : Mettre à jour Docker Desktop
- **Linux** : Suivre https://docs.docker.com/engine/install/

Versions minimales requises :
- Docker : 20.10+
- Docker Compose : 2.0+

---

## Mode Debug Complet

Pour investiguer en profondeur :

```bash
# 1. Arrêter tout
docker-compose down -v

# 2. Reconstruire sans cache
docker-compose build --no-cache --progress=plain

# 3. Démarrer en mode verbose
docker-compose up

# 4. Dans un autre terminal, voir les logs en direct
docker-compose logs -f app
docker-compose logs -f ollama

# 5. Entrer dans le conteneur
docker-compose exec app sh
```

---

## Commandes de Diagnostic Utiles

```bash
# Voir l'utilisation des ressources
docker stats

# Voir les processus dans un conteneur
docker-compose top app

# Inspecter un conteneur
docker inspect ai-agent-app

# Voir les réseaux Docker
docker network ls
docker network inspect ai-agent-network

# Voir les volumes
docker volume ls
docker volume inspect ai-coding-agent_ollama_data

# Logs de build
docker-compose build app 2>&1 | tee build.log
```

---

## Réinitialisation Complète

Si rien ne fonctionne, réinitialisation totale :

```bash
# ATTENTION : Cela supprime TOUT (y compris les modèles téléchargés)

# 1. Arrêter et supprimer tout
docker-compose down -v

# 2. Supprimer l'image
docker rmi ai-coding-agent-app

# 3. Nettoyer le système Docker
docker system prune -a --volumes

# 4. Supprimer le dossier node_modules local (si présent)
rm -rf node_modules

# 5. Redémarrer
./start.sh start

# Les modèles devront être retéléchargés (~4-5 GB)
```

---

## Besoin d'Aide ?

Si le problème persiste :

1. Vérifier les logs complets : `docker-compose logs > debug.log`
2. Noter la version de Docker : `docker --version`
3. Noter l'OS : `uname -a` (Linux/Mac) ou version Windows
4. Contacter : johan@nantares.consulting

---

## Logs Utiles à Partager

Lors d'une demande de support, joindre :

```bash
# Informations système
docker version > debug-info.txt
docker-compose version >> debug-info.txt
uname -a >> debug-info.txt

# Logs des conteneurs
docker-compose logs > debug-logs.txt

# État des conteneurs
docker-compose ps >> debug-info.txt

# Espace disque
df -h >> debug-info.txt
docker system df >> debug-info.txt
```
