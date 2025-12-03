# 📚 Documentation - Index Complet

<div align="center">

**Guide de navigation de toute la documentation du projet**

*Agent IA de Développement - Nantares Consulting*

</div>

---

## 🗂️ Organisation de la Documentation

Toute la documentation est maintenant centralisée dans le répertoire `Documentation/`. Ce fichier INDEX vous guide vers le bon document selon vos besoins.

---

## 🚀 Pour Démarrer (Nouveaux Utilisateurs)

**Lisez dans cet ordre pour une prise en main rapide :**

1. **[../README.md](../README.md)** - 📖 Vue d'ensemble complète du projet
2. **[DOCKER-QUICKSTART.md](DOCKER-QUICKSTART.md)** - 🐳 Installation Docker en 3 commandes
3. **[QUICKSTART.md](QUICKSTART.md)** - ⚡ Guide de démarrage rapide
4. **[START-HERE.md](START-HERE.md)** - 👋 Guide express 2 minutes

**Temps total : 10 minutes pour tout comprendre et démarrer**

---

## 🐛 En Cas de Problème

### Tableau de Diagnostic Rapide

| Symptôme | Document à Consulter | Temps de Résolution |
|----------|---------------------|---------------------|
| `npm ci failed` | **[QUICKFIX.md](QUICKFIX.md)** | 30 secondes |
| `ContainerConfig KeyError` | **[QUICK-CONTAINERCONFIG.md](QUICK-CONTAINERCONFIG.md)** | 1 minute |
| `Container is unhealthy` | **[HEALTHCHECK-FIX.md](HEALTHCHECK-FIX.md)** | 2-5 minutes |
| Build qui échoue | **[BUILD-TROUBLESHOOTING.md](BUILD-TROUBLESHOOTING.md)** | 5-10 minutes |
| Erreur 500 dans le chat | **[ERROR-500-FIX.md](ERROR-500-FIX.md)** | 3-5 minutes |
| Erreur 404 | **[FIXING-404-ERROR.md](FIXING-404-ERROR.md)** | 2 minutes |
| Transport endpoint | **[TRANSPORT-ENDPOINT-FIX.md](TRANSPORT-ENDPOINT-FIX.md)** | 5 minutes |
| Erreur frontend | **[FRONTEND-ERROR-FIX.md](FRONTEND-ERROR-FIX.md)** | 5 minutes |
| Pas de modèle installé | **[INSTALL-MODEL.md](INSTALL-MODEL.md)** | 5-15 minutes |
| Autre problème | **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** | Variable |

### Guides de Résolution Rapides

Les guides **QUICK-*** sont des solutions express :

- **[QUICKFIX.md](QUICKFIX.md)** - 🚑 Solution en 30 secondes pour npm ci
- **[QUICK-CONTAINERCONFIG.md](QUICK-CONTAINERCONFIG.md)** - 🚑 Solution en 1 minute pour ContainerConfig
- **[HEALTHCHECK-FIX.md](HEALTHCHECK-FIX.md)** - 🏥 Guide complet healthcheck

---

## 📖 Documentation Technique

### 🐳 Docker & Déploiement

| Document | Description | Audience |
|----------|-------------|----------|
| **[DOCKER.md](DOCKER.md)** | Guide Docker complet (installation, config, déploiement) | Tous |
| **[DOCKER-QUICKSTART.md](DOCKER-QUICKSTART.md)** | Démarrage rapide Docker en 3 commandes | Débutants |
| **[DOCKER-VERSIONS.md](DOCKER-VERSIONS.md)** | Comparatif des 3 versions Docker disponibles | Avancés |
| **[DOCKER-COMPOSE-FIX.md](DOCKER-COMPOSE-FIX.md)** | Corrections Docker Compose | Dépannage |

### 🤖 Modèles LLM

| Document | Description | Audience |
|----------|-------------|----------|
| **[MODELES-LLM.md](MODELES-LLM.md)** | 🆕 Guide exhaustif de tous les modèles LLM | Tous |
| **[INSTALL-MODEL.md](INSTALL-MODEL.md)** | Installation et gestion des modèles | Tous |
| **[MEMORY-REQUIREMENTS.md](MEMORY-REQUIREMENTS.md)** | Configuration RAM requise | Tous |

