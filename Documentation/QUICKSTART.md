# Guide de Démarrage Rapide

## Installation en 5 minutes

### 1. Prérequis - Installer Ollama

**macOS:**
```bash
brew install ollama
```

**Linux:**
```bash
curl -fsSL https://ollama.ai/install.sh | sh
```

**Windows:**
Télécharger depuis https://ollama.ai/download

### 2. Télécharger un modèle IA

```bash
# Pour le code (recommandé)
ollama pull codellama

# OU un modèle généraliste
ollama pull llama3
```

### 3. Démarrer Ollama

```bash
ollama serve
```

Gardez ce terminal ouvert. Ollama écoute maintenant sur http://localhost:11434

### 4. Installer et lancer l'application

Dans un nouveau terminal:

```bash
# Aller dans le dossier du projet
cd ai-coding-agent

# Installer les dépendances
npm install

# Lancer l'application
npm run dev
```

### 5. Utiliser l'application

1. Ouvrir http://localhost:3000 dans votre navigateur
2. Vérifier que "Connecté à Ollama" est affiché en vert
3. Cliquer sur "Upload Spécification"
4. Choisir le fichier `examples/spec-calculatrice.md` pour tester
5. L'agent analysera la spec et posera des questions
6. Répondez aux questions ou cliquez directement sur "Générer le Code"
7. Les fichiers générés seront dans `./output/`

## Commandes Utiles

```bash
# Lister les modèles installés
ollama list

# Supprimer un modèle
ollama rm nom-du-modele

# Vérifier qu'Ollama fonctionne
curl http://localhost:11434/api/tags

# Tester un modèle directement
ollama run codellama "écris une fonction pour calculer fibonacci"
```

## Dépannage Express

**Problème:** "Ollama non accessible"
**Solution:** Vérifiez que `ollama serve` est en cours d'exécution

**Problème:** Pas de modèles dans la liste
**Solution:** `ollama pull codellama` ou `ollama pull llama3`

**Problème:** L'agent ne répond pas
**Solution:** Assurez-vous d'avoir uploadé une spécification d'abord

**Problème:** Les fichiers ne sont pas générés
**Solution:** Vérifiez les permissions du dossier `./output/`

## Prochaines Étapes

- Lisez le README.md complet pour plus de détails
- Créez vos propres spécifications
- Testez différents modèles Ollama
- Personnalisez l'interface selon vos besoins

## Support

Pour toute question : johan@nantares.consulting
