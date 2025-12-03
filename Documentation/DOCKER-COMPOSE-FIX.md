# 🔧 Fix - docker-compose: command not found

## 🔴 Erreur
```
./start.sh: line 70: docker-compose: command not found
```

## ❓ Cause

Vous avez Docker Desktop moderne qui utilise `docker compose` (avec un espace) au lieu de `docker-compose` (avec un tiret).

**Versions :**
- **Ancienne** : `docker-compose` (commande standalone)
- **Nouvelle** : `docker compose` (intégré à Docker CLI)

## ✅ Solution Immédiate

### Le Script est Maintenant Corrigé

L'archive finale contient déjà le fix. Si vous avez l'erreur :

```bash
# Re-télécharger et extraire l'archive mise à jour
tar -xzf ai-coding-agent-final.tar.gz
cd ai-coding-agent

# Ça devrait fonctionner maintenant
./start.sh
```

### Vérifier Quelle Version Vous Avez

```bash
# Tester docker-compose (ancienne version)
docker-compose version

# Tester docker compose (nouvelle version)
docker compose version
```

## 🛠️ Solutions Alternatives

### Option 1 : Créer un Alias (Temporaire)

```bash
# Dans votre terminal actuel
alias docker-compose='docker compose'

# Puis lancer
./start.sh
```

### Option 2 : Utiliser Docker Compose Directement

Au lieu de `./start.sh`, utilisez directement :

```bash
# Démarrer
docker compose -f docker-compose.nohealth.yml up -d

# Voir les logs
docker compose -f docker-compose.nohealth.yml logs -f

# Arrêter
docker compose -f docker-compose.nohealth.yml down
```

### Option 3 : Installer docker-compose Standalone

**macOS (Homebrew)** :
```bash
brew install docker-compose
```

**Linux** :
```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

**Windows** :
Docker Desktop inclut déjà `docker compose`, utilisez PowerShell ou Git Bash.

## 🔍 Comment Fonctionne le Fix

Le script `start.sh` détecte maintenant automatiquement la bonne commande :

```bash
# Détection automatique
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
elif docker compose version &> /dev/null 2>&1; then
    DOCKER_COMPOSE="docker compose"
fi

# Puis utilise $DOCKER_COMPOSE partout
$DOCKER_COMPOSE -f docker-compose.nohealth.yml up -d
```

## ✅ Vérification

Après avoir appliqué le fix :

```bash
# Le script devrait afficher la version détectée
./start.sh

# Vous devriez voir quelque chose comme :
# [AI-Agent] Utilisation de docker-compose.nohealth.yml...
# Creating ai-agent-ollama ... done
```

## 📝 Pour les Autres Scripts

Si vous voyez l'erreur dans d'autres scripts :

### diagnose.sh
Remplacez `docker-compose` par :
```bash
docker compose -f docker-compose.nohealth.yml
```

### clean-all.sh
Remplacez `docker-compose` par :
```bash
docker compose -f docker-compose.nohealth.yml
```

Ou sourcez le wrapper :
```bash
source ./docker-compose-wrapper.sh
$DOCKER_COMPOSE -f docker-compose.nohealth.yml ...
```

## 🎯 Commandes de Remplacement Manuel

Si vous ne voulez pas attendre le fix, voici les commandes équivalentes :

| Avec start.sh | Sans start.sh |
|---------------|---------------|
| `./start.sh` | `docker compose -f docker-compose.nohealth.yml up -d` |
| `./start.sh stop` | `docker compose -f docker-compose.nohealth.yml down` |
| `./start.sh logs` | `docker compose -f docker-compose.nohealth.yml logs -f` |
| `./start.sh restart` | `docker compose -f docker-compose.nohealth.yml restart` |
| `./start.sh status` | `docker compose -f docker-compose.nohealth.yml ps` |

## 🆘 Si Ça Ne Fonctionne Toujours Pas

```bash
# Vérifier que Docker est bien installé
docker --version

# Vérifier que Docker Compose fonctionne
docker compose version

# Si aucune des deux commandes ne fonctionne
# Réinstallez Docker Desktop : https://www.docker.com/products/docker-desktop
```

## 📚 Liens Utiles

- [Docker Compose v2 Documentation](https://docs.docker.com/compose/cli-command/)
- [Migration de v1 à v2](https://docs.docker.com/compose/migrate/)

---

**TL;DR** :
```bash
# L'archive finale est déjà corrigée
tar -xzf ai-coding-agent-final.tar.gz
./start.sh

# Ou utiliser directement
docker compose -f docker-compose.nohealth.yml up -d
```