**Nouveau** : Le document **MODELES-LLM.md** contient maintenant :
- ✅ Tableau récapitulatif de 15+ modèles
- ✅ Comparaison détaillée des performances
- ✅ Recommandations selon votre config
- ✅ Benchmarks réels
- ✅ Guide de sélection

### 🔧 Dépannage & Résolution

| Document | Description | Complexité |
|----------|-------------|------------|
| **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** | Guide exhaustif de tous les problèmes | ⭐⭐⭐ |
| **[BUILD-TROUBLESHOOTING.md](BUILD-TROUBLESHOOTING.md)** | Problèmes spécifiques au build | ⭐⭐ |
| **[CONTAINERCONFIG-FIX.md](CONTAINERCONFIG-FIX.md)** | Erreur ContainerConfig détaillée | ⭐⭐ |
| **[HEALTHCHECK-FIX.md](HEALTHCHECK-FIX.md)** | Erreur healthcheck détaillée | ⭐⭐ |
| **[ERROR-500-FIX.md](ERROR-500-FIX.md)** | Erreur 500 serveur | ⭐⭐ |
| **[FRONTEND-ERROR-FIX.md](FRONTEND-ERROR-FIX.md)** | Erreurs frontend | ⭐ |
| **[FIXING-404-ERROR.md](FIXING-404-ERROR.md)** | Erreur 404 | ⭐ |
| **[TRANSPORT-ENDPOINT-FIX.md](TRANSPORT-ENDPOINT-FIX.md)** | Transport endpoint not connected | ⭐⭐ |

### 📜 Historiques & Corrections

| Document | Description |
|----------|-------------|
| **[FIXES.md](FIXES.md)** | Historique des corrections npm ci |
| **[ALL-FIXES.md](ALL-FIXES.md)** | Historique complet de toutes les corrections |
| **[QUICK-CONTAINERCONFIG.md](QUICK-CONTAINERCONFIG.md)** | Résumé des corrections ContainerConfig |

### 🔄 Migration & Évolution

| Document | Description |
|----------|-------------|
| **[CLAUDE-CODE-MIGRATION.md](CLAUDE-CODE-MIGRATION.md)** | Migration vers Claude Code |

---

## 🛠️ Scripts & Commandes

### Script Principal : start.sh

Le script **start.sh** centralise toutes les opérations :

```bash
./start.sh                      # Démarrer l'application
./start.sh stop                 # Arrêter proprement
./start.sh restart              # Redémarrer
./start.sh logs                 # Voir les logs en temps réel
./start.sh status               # Statut des services
./start.sh pull-model <nom>     # Télécharger un modèle LLM
./start.sh list-models          # Lister les modèles installés
./start.sh clean                # Nettoyer tout
./start.sh clean-containers     # Nettoyer les conteneurs
./start.sh rebuild              # Reconstruire l'app
./start.sh shell                # Shell dans le conteneur app
./start.sh ollama-shell         # Shell dans le conteneur ollama
```

### Autres Scripts

| Script | Description | Usage |
|--------|-------------|-------|
| **clean-all.sh** | Nettoyage complet | `./clean-all.sh` |
| **diagnose.sh** | Diagnostic système | `./diagnose.sh` |
| **check-memory.sh** | Vérification RAM | `./check-memory.sh` |
| **test-ollama.sh** | Test connexion Ollama | `./test-ollama.sh` |

---

## 🐳 Versions Docker

Le projet inclut **3 configurations Docker** selon vos besoins :

| Fichier | Usage | Fiabilité | Quand l'utiliser |
|---------|-------|-----------|------------------|
| **docker-compose.nohealth.yml** | Par défaut | ⭐⭐⭐⭐⭐ | Production stable |
| **docker-compose.simple.yml** | Développement | ⭐⭐⭐⭐ | Dev & tests |
| **docker-compose.yml** | Production | ⭐⭐⭐ | Prod avec monitoring |

📖 **Détails** : Voir **[DOCKER-VERSIONS.md](DOCKER-VERSIONS.md)** pour comparatif complet

---

## 📁 Structure du Projet

