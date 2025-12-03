# 🤖 Agent IA de Développement

<div align="center">

**Un agent IA qui code vos fonctionnalités à la demande**

Uploadez votre spécification fonctionnelle, discutez avec l'agent pour clarifier vos besoins, et générez automatiquement du code prêt à l'emploi.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Next.js](https://img.shields.io/badge/Next.js-14-black)](https://nextjs.org/)
[![Ollama](https://img.shields.io/badge/Ollama-Local%20AI-blue)](https://ollama.ai/)
[![Docker](https://img.shields.io/badge/Docker-Supported-2496ED)](https://www.docker.com/)

</div>

---

## 📑 Table des Matières

- [🚀 Démarrage Rapide](#-démarrage-rapide)
- [✨ Fonctionnalités](#-fonctionnalités)
- [📋 Prérequis](#-prérequis)
- [📥 Installation](#-installation)
- [🎯 Utilisation](#-utilisation)
- [🤖 Modèles LLM](#-modèles-llm)
- [📁 Structure du Projet](#-structure-du-projet)
- [🔧 Configuration](#-configuration)
- [📚 Documentation](#-documentation)
- [🆘 Support](#-support)

---

## 🚀 Démarrage Rapide

### Option 1 : Docker (Recommandé)

```bash
# 1. Rendre le script exécutable
chmod +x start.sh

# 2. Démarrer l'application
./start.sh

# 3. Ouvrir votre navigateur
# → http://localhost:3000
```

**C'est tout !** 🎉 L'application se lance avec tous les services nécessaires.

📖 **Guide détaillé** : [Documentation/DOCKER-QUICKSTART.md](Documentation/DOCKER-QUICKSTART.md)

### Option 2 : Installation Locale

```bash
# 1. Installer Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# 2. Télécharger un modèle
ollama pull qwen2.5-coder:1.5b

# 3. Démarrer Ollama
ollama serve &

# 4. Installer et lancer l'app
npm install
npm run dev
```

📖 **Guide détaillé** : [Documentation/QUICKSTART.md](Documentation/QUICKSTART.md)

---

## ✨ Fonctionnalités

### 🎯 Principales

- **🤖 IA 100% Locale** : Basé sur Ollama, fonctionne sans connexion internet
- **📄 Upload de Spécifications** : Supporte TXT, Markdown et PDF
- **💬 Conversation Interactive** : L'agent pose des questions pour clarifier vos besoins
- **🔨 Génération Automatique** : Création de code multi-fichiers prêt à l'emploi
- **💾 Gestion de Sessions** : Chaque génération dans un répertoire horodaté
- **📦 Export Complet** : Téléchargement individuel ou ZIP de tous les fichiers
- **🎨 Interface Moderne** : Design avec Next.js 14 et shadcn/ui

### 🔧 Techniques

- Architecture Next.js 14 avec App Router
- TypeScript pour la robustesse du code
- Streaming de réponses en temps réel
- Sélection dynamique des modèles LLM
- Support Docker avec docker-compose
- Healthchecks et monitoring
- Scripts d'administration intégrés

---

## 📋 Prérequis

### Docker (Recommandé)

- **Docker** 20.10+ et **Docker Compose** 2.0+
- **8 GB RAM minimum** (16 GB recommandé pour modèles avancés)
- **10 GB d'espace disque** libre
- Système : Linux, macOS, ou Windows avec WSL2

### Installation Manuelle

- **Node.js** 18 ou supérieur
- **Ollama** installé et fonctionnel
- **6 GB RAM minimum** pour les modèles légers
- Système : Linux, macOS, ou Windows

📖 **Détails** : [Documentation/MEMORY-REQUIREMENTS.md](Documentation/MEMORY-REQUIREMENTS.md)

---

## 📥 Installation

### Avec Docker (Recommandé)

```bash
# Cloner le projet
git clone <votre-repo>
cd agent-ai

# Rendre le script exécutable
chmod +x start.sh

# Démarrer tous les services
./start.sh
```

**Services lancés** :
- 🐳 Ollama (port 11434)
- 🌐 Application Web (port 3000)
- 💾 Volumes persistants pour modèles et données

### Installation Locale

```bash
# Cloner le projet
git clone <votre-repo>
cd agent-ai

# Installer les dépendances
npm install

# Configurer l'environnement (optionnel)
cp .env.example .env.local

# Démarrer Ollama
ollama serve &

# Télécharger le modèle par défaut
ollama pull qwen2.5-coder:1.5b

# Démarrer l'application
npm run dev
```

L'application sera accessible sur **http://localhost:3000**

---

## 🎯 Utilisation

### Workflow Complet

```
1. 📤 Upload Spécification
   ↓
2. 🤖 Analyse Automatique par l'IA
   ↓
3. 💬 Session Q&A Interactive
   ↓
4. ✅ Validation des Besoins
   ↓
5. 🔨 Génération du Code
   ↓
6. 💾 Sauvegarde Automatique
   ↓
7. 📦 Téléchargement (fichiers individuels ou ZIP)
```

### Étapes Détaillées

#### 1. Préparer votre Spécification

Créez un fichier `.md`, `.txt` ou `.pdf` contenant :

```markdown
# Projet : Application TODO

## Objectif
Créer une application de gestion de tâches

## Fonctionnalités
- Ajouter/Modifier/Supprimer des tâches
- Marquer comme complété
- Filtrer par statut

## Technologies
- Frontend : React avec TypeScript
- Styling : Tailwind CSS
- Stockage : localStorage
```

📖 **Exemples complets** : [examples/spec-calculatrice.md](examples/spec-calculatrice.md)

#### 2. Uploader et Discuter

1. Ouvrez http://localhost:3000
2. Cliquez sur **"Upload Spécification"**
3. Sélectionnez votre fichier
4. L'agent analyse et pose des questions
5. Répondez pour clarifier vos besoins

#### 3. Générer le Code

1. Cliquez sur **"Générer le Code"** quand prêt
2. Attendez la génération (quelques minutes selon la complexité)
3. Les fichiers apparaissent automatiquement

#### 4. Télécharger

- **Fichier individuel** : Clic sur le bouton de téléchargement
- **Tous les fichiers** : Clic sur **"Télécharger ZIP"**

Les fichiers sont sauvegardés dans `./output/session_<timestamp>/`

---

## 🤖 Modèles LLM

### Modèle Par Défaut

**qwen2.5-coder:1.5b** - Excellent équilibre vitesse/qualité
- ⚡ Rapide : ~45s pour une API CRUD
- 💾 Léger : 2-3 GB RAM
- ⭐ Qualité : 8/10 pour la génération de code

### Autres Modèles Recommandés

| Modèle | RAM | Spécialité | Quand l'utiliser |
|--------|-----|------------|------------------|
| **deepseek-coder:1.3b** | 2 GB | Code | Ultra rapide, machines limitées |
| **qwen2.5-coder:7b** | 6-8 GB | Code | Qualité supérieure, code complexe |
| **deepseek-coder:6.7b** | 6-8 GB | Code | Architectures avancées |
| **codellama:7b** | 6-8 GB | Code | Référence classique Meta |
| **phi3:mini** | 4 GB | Code/Chat | Polyvalent, bon dialogue |

### Installation d'un Nouveau Modèle

```bash
# Avec Docker
./start.sh pull-model qwen2.5-coder:7b

# Ou directement
docker exec ai-agent-ollama ollama pull deepseek-coder:6.7b

# En local
ollama pull codellama:7b
```

### Changement de Modèle

- **Via l'interface** : Sélecteur dans la section Configuration
- **Via environnement** : Variable `OLLAMA_MODEL` dans `.env.local` ou `docker-compose.yml`

📖 **Guide complet des modèles** : [Documentation/MODELES-LLM.md](Documentation/MODELES-LLM.md)

---

## 📁 Structure du Projet

```
agent-ai/
├── 📱 app/                          # Application Next.js 14
│   ├── api/
│   │   ├── chat/                   # API Communication Ollama
│   │   ├── generate-code/          # API Génération fichiers
│   │   ├── download/               # API Téléchargement individuel
│   │   └── download-zip/           # API Téléchargement ZIP
│   ├── lib/
│   │   └── ollama.ts               # Service Ollama
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx
│
├── 🎨 components/
│   ├── ui/                         # Composants shadcn/ui
│   └── ai-agent.tsx                # Composant principal Agent
│
├── 📝 examples/
│   └── spec-calculatrice.md        # Exemple de spécification
│
├── 💾 output/                       # Fichiers générés (auto-créé)
│   └── session_YYYYMMDD_HHMMSS/   # Une session par génération
│
├── 📚 Documentation/                # 📖 Toute la documentation
│   ├── INDEX.md                    # Index complet
│   ├── QUICKSTART.md               # Démarrage rapide
│   ├── DOCKER-QUICKSTART.md        # Démarrage Docker 3 commandes
│   ├── DOCKER.md                   # Guide Docker complet
│   ├── DOCKER-VERSIONS.md          # Comparatif des configs Docker
│   ├── MODELES-LLM.md             # 🆕 Guide complet des modèles LLM
│   ├── TROUBLESHOOTING.md          # Dépannage général
│   ├── BUILD-TROUBLESHOOTING.md    # Problèmes de build
│   ├── INSTALL-MODEL.md            # Installation de modèles
│   ├── MEMORY-REQUIREMENTS.md      # Configuration RAM
│   └── ...                         # Autres guides
│
├── 🐳 Docker/
│   ├── Dockerfile                  # Build multi-stage optimisé
│   ├── docker-compose.yml          # Config production
│   ├── docker-compose.simple.yml   # Config développement
│   └── docker-compose.nohealth.yml # Config max compatibilité
│
├── 🔧 Scripts/
│   ├── start.sh                    # 🎯 Script principal
│   ├── clean-all.sh               # Nettoyage complet
│   ├── diagnose.sh                # Diagnostic système
│   └── check-memory.sh            # Vérification RAM
│
└── ⚙️ Configuration/
    ├── package.json
    ├── next.config.js
    ├── tsconfig.json
    ├── tailwind.config.ts
    └── .gitignore
```

---

## 🔧 Configuration

### Variables d'Environnement

Créez un fichier `.env.local` (installation locale) :

```bash
# URL du serveur Ollama
OLLAMA_BASE_URL=http://localhost:11434

# Modèle à utiliser
OLLAMA_MODEL=qwen2.5-coder:1.5b

# Port de l'application (optionnel)
PORT=3000
```

Pour Docker, modifiez `docker-compose.yml` :

```yaml
services:
  app:
    environment:
      - OLLAMA_BASE_URL=http://ollama:11434
      - OLLAMA_MODEL=qwen2.5-coder:1.5b
```

### Commandes start.sh

Le script `start.sh` centralise toutes les opérations :

```bash
./start.sh                      # Démarrer l'application
./start.sh stop                 # Arrêter proprement
./start.sh restart              # Redémarrer
./start.sh logs                 # Voir les logs en temps réel
./start.sh status               # Statut des services
./start.sh pull-model <nom>     # Télécharger un modèle
./start.sh list-models          # Lister les modèles installés
./start.sh clean                # Nettoyer complètement
./start.sh rebuild              # Reconstruire l'app
./start.sh shell                # Shell dans le conteneur app
./start.sh ollama-shell         # Shell dans le conteneur ollama
```

### Personnalisation du Modèle

**Dans le code** (`app/lib/ollama.ts`) :

```typescript
constructor(baseUrl?: string, model: string = 'votre-modele') {
  this.baseUrl = baseUrl || process.env.OLLAMA_BASE_URL || 'http://localhost:11434';
  this.model = process.env.OLLAMA_MODEL || model;
}
```

---

## 📚 Documentation

### 🚀 Pour Démarrer

- **[Documentation/INDEX.md](Documentation/INDEX.md)** - 📋 Index complet de toute la documentation
- **[Documentation/QUICKSTART.md](Documentation/QUICKSTART.md)** - ⚡ Démarrage rapide en 5 minutes
- **[Documentation/DOCKER-QUICKSTART.md](Documentation/DOCKER-QUICKSTART.md)** - 🐳 Docker en 3 commandes
- **[Documentation/START-HERE.md](Documentation/START-HERE.md)** - 👋 Guide express 2 minutes

### 🐳 Docker

- **[Documentation/DOCKER.md](Documentation/DOCKER.md)** - Guide Docker complet
- **[Documentation/DOCKER-VERSIONS.md](Documentation/DOCKER-VERSIONS.md)** - Comparatif des 3 configs Docker

### 🤖 Modèles LLM

- **[Documentation/MODELES-LLM.md](Documentation/MODELES-LLM.md)** - 🆕 Guide exhaustif de tous les modèles
- **[Documentation/INSTALL-MODEL.md](Documentation/INSTALL-MODEL.md)** - Installation de modèles
- **[Documentation/MEMORY-REQUIREMENTS.md](Documentation/MEMORY-REQUIREMENTS.md)** - Configuration RAM

### 🐛 Dépannage

- **[Documentation/TROUBLESHOOTING.md](Documentation/TROUBLESHOOTING.md)** - Guide de dépannage complet
- **[Documentation/BUILD-TROUBLESHOOTING.md](Documentation/BUILD-TROUBLESHOOTING.md)** - Problèmes de build
- **[Documentation/ERROR-500-FIX.md](Documentation/ERROR-500-FIX.md)** - Erreur 500
- **[Documentation/HEALTHCHECK-FIX.md](Documentation/HEALTHCHECK-FIX.md)** - Problèmes healthcheck
- **[Documentation/QUICKFIX.md](Documentation/QUICKFIX.md)** - Fixes rapides 30s

### 📖 Guides Complémentaires

- **[Documentation/FIXES.md](Documentation/FIXES.md)** - Historique des corrections
- **[Documentation/CLAUDE-CODE-MIGRATION.md](Documentation/CLAUDE-CODE-MIGRATION.md)** - Migration Claude Code

**📋 Conseil** : Commencez par [Documentation/INDEX.md](Documentation/INDEX.md) qui référence tous les documents !

---

## 🆘 Support

### En Cas de Problème

1. **Consultez la documentation** : [Documentation/INDEX.md](Documentation/INDEX.md)
2. **Erreur spécifique** : Voir [Documentation/TROUBLESHOOTING.md](Documentation/TROUBLESHOOTING.md)
3. **Nettoyage complet** : `./clean-all.sh` puis `./start.sh`

### Erreurs Courantes

| Symptôme | Solution Rapide | Documentation |
|----------|-----------------|---------------|
| "Ollama non accessible" | `./start.sh restart` | [DOCKER.md](Documentation/DOCKER.md) |
| "No models available" | `./start.sh pull-model qwen2.5-coder:1.5b` | [INSTALL-MODEL.md](Documentation/INSTALL-MODEL.md) |
| Build échoue | `./clean-all.sh && ./start.sh` | [BUILD-TROUBLESHOOTING.md](Documentation/BUILD-TROUBLESHOOTING.md) |
| Erreur 500 | Vérifier logs : `./start.sh logs` | [ERROR-500-FIX.md](Documentation/ERROR-500-FIX.md) |
| Container unhealthy | Voir healthcheck | [HEALTHCHECK-FIX.md](Documentation/HEALTHCHECK-FIX.md) |

### Diagnostics

```bash
# Diagnostic complet
./diagnose.sh

# Vérifier la mémoire
./check-memory.sh

# Logs détaillés
./start.sh logs

# Statut des services
./start.sh status
docker ps -a
```

### Contact

Pour toute question ou support :

**Email** : johan@nantares.consulting
**Projet** : Nantares Consulting - Cloud & FinOps Expert

---

## 🚀 Développement

### Build pour Production

```bash
# Build local
npm run build
npm start

# Build Docker
docker-compose -f docker-compose.yml build
docker-compose -f docker-compose.yml up -d
```

### Structure des API

**`POST /api/chat`** - Communiquer avec Ollama
```typescript
{
  messages: Message[],
  model?: string,
  stream?: boolean
}
```

**`POST /api/generate-code`** - Sauvegarder le code généré
```typescript
{
  code: string,
  filename: string,
  directory: string
}
```

**`GET /api/download?file=<path>`** - Télécharger un fichier

**`POST /api/download-zip`** - Créer et télécharger un ZIP
```typescript
{
  directory: string
}
```

---

## 🎯 Roadmap

### Version Actuelle (v1.0)
- ✅ Agent conversationnel
- ✅ Upload de spécifications
- ✅ Génération multi-fichiers
- ✅ Téléchargement ZIP
- ✅ Sélection de modèles
- ✅ Support Docker

### Prochaines Versions

#### v1.1 (Planifié)
- [ ] Streaming en temps réel de la génération
- [ ] Preview du code avant sauvegarde
- [ ] Historique des sessions sauvegardé
- [ ] Export des conversations

#### v1.2 (Futur)
- [ ] Support de plus de formats (DOCX, HTML)
- [ ] Tests unitaires générés automatiquement
- [ ] Documentation automatique du code
- [ ] Support multi-projets
- [ ] Intégration Git automatique

---

## 📄 Licence

MIT License - Voir [LICENSE](LICENSE) pour plus de détails.

Vous êtes libre de :
- ✅ Utiliser commercialement
- ✅ Modifier le code
- ✅ Distribuer
- ✅ Utiliser en privé

---

## 🙏 Remerciements

Ce projet utilise et remercie :

- **[Ollama](https://ollama.ai/)** - Pour l'infrastructure LLM locale
- **[Next.js](https://nextjs.org/)** - Framework React
- **[shadcn/ui](https://ui.shadcn.com/)** - Composants UI
- **[Qwen](https://github.com/QwenLM/Qwen2.5)** - Modèle par défaut excellent
- **[DeepSeek](https://github.com/deepseek-ai/DeepSeek-Coder)** - Modèles de code performants

---

## 📊 Statistiques du Projet

- **Technologies** : Next.js 14, TypeScript, Ollama, Docker
- **Lignes de code** : ~3000+ (app + docs)
- **Documentation** : 20+ guides détaillés
- **Modèles supportés** : 15+ modèles LLM
- **Temps de setup** : < 5 minutes avec Docker

---

<div align="center">

**Développé avec ❤️ par Nantares Consulting**

*Cloud & FinOps Expert*

[Documentation](Documentation/INDEX.md) • [Guide Docker](Documentation/DOCKER.md) • [Modèles LLM](Documentation/MODELES-LLM.md) • [Support](mailto:johan@nantares.consulting)

</div>
