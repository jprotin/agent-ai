# 📚 Documentation - Index Complet

## 🚀 Pour Démarrer (Nouveaux Utilisateurs)

**Lisez dans cet ordre :**

1. **README.md** - Vue d'ensemble du projet
2. **DOCKER-QUICKSTART.md** - Installation en 3 commandes
3. **QUICKSTART.md** - Guide de démarrage rapide

## 🐛 En Cas de Problème

### Erreurs Courantes

| Erreur | Document à Consulter |
|--------|---------------------|
| `npm ci failed` | **QUICKFIX.md** ou **QUICK-CONTAINERCONFIG.md** |
| `Container is unhealthy` | **HEALTHCHECK-FIX.md** |
| `ContainerConfig KeyError` | **QUICK-CONTAINERCONFIG.md** |
| Build qui échoue | **BUILD-TROUBLESHOOTING.md** |
| Erreur 500 dans le chat | **ERROR-500-FIX.md** |
| Pas de modèle installé | **INSTALL-MODEL.md** |
| Autre problème | **TROUBLESHOOTING.md** |

### Guides de Résolution Rapides

- **QUICKFIX.md** - Solution en 30 secondes pour npm ci
- **QUICK-CONTAINERCONFIG.md** - Solution en 1 minute pour ContainerConfig
- **HEALTHCHECK-FIX.md** - Guide complet healthcheck

## 📖 Documentation Technique

### Docker

- **DOCKER.md** - Guide Docker complet (installation, configuration, déploiement)
- **DOCKER-QUICKSTART.md** - Démarrage rapide Docker en 3 commandes
- **DOCKER-VERSIONS.md** - Comparatif des 3 versions Docker disponibles

### Dépannage

- **TROUBLESHOOTING.md** - Guide exhaustif de tous les problèmes possibles
- **BUILD-TROUBLESHOOTING.md** - Problèmes spécifiques au build
- **CONTAINERCONFIG-FIX.md** - Erreur ContainerConfig détaillée
- **HEALTHCHECK-FIX.md** - Erreur healthcheck détaillée

### Corrections Appliquées

- **FIXES.md** - Historique des corrections npm ci
- **QUICK-CONTAINERCONFIG.md** - Résumé des corrections ContainerConfig

## 🛠️ Scripts Disponibles

| Script | Description |
|--------|-------------|
| `start.sh` | Script principal (démarrer, arrêter, logs, etc.) |
| `clean-all.sh` | Nettoyage complet des conteneurs |
| `check-before-build.sh` | Vérifications pré-build |

### Commandes start.sh

```bash
./start.sh                      # Démarrer
./start.sh stop                 # Arrêter
./start.sh restart              # Redémarrer
./start.sh logs                 # Voir les logs
./start.sh status               # Statut des services
./start.sh clean-containers     # Nettoyer les conteneurs
./start.sh clean                # Nettoyer tout
./start.sh pull-model llama3    # Télécharger un modèle
./start.sh list-models          # Lister les modèles
./start.sh rebuild              # Reconstruire l'app
./start.sh shell                # Shell dans le conteneur app
./start.sh ollama-shell         # Shell dans le conteneur ollama
```

## 🐳 Versions Docker

Le projet inclut 3 configurations Docker :

| Fichier | Usage | Fiabilité |
|---------|-------|-----------|
| **docker-compose.nohealth.yml** | Par défaut | ⭐⭐⭐⭐⭐ |
| **docker-compose.simple.yml** | Développement | ⭐⭐⭐⭐ |
| **docker-compose.yml** | Production | ⭐⭐⭐ |

Voir **DOCKER-VERSIONS.md** pour les détails.

## 📁 Structure du Projet