```
agent-ai/
├── 📱 app/                          # Application Next.js 14
│   ├── api/                        # Routes API
│   │   ├── chat/                   # Communication avec Ollama
│   │   ├── generate-code/          # Génération de fichiers
│   │   ├── download/               # Téléchargement individuel
│   │   └── download-zip/           # Téléchargement ZIP
│   ├── lib/
│   │   └── ollama.ts               # Service Ollama
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx
│
├── 🎨 components/
│   ├── ui/                         # Composants shadcn/ui
│   └── ai-agent.tsx                # Composant principal
│
├── 📝 examples/
│   └── spec-calculatrice.md        # Exemple de spécification
│
├── 💾 output/                       # Fichiers générés (auto-créé)
│   └── session_YYYYMMDD_HHMMSS/   # Sessions horodatées
│
├── 📚 Documentation/                # 📖 TOUTE LA DOCUMENTATION
│   ├── INDEX.md                    # ⬅️ Vous êtes ici !
│   │
│   ├── 🚀 Démarrage
│   ├── START-HERE.md               # Guide express 2 min
│   ├── QUICKSTART.md               # Démarrage rapide
│   ├── DOCKER-QUICKSTART.md        # Docker 3 commandes
│   │
│   ├── 🐳 Docker
│   ├── DOCKER.md                   # Guide complet
│   ├── DOCKER-VERSIONS.md          # Comparatif configs
│   ├── DOCKER-COMPOSE-FIX.md       # Corrections
│   │
│   ├── 🤖 LLM
│   ├── MODELES-LLM.md              # 🆕 Guide complet LLM
│   ├── INSTALL-MODEL.md            # Installation modèles
│   ├── MEMORY-REQUIREMENTS.md      # Config RAM
│   │
│   ├── 🐛 Dépannage
│   ├── TROUBLESHOOTING.md          # Guide exhaustif
│   ├── BUILD-TROUBLESHOOTING.md    # Problèmes build
│   ├── ERROR-500-FIX.md            # Erreur 500
│   ├── FRONTEND-ERROR-FIX.md       # Erreurs frontend
│   ├── FIXING-404-ERROR.md         # Erreur 404
│   ├── HEALTHCHECK-FIX.md          # Healthcheck
│   ├── CONTAINERCONFIG-FIX.md      # ContainerConfig
│   ├── TRANSPORT-ENDPOINT-FIX.md   # Transport endpoint
│   │
│   ├── 🚑 Fixes Rapides
│   ├── QUICKFIX.md                 # npm ci (30s)
│   ├── QUICK-CONTAINERCONFIG.md    # ContainerConfig (1min)
│   │
│   ├── 📜 Historiques
│   ├── FIXES.md                    # Historique corrections
│   ├── ALL-FIXES.md                # Toutes les corrections
│   │
│   └── 🔄 Migration
│       └── CLAUDE-CODE-MIGRATION.md # Migration Claude Code
│
├── 🐳 Docker
├── Dockerfile                      # Build multi-stage
├── Dockerfile.simple               # Build simple
├── docker-compose.yml              # Config production
├── docker-compose.simple.yml       # Config dev
└── docker-compose.nohealth.yml     # Config max compatibilité
│
├── 🔧 Scripts
├── start.sh                        # Script principal ⭐
├── clean-all.sh                   # Nettoyage complet
├── diagnose.sh                    # Diagnostic
├── check-memory.sh                # Vérif RAM
└── test-ollama.sh                 # Test Ollama
│
└── ⚙️ Configuration
    ├── package.json
    ├── package-lock.json
    ├── next.config.js
    ├── tailwind.config.ts
    ├── tsconfig.json
    └── .gitignore
```

---

## 🎯 Workflows Recommandés

### 🆕 Première Installation

```bash
1. Lire README.md (5 min)
2. Lire Documentation/DOCKER-QUICKSTART.md (2 min)
3. Exécuter : chmod +x start.sh && ./start.sh
4. Si erreur → Consulter le "Tableau de Diagnostic Rapide" ci-dessus
```

**Temps total : ~10 minutes**

### 💼 Développement Quotidien

```bash
# Matin : Démarrer
./start.sh

# Pendant la journée : Monitoring
./start.sh logs        # Si besoin de voir les logs
./start.sh status      # Si besoin de vérifier l'état

# Soir : Arrêter proprement
./start.sh stop
```

### 🐛 En Cas de Problème

```bash
# Étape 1 : Identifier l'erreur
./start.sh logs

# Étape 2 : Consulter ce fichier INDEX.md pour trouver le bon document

# Étape 3 : Suivre le guide de résolution

# Étape 4 : Si ça ne fonctionne pas
./clean-all.sh    # Nettoyage complet
./start.sh        # Redémarrage propre

# Étape 5 : Si toujours bloqué
# → Consulter Documentation/TROUBLESHOOTING.md
```

