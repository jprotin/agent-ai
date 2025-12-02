# Agent IA de Développement

Un agent IA qui code vos fonctionnalités à la demande. Uploadez votre spécification fonctionnelle, discutez avec l'agent pour clarifier vos besoins, et générez automatiquement du code prêt à l'emploi.

## 🚀 Démarrage Rapide avec Docker (Recommandé)

```bash
# 1. Rendre le script exécutable
chmod +x start.sh

# 2. Démarrer l'application
./start.sh

# 3. Ouvrir http://localhost:3000
```

**📖 Guide complet Docker** : Voir [DOCKER.md](DOCKER.md) pour tous les détails

## Fonctionnalités

- 🤖 Agent IA conversationnel basé sur Ollama (100% local)
- 📄 Upload de spécifications (TXT, MD, PDF)
- 💬 Session de questions/réponses interactive
- 🔨 Génération automatique de code
- 💾 Sauvegarde des fichiers générés dans un répertoire accessible
- 🎨 Interface moderne avec Next.js 14 et shadcn/ui
- 🔌 Fonctionne en local, même sans connexion internet (une fois installé)

## Prérequis

### Option 1 : Docker (Recommandé - Plus Simple)

- **Docker** 20.10+ et **Docker Compose** 2.0+
- **8 GB RAM minimum** (16 GB recommandé)
- **10 GB d'espace disque**

Tout est automatisé ! Voir [DOCKER.md](DOCKER.md) pour le guide complet.

### Option 2 : Installation Manuelle

1. **Node.js 18+** - [Télécharger](https://nodejs.org/)
2. **Ollama** - [Télécharger](https://ollama.ai/)

### Installation d'Ollama

```bash
# Sur macOS
brew install ollama

# Sur Linux
curl -fsSL https://ollama.ai/install.sh | sh

# Sur Windows
# Télécharger depuis https://ollama.ai/download
```

### Télécharger un modèle Ollama

```bash
# Modèle recommandé pour le code
ollama pull codellama

# Ou un modèle généraliste
ollama pull llama3

# Ou DeepSeek Coder (excellent pour le code)
ollama pull deepseek-coder
```

## Installation

```bash
# Cloner ou télécharger le projet
cd ai-coding-agent

# Installer les dépendances
npm install

# Démarrer le serveur de développement
npm run dev
```

L'application sera accessible sur [http://localhost:3000](http://localhost:3000)

## Utilisation

### 1. Démarrer Ollama

Assurez-vous qu'Ollama est en cours d'exécution :

```bash
ollama serve
```

Par défaut, Ollama écoute sur `http://localhost:11434`

### 2. Lancer l'application

```bash
npm run dev
```

### 3. Workflow

1. **Upload Spécification** : Cliquez sur "Upload Spécification" et sélectionnez votre fichier (.txt, .md, .pdf)
2. **Analyse Automatique** : L'agent analyse votre spécification et pose des questions
3. **Session Q&A** : Répondez aux questions de l'agent pour clarifier vos besoins
4. **Génération de Code** : Cliquez sur "Générer le Code" quand vous êtes prêt
5. **Récupération** : Les fichiers générés sont sauvegardés dans `./output/`

## Structure du Projet

```
ai-coding-agent/
├── app/
│   ├── api/
│   │   ├── chat/          # API pour communiquer avec Ollama
│   │   └── generate-code/ # API pour sauvegarder le code généré
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx
├── components/
│   ├── ui/                # Composants shadcn/ui
│   └── ai-agent.tsx       # Composant principal de l'agent
├── lib/
│   ├── ollama.ts          # Service Ollama
│   └── utils.ts
├── output/                # Répertoire des fichiers générés (créé automatiquement)
└── package.json
```

## Configuration

### Changer le modèle Ollama

Vous pouvez sélectionner différents modèles directement dans l'interface, ou modifier le modèle par défaut dans `lib/ollama.ts` :

```typescript
constructor(baseUrl: string = 'http://localhost:11434', model: string = 'codellama') {
  this.baseUrl = baseUrl;
  this.model = model;
}
```

### Modèles recommandés

- **codellama** : Excellent pour la génération de code (7B-34B)
- **deepseek-coder** : Spécialisé dans le code, très performant
- **llama3** : Bon équilibre entre compréhension et génération
- **mistral** : Rapide et efficace

### Répertoire de sortie

Par défaut, les fichiers sont sauvegardés dans `./output/`. Pour changer cela, modifiez `app/api/generate-code/route.ts` :

```typescript
const baseDir = path.join(process.cwd(), 'votre-dossier', directory);
```

## Exemples de Spécifications

### Exemple 1 : Application TODO

```markdown
# Spécification : Application TODO

## Objectif
Créer une application de gestion de tâches simple

## Fonctionnalités
- Ajouter une tâche avec un titre et une description
- Marquer une tâche comme complétée
- Supprimer une tâche
- Filtrer les tâches (toutes, actives, complétées)

## Technologie souhaitée
- Frontend : React
- Stockage : localStorage
```

### Exemple 2 : API REST

```markdown
# Spécification : API de Blog

## Endpoints requis
- GET /posts - Liste tous les articles
- GET /posts/:id - Détails d'un article
- POST /posts - Créer un article
- PUT /posts/:id - Modifier un article
- DELETE /posts/:id - Supprimer un article

## Modèle de données
- Post : id, title, content, author, createdAt, updatedAt

## Technologie
- Node.js + Express
- Base de données : SQLite
```

## Troubleshooting

### "Ollama non accessible"

1. Vérifiez qu'Ollama est démarré : `ollama serve`
2. Vérifiez que le port 11434 est accessible
3. Testez : `curl http://localhost:11434/api/tags`

### "No models available"

```bash
# Télécharger un modèle
ollama pull llama3
```

### Erreur de génération de fichiers

Vérifiez que le répertoire `./output/` est accessible en écriture.

## Développement

### Build pour production

```bash
npm run build
npm start
```

### Structure des messages avec Ollama

L'agent utilise un système de messages structuré :

```typescript
{
  role: 'system' | 'user' | 'assistant',
  content: string
}
```

## Améliorations Futures

- [ ] Support du streaming pour voir le code généré en temps réel
- [ ] Historique des sessions sauvegardé localement
- [ ] Export des conversations
- [ ] Preview du code avant sauvegarde
- [ ] Support de plus de formats de spécifications
- [ ] Tests unitaires intégrés
- [ ] Génération de documentation automatique
- [ ] Support multi-fichiers avec architecture complète

## Licence

MIT

## Auteur

Développé pour Nantares Consulting - Cloud & FinOps Expert
