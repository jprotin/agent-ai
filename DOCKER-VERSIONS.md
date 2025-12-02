# 🐳 Versions Docker Disponibles

## Trois versions pour tous les cas de figure

### 🟢 Version 1 : docker-compose.nohealth.yml (RECOMMANDÉE)

**Utilisation par défaut avec `./start.sh`**

✅ **Avantages** :
- Aucun problème de healthcheck
- Maximum de compatibilité
- Démarrage le plus fiable
- Idéal pour débuter

❌ **Inconvénients** :
- Pas de vérification automatique qu'Ollama est prêt
- Nécessite d'attendre un peu manuellement

**Quand l'utiliser** :
- Première installation
- Si vous avez des erreurs "Container is unhealthy"
- Si vous voulez la solution la plus simple
- Développement local

**Démarrer** :
```bash
./start.sh
# ou
docker-compose -f docker-compose.nohealth.yml up -d
```

---

### 🟡 Version 2 : docker-compose.simple.yml

**Build simplifié avec healthcheck amélioré**

✅ **Avantages** :
- Healthcheck qui attend plus longtemps (60s de start_period)
- Build simple et rapide
- Vérification qu'Ollama est prêt

❌ **Inconvénients** :
- Image Docker plus volumineuse (~500MB)
- Peut encore avoir des problèmes de healthcheck selon l'environnement

**Quand l'utiliser** :
- Si docker-compose.nohealth.yml fonctionne et que vous voulez un healthcheck
- Développement avec validation automatique
- Tests automatisés

**Démarrer** :
```bash
docker-compose -f docker-compose.simple.yml up -d
```

---

### 🔴 Version 3 : docker-compose.yml

**Build multi-stage optimisé avec healthcheck**

✅ **Avantages** :
- Image finale très légère (~100MB)
- Optimisé pour la production
- Build multi-stage sécurisé

❌ **Inconvénients** :
- Build plus complexe (peut échouer)
- Healthcheck peut être problématique
- Temps de build plus long

**Quand l'utiliser** :
- Production avec ressources limitées
- Déploiement cloud où la taille compte
- Une fois que tout fonctionne en dev

**Démarrer** :
```bash
COMPOSE_FILE_OVERRIDE=1 ./start.sh
# ou
docker-compose -f docker-compose.yml up -d
```

---

## 📊 Tableau Comparatif

| Critère | nohealth | simple | optimisé |
|---------|----------|--------|----------|
| **Fiabilité** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Simplicité** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |
| **Taille image** | 500MB | 500MB | 100MB |
| **Temps build** | 2-5min | 2-5min | 5-10min |
| **Healthcheck** | ❌ Non | ✅ Oui | ✅ Oui |
| **Production** | ⚠️ OK | ⚠️ OK | ✅ Idéal |

---

## 🎯 Guide de Choix Rapide

### Vous êtes dans quelle situation ?

**"Je veux juste que ça marche !"**
→ Utilisez `./start.sh` (docker-compose.nohealth.yml)

**"J'ai eu l'erreur 'Container is unhealthy'"**
→ Utilisez `./start.sh` (docker-compose.nohealth.yml)

**"J'ai eu l'erreur 'npm ci failed'"**
→ Utilisez docker-compose.simple.yml ou docker-compose.nohealth.yml

**"Ça fonctionne, je veux optimiser pour la prod"**
→ Essayez docker-compose.yml (version optimisée)

**"Je vais déployer sur un serveur"**
→ Utilisez docker-compose.yml si ça build, sinon docker-compose.simple.yml

---

## 🔄 Migration Entre Versions

### De nohealth vers simple

```bash
# Arrêter
docker-compose -f docker-compose.nohealth.yml down

# Démarrer avec simple
docker-compose -f docker-compose.simple.yml up -d --build
```

### De simple vers optimisé

```bash
# Arrêter
docker-compose -f docker-compose.simple.yml down

# Build optimisé
docker-compose -f docker-compose.yml build

# Démarrer
docker-compose -f docker-compose.yml up -d
```

### Revenir à nohealth (si problème)

```bash
# Arrêter tout
docker-compose down

# Redémarrer avec nohealth
./start.sh
```

---

## 🛠️ Fichiers de Configuration

```
ai-coding-agent/
├── docker-compose.nohealth.yml  ← Par défaut (./start.sh)
├── docker-compose.simple.yml    ← Alternative fiable
├── docker-compose.yml           ← Production optimisée
├── Dockerfile                   ← Multi-stage optimisé
└── Dockerfile.simple            ← Build simple
```

---

## 💡 Recommandations

### Pour le Développement
1. Commencez avec `./start.sh` (nohealth)
2. Une fois stable, passez à simple si vous voulez des healthchecks
3. Gardez nohealth si tout fonctionne bien

### Pour la Production
1. Testez d'abord avec simple en environnement de staging
2. Si stable, migrez vers optimisé pour économiser les ressources
3. Gardez simple si vous avez des contraintes de temps

### Pour le Debug
1. Toujours revenir à nohealth.yml en cas de problème
2. Vérifier les logs : `docker-compose logs -f`
3. Tester chaque service individuellement

---

## 📚 Documentation Associée

- **QUICKFIX.md** - Résolution rapide erreur npm ci
- **HEALTHCHECK-FIX.md** - Résolution erreur unhealthy
- **BUILD-TROUBLESHOOTING.md** - Guide complet de dépannage
- **DOCKER.md** - Documentation Docker complète

---

## 🆘 En Cas de Doute

```bash
# La commande magique qui fonctionne toujours
./start.sh
```

Cette commande utilise automatiquement la version la plus fiable (nohealth) ! 🎉