```
ai-coding-agent/
├── app/                        # Application Next.js
│   ├── api/                    # API Routes
│   │   ├── chat/              # Communication avec Ollama
│   │   └── generate-code/     # Génération de fichiers
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx
├── components/
│   ├── ui/                    # Composants shadcn/ui
│   └── ai-agent.tsx           # Composant principal
├── lib/
│   ├── ollama.ts              # Service Ollama
│   └── utils.ts
├── examples/
│   └── spec-calculatrice.md   # Exemple de spécification
├── output/                     # Fichiers générés (créé auto)
│
├── Docker
├── Dockerfile                  # Build multi-stage optimisé
├── Dockerfile.simple           # Build simple
├── docker-compose.yml          # Config production
├── docker-compose.simple.yml   # Config dev
├── docker-compose.nohealth.yml # Config max compatibilité
├── .dockerignore
│
├── Scripts
├── start.sh                    # Script principal
├── clean-all.sh               # Nettoyage
├── check-before-build.sh      # Vérifications
│
├── Configuration
├── package.json
├── package-lock.json
├── next.config.js
├── tailwind.config.ts
├── tsconfig.json
├── postcss.config.js
│
└── Documentation
    ├── README.md                      # Vue d'ensemble
    ├── INDEX.md                       # Ce fichier
    ├── QUICKSTART.md                  # Démarrage rapide
    ├── DOCKER-QUICKSTART.md           # Démarrage Docker
    ├── DOCKER.md                      # Guide Docker complet
    ├── DOCKER-VERSIONS.md             # Comparatif versions
    ├── QUICKFIX.md                    # Fix npm ci
    ├── QUICK-CONTAINERCONFIG.md       # Fix ContainerConfig
    ├── TROUBLESHOOTING.md             # Dépannage général
    ├── BUILD-TROUBLESHOOTING.md       # Dépannage build
    ├── CONTAINERCONFIG-FIX.md         # Fix ContainerConfig détaillé
    ├── HEALTHCHECK-FIX.md             # Fix healthcheck détaillé
    └── FIXES.md                       # Historique corrections
```

## 🎯 Workflows Recommandés

### Première Installation

```bash
1. Lire README.md
2. Lire DOCKER-QUICKSTART.md
3. ./start.sh
4. Si erreur → Consulter la section "En Cas de Problème" ci-dessus
```

### Développement Quotidien

```bash
# Démarrer
./start.sh

# Arrêter proprement en fin de journée
./start.sh stop
```

### En Cas de Problème

```bash
1. Identifier l'erreur dans les logs
2. Consulter l'INDEX (ce fichier) pour trouver le bon document
3. Suivre le guide de résolution
4. Si ça ne fonctionne pas → TROUBLESHOOTING.md
```

### Déploiement Production

```bash
1. Lire DOCKER.md section "Production"
2. Tester avec docker-compose.simple.yml d'abord
3. Migrer vers docker-compose.yml si stable
4. Voir DOCKER-VERSIONS.md pour choisir
```

## 🔍 Recherche Rapide

### Je veux...

- **Démarrer rapidement** → DOCKER-QUICKSTART.md
- **Comprendre le projet** → README.md
- **Résoudre une erreur** → Voir tableau "Erreurs Courantes" ci-dessus
- **Configurer Docker** → DOCKER.md
- **Choisir une version Docker** → DOCKER-VERSIONS.md
- **Nettoyer complètement** → QUICK-CONTAINERCONFIG.md
- **Télécharger un modèle** → DOCKER.md section "Modèles"
- **Déployer en production** → DOCKER.md section "Production"
- **Débugger un problème** → TROUBLESHOOTING.md
- **Voir les versions disponibles** → DOCKER-VERSIONS.md

## 📊 Flux de Décision

```
Erreur rencontrée ?
│
├─ npm ci failed → QUICKFIX.md
│
├─ Container is unhealthy → HEALTHCHECK-FIX.md
│
├─ ContainerConfig error → QUICK-CONTAINERCONFIG.md
│
├─ Build qui échoue → BUILD-TROUBLESHOOTING.md
│
└─ Autre erreur → TROUBLESHOOTING.md
```

## 🆘 Support

### Avant de Demander de l'Aide

1. Consultez l'INDEX (ce fichier)
2. Lisez le guide correspondant à votre erreur
3. Essayez `./clean-all.sh` puis `./start.sh`
4. Consultez TROUBLESHOOTING.md

### Informations à Fournir

```bash
# Collecter les infos
docker version > support-info.txt
docker-compose version >> support-info.txt
./start.sh status >> support-info.txt
docker ps -a >> support-info.txt
docker logs ai-agent-ollama >> support-info.txt 2>&1
docker logs ai-agent-app >> support-info.txt 2>&1
```

Contact : johan@nantares.consulting

## 📝 Notes

- Tous les guides incluent des exemples concrets
- La documentation est organisée par niveau de difficulté
- Les fichiers QUICK-* sont des raccourcis vers les solutions
- Les fichiers *-FIX.md sont des guides détaillés
- TROUBLESHOOTING.md est le guide ultime si rien ne fonctionne

---

**Conseil** : Commencez toujours par les fichiers QUICK-* pour une solution rapide, puis consultez les guides détaillés si nécessaire. 🎯
