# 🐛 Guide de Résolution - Erreur npm ci

## Problème
```
ERROR: failed to solve: process "/bin/sh -c npm ci" did not complete successfully
```

## Solutions par Ordre de Simplicité

### ✅ Solution 1 : Version Simplifiée (RECOMMANDÉE pour debug)

Utilisez le Dockerfile simplifié qui évite les builds multi-stage complexes :

```bash
# Utiliser le docker-compose simplifié
docker-compose -f docker-compose.simple.yml up -d --build

# Ou avec le script
./start.sh
```

**Avantages** :
- Build plus simple, moins de points de défaillance
- Messages d'erreur plus clairs
- Utilise `npm install` au lieu de `npm ci`

### ✅ Solution 2 : Dockerfile Principal Corrigé

Le Dockerfile principal a été modifié pour utiliser `npm install` :

```bash
# Build normal
docker-compose up -d --build
```

### ✅ Solution 3 : Build Manuel avec Logs Détaillés

Pour voir exactement où ça bloque :

```bash
# Build avec logs complets
docker-compose build --no-cache --progress=plain app 2>&1 | tee build.log

# Examiner le fichier build.log pour voir l'erreur exacte
```

### ✅ Solution 4 : Build Local d'Abord

Testez le build localement avant Docker :

```bash
# Installer localement
npm install

# Build localement
npm run build

# Si ça fonctionne, alors build Docker
docker-compose up -d --build
```

## Vérifications Importantes

### 1. Vérifier que package.json est valide

```bash
# Valider la syntaxe JSON
cat package.json | jq '.'

# Si erreur, corriger le JSON
```

### 2. Vérifier les dépendances

```bash
# Voir si toutes les dépendances sont disponibles
npm install --dry-run
```

### 3. Vérifier la connectivité npm

```bash
# Tester l'accès au registre npm
curl https://registry.npmjs.org/

# Depuis Docker
docker run --rm node:18-alpine sh -c "npm install -g cowsay"
```

### 4. Vérifier l'espace disque Docker

```bash
# Voir l'espace utilisé
docker system df

# Nettoyer si nécessaire
docker system prune -a
```

## Différences entre les Versions

### Dockerfile (Principal)
- Build multi-stage optimisé
- Image finale plus légère (~100MB)
- Plus complexe, plus de points de défaillance
- Utilise maintenant `npm install` au lieu de `npm ci`

### Dockerfile.simple
- Build simple en une étape
- Image plus volumineuse (~500MB)
- Moins de problèmes de compatibilité
- Idéal pour le développement et debug

## Commandes de Debug Avancées

### Entrer dans l'image pendant le build

```bash
# Build jusqu'à une étape spécifique
docker build --target deps -t debug-deps .

# Entrer dans l'image
docker run -it debug-deps sh

# À l'intérieur, tester manuellement
npm install
```

### Voir exactement ce qui est copié

```bash
# Lister les fichiers qui seront dans le contexte Docker
tar -czf - . | tar -tzf - | grep -v node_modules | head -50
```

### Tester avec différentes versions de Node

```bash
# Modifier temporairement dans Dockerfile
FROM node:18-alpine  # Version actuelle
FROM node:20-alpine  # Version plus récente
FROM node:16-alpine  # Version plus ancienne
```

## Script de Test Automatique

```bash
#!/bin/bash

echo "=== Test 1: Validation package.json ==="
cat package.json | jq '.' || exit 1

echo "=== Test 2: npm install local ==="
npm install || exit 1

echo "=== Test 3: npm build local ==="
npm run build || exit 1

echo "=== Test 4: Docker build simple ==="
docker build -f Dockerfile.simple -t test-simple . || exit 1

echo "=== Test 5: Docker build principal ==="
docker build -f Dockerfile -t test-main . || exit 1

echo "✅ Tous les tests passés!"
```

Sauvegardez ce script dans `test-build.sh`, rendez-le exécutable et lancez-le :

```bash
chmod +x test-build.sh
./test-build.sh
```

## Quelle Version Utiliser ?

### Utilisez `docker-compose.simple.yml` si :
- ❌ Le build échoue avec la version principale
- 🐛 Vous êtes en phase de développement/debug
- 🚀 Vous voulez démarrer rapidement
- 📊 La taille de l'image n'est pas critique

### Utilisez `docker-compose.yml` (principal) si :
- ✅ Le build fonctionne
- 📦 Vous voulez une image optimisée pour la production
- 💾 Vous voulez économiser l'espace disque
- 🏭 Vous déployez en production

## Commande Rapide

Pour démarrer avec la version simple :

```bash
# Arrêter tout
docker-compose down

# Démarrer avec la version simple
docker-compose -f docker-compose.simple.yml up -d --build

# Voir les logs
docker-compose -f docker-compose.simple.yml logs -f app
```

## Support

Si l'erreur persiste même avec la version simple :

1. Collectez les informations :
```bash
docker version > debug-info.txt
node --version >> debug-info.txt
npm --version >> debug-info.txt
docker-compose build --progress=plain app > build.log 2>&1
```

2. Vérifiez `build.log` pour l'erreur exacte

3. Contactez : johan@nantares.consulting