### 🚀 Déploiement Production

```bash
1. Lire Documentation/DOCKER.md section "Production"
2. Tester avec docker-compose.simple.yml
3. Migrer vers docker-compose.nohealth.yml (plus stable)
4. Voir Documentation/DOCKER-VERSIONS.md pour choisir
```

### 🤖 Changer de Modèle LLM

```bash
# Étape 1 : Consulter les modèles disponibles
# Lire Documentation/MODELES-LLM.md

# Étape 2 : Télécharger le modèle
./start.sh pull-model qwen2.5-coder:7b

# Étape 3 : Changer dans l'interface web
# ou modifier docker-compose.yml (variable OLLAMA_MODEL)
```

---

## 🔍 Recherche Rapide

### Je veux...

| Besoin | Document | Temps |
|--------|----------|-------|
| **Démarrer rapidement** | [DOCKER-QUICKSTART.md](DOCKER-QUICKSTART.md) | 3 min |
| **Comprendre le projet** | [../README.md](../README.md) | 10 min |
| **Résoudre une erreur** | Voir "Tableau de Diagnostic" ci-dessus | Variable |
| **Configurer Docker** | [DOCKER.md](DOCKER.md) | 15 min |
| **Choisir une version Docker** | [DOCKER-VERSIONS.md](DOCKER-VERSIONS.md) | 5 min |
| **Nettoyer complètement** | [QUICK-CONTAINERCONFIG.md](QUICK-CONTAINERCONFIG.md) | 1 min |
| **Télécharger un modèle** | [INSTALL-MODEL.md](INSTALL-MODEL.md) | 10 min |
| **Choisir un modèle LLM** | [MODELES-LLM.md](MODELES-LLM.md) | 10 min |
| **Optimiser les performances** | [MODELES-LLM.md](MODELES-LLM.md) | 15 min |
| **Déployer en production** | [DOCKER.md](DOCKER.md) section "Production" | 20 min |
| **Débugger un problème** | [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | Variable |

---

## 📊 Flux de Décision - Dépannage

```
❓ Erreur rencontrée ?
│
├─ npm ci failed
│  └─→ [QUICKFIX.md](QUICKFIX.md) ⚡ 30s
│
├─ ContainerConfig error
│  └─→ [QUICK-CONTAINERCONFIG.md](QUICK-CONTAINERCONFIG.md) ⚡ 1min
│
├─ Container is unhealthy
│  └─→ [HEALTHCHECK-FIX.md](HEALTHCHECK-FIX.md) 🏥 5min
│
├─ Build qui échoue
│  └─→ [BUILD-TROUBLESHOOTING.md](BUILD-TROUBLESHOOTING.md) 🔨 10min
│
├─ Erreur 500
│  └─→ [ERROR-500-FIX.md](ERROR-500-FIX.md) 🚨 5min
│
├─ Erreur 404
│  └─→ [FIXING-404-ERROR.md](FIXING-404-ERROR.md) 🔍 2min
│
├─ Pas de modèle
│  └─→ [INSTALL-MODEL.md](INSTALL-MODEL.md) 🤖 10min
│
└─ Autre erreur
   └─→ [TROUBLESHOOTING.md](TROUBLESHOOTING.md) 📚 Variable
```

---

## 🆘 Support & Aide

### Avant de Demander de l'Aide

**Checklist obligatoire** :

1. ✅ Ai-je consulté INDEX.md (ce fichier) ?
2. ✅ Ai-je lu le guide correspondant à mon erreur ?
3. ✅ Ai-je essayé `./clean-all.sh` puis `./start.sh` ?
4. ✅ Ai-je consulté TROUBLESHOOTING.md ?

### Collecter les Informations de Diagnostic

Si vous devez demander de l'aide, collectez d'abord ces infos :

```bash
# Créer un fichier de diagnostic complet
{
  echo "=== Versions ==="
  docker version
  docker-compose version
  echo ""
  echo "=== Statut ==="
  ./start.sh status
  echo ""
  echo "=== Conteneurs ==="
  docker ps -a
  echo ""
  echo "=== Logs Ollama ==="
  docker logs ai-agent-ollama --tail 50
  echo ""
  echo "=== Logs App ==="
  docker logs ai-agent-app --tail 50
} > diagnostic.txt

# Envoyer diagnostic.txt avec votre demande
```

### Contact

**Email** : johan@nantares.consulting
**Projet** : Nantares Consulting - Cloud & FinOps Expert

---

## 📝 Notes Importantes

### 📖 Organisation de la Documentation

- ✅ **Nouveauté** : Toute la documentation est dans `Documentation/`
- ✅ Tous les guides incluent des exemples concrets
- ✅ La documentation est organisée par niveau de difficulté
- ✅ Les fichiers **QUICK-*** sont des raccourcis vers les solutions
- ✅ Les fichiers ***-FIX.md** sont des guides détaillés
- ✅ **TROUBLESHOOTING.md** est le guide ultime

### 🎯 Conseils d'Utilisation

- 🚀 **Débutants** : START-HERE.md → DOCKER-QUICKSTART.md
- 💼 **Utilisateurs** : README.md → DOCKER.md
- 🔧 **Avancés** : MODELES-LLM.md → DOCKER-VERSIONS.md
- 🐛 **Problèmes** : Tableau de diagnostic → Guide spécifique

### 🆕 Nouveautés

- ✨ **MODELES-LLM.md** : Guide complet des LLM avec tableaux comparatifs
- 📚 **Documentation centralisée** dans le répertoire `Documentation/`
- 📋 **INDEX.md amélioré** avec navigation optimisée
- 🎨 **README.md** modernisé avec badges et structure claire

---

## 🎓 Parcours d'Apprentissage

### Niveau 1 : Débutant (30 minutes)

1. [../README.md](../README.md) - Vue d'ensemble
2. [DOCKER-QUICKSTART.md](DOCKER-QUICKSTART.md) - Installation
3. [START-HERE.md](START-HERE.md) - Premier lancement
4. **Pratique** : Lancer l'app et générer du code

### Niveau 2 : Utilisateur (1 heure)

1. [DOCKER.md](DOCKER.md) - Comprendre Docker
2. [MODELES-LLM.md](MODELES-LLM.md) - Choisir un modèle
3. [INSTALL-MODEL.md](INSTALL-MODEL.md) - Installer des modèles
4. **Pratique** : Tester différents modèles

### Niveau 3 : Avancé (2 heures)

1. [DOCKER-VERSIONS.md](DOCKER-VERSIONS.md) - Configurations Docker
2. [MODELES-LLM.md](MODELES-LLM.md) - Optimisation LLM
3. [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Dépannage avancé
4. **Pratique** : Optimiser pour votre cas d'usage

---

## 📚 Ressources Externes

### Technologies Utilisées

- **[Ollama](https://ollama.ai/)** - Infrastructure LLM locale
- **[Next.js](https://nextjs.org/)** - Framework React
- **[shadcn/ui](https://ui.shadcn.com/)** - Composants UI
- **[Docker](https://www.docker.com/)** - Conteneurisation

### Modèles LLM

- **[Qwen 2.5](https://github.com/QwenLM/Qwen2.5)** - Modèle par défaut
- **[DeepSeek Coder](https://github.com/deepseek-ai/DeepSeek-Coder)** - Spécialisé code
- **[CodeLlama](https://ai.meta.com/blog/code-llama-large-language-model-coding/)** - Meta AI
- **[Ollama Library](https://ollama.ai/library)** - Tous les modèles

---

## 🔄 Mises à Jour de la Documentation

**Dernière mise à jour** : 2025-12-03

**Changements récents** :
- ✅ Création du répertoire `Documentation/`
- ✅ Centralisation de tous les fichiers markdown
- ✅ Ajout du guide **MODELES-LLM.md** complet
- ✅ Modernisation du README.md
- ✅ Réorganisation de INDEX.md

---

<div align="center">

**💡 Conseil Final**

Commencez toujours par les fichiers **QUICK-*** pour une solution rapide,
puis consultez les guides détaillés si nécessaire.

**Marque-pages recommandés** :
- 📋 [INDEX.md](INDEX.md) (ce fichier)
- 📖 [README.md](../README.md)
- 🤖 [MODELES-LLM.md](MODELES-LLM.md)
- 🐛 [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

**Développé avec ❤️ par Nantares Consulting**

*Cloud & FinOps Expert*

[Retour au README](../README.md) • [Guide Docker](DOCKER.md) • [Modèles LLM](MODELES-LLM.md) • [Support](mailto:johan@nantares.consulting)

</div>
