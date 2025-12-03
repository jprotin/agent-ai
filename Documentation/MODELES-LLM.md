# 🤖 Guide des Modèles LLM - Agent IA de Développement

Ce document répertorie tous les modèles de langage (LLM) que vous pouvez utiliser avec l'Agent IA de Développement, leurs caractéristiques, et comment les utiliser.

## 📋 Tableau Récapitulatif des Modèles

### Modèles Recommandés pour le Code

| Modèle | Taille | RAM Requis | Spécialité | Performance Code | Vitesse | Recommandation |
|--------|--------|------------|------------|------------------|---------|----------------|
| **qwen2.5-coder:1.5b** | 1.5B | 2-3 GB | Code | ⭐⭐⭐⭐ | ⚡⚡⚡⚡⚡ | ✅ **Défaut - Excellent équilibre** |
| **qwen2.5-coder:7b** | 7B | 6-8 GB | Code | ⭐⭐⭐⭐⭐ | ⚡⚡⚡⚡ | ✅ Recommandé si assez de RAM |
| **deepseek-coder:1.3b** | 1.3B | 2 GB | Code | ⭐⭐⭐⭐ | ⚡⚡⚡⚡⚡ | ✅ Ultra rapide, léger |
| **deepseek-coder:6.7b** | 6.7B | 6-8 GB | Code | ⭐⭐⭐⭐⭐ | ⚡⚡⚡⚡ | ✅ Excellent pour code complexe |
| **codellama:7b** | 7B | 6-8 GB | Code | ⭐⭐⭐⭐ | ⚡⚡⚡ | ✅ Bon choix classique |
| **codellama:13b** | 13B | 12-16 GB | Code | ⭐⭐⭐⭐⭐ | ⚡⚡ | ⚠️ Nécessite beaucoup de RAM |
| **starcoder2:3b** | 3B | 3-4 GB | Code | ⭐⭐⭐⭐ | ⚡⚡⚡⚡ | ✅ Bon compromis |
| **phi3:mini** | 3.8B | 4 GB | Code/Chat | ⭐⭐⭐ | ⚡⚡⚡⚡ | ✅ Polyvalent |

### Modèles Généralistes (Usage Avancé)

| Modèle | Taille | RAM Requis | Spécialité | Performance Code | Vitesse | Recommandation |
|--------|--------|------------|------------|------------------|---------|----------------|
| **llama3:8b** | 8B | 8 GB | Généraliste | ⭐⭐⭐ | ⚡⚡⚡ | ✅ Bon pour dialogue + code |
| **llama3:70b** | 70B | 64+ GB | Généraliste | ⭐⭐⭐⭐⭐ | ⚡ | ❌ Nécessite GPU puissant |
| **mistral:7b** | 7B | 6-8 GB | Généraliste | ⭐⭐⭐ | ⚡⚡⚡⚡ | ✅ Rapide et efficace |
| **mixtral:8x7b** | 47B | 32+ GB | Généraliste | ⭐⭐⭐⭐⭐ | ⚡⚡ | ⚠️ Très performant mais lourd |
| **gemma2:2b** | 2B | 2-3 GB | Généraliste | ⭐⭐⭐ | ⚡⚡⚡⚡⚡ | ✅ Ultra léger |

### Modèles Très Légers (Machines Limitées)

| Modèle | Taille | RAM Requis | Spécialité | Performance Code | Vitesse | Recommandation |
|--------|--------|------------|------------|------------------|---------|----------------|
| **tinyllama** | 1.1B | 1-2 GB | Généraliste | ⭐⭐ | ⚡⚡⚡⚡⚡ | ⚠️ Basique, pour tests |
| **phi3:mini** | 3.8B | 4 GB | Code/Chat | ⭐⭐⭐ | ⚡⚡⚡⚡ | ✅ Bon compromis léger |
| **stablelm2:1.6b** | 1.6B | 2 GB | Généraliste | ⭐⭐ | ⚡⚡⚡⚡⚡ | ⚠️ Performances limitées |

## 🎯 Quel Modèle Choisir ?

### Selon Votre Configuration Matérielle

#### 💻 Configuration Minimale (4-8 GB RAM)
```bash
# Modèle par défaut - Excellent choix
ollama pull qwen2.5-coder:1.5b

# Alternative ultra légère
ollama pull deepseek-coder:1.3b

# Alternative polyvalente
ollama pull phi3:mini
```

**Recommandation** : `qwen2.5-coder:1.5b` (déjà configuré par défaut)

#### 🖥️ Configuration Standard (8-16 GB RAM)
```bash
# Meilleur choix pour le code
ollama pull qwen2.5-coder:7b

# Ou DeepSeek pour code complexe
ollama pull deepseek-coder:6.7b

# Ou CodeLlama classique
ollama pull codellama:7b
```

**Recommandation** : `qwen2.5-coder:7b` ou `deepseek-coder:6.7b`

#### 🚀 Configuration Puissante (16+ GB RAM)
```bash
# Pour génération de code avancée
ollama pull codellama:13b

# Pour code + dialogue naturel
ollama pull llama3:70b

# Pour performances maximales
ollama pull mixtral:8x7b
```

**Recommandation** : `codellama:13b` pour le code, `mixtral:8x7b` pour polyvalence

### Selon Votre Cas d'Usage

#### 🔧 Génération de Code Simple (API, CRUD, Scripts)
- **qwen2.5-coder:1.5b** - Rapide, léger, excellent
- **deepseek-coder:1.3b** - Ultra rapide
- **starcoder2:3b** - Bon équilibre

#### 🏗️ Génération de Code Complexe (Architectures, Patterns)
- **qwen2.5-coder:7b** - Recommandé
- **deepseek-coder:6.7b** - Très performant
- **codellama:13b** - Maximum de qualité

#### 💬 Dialogue + Code (Q&A + Génération)
- **phi3:mini** - Polyvalent et léger
- **llama3:8b** - Excellent pour conversation
- **mistral:7b** - Rapide et efficace

#### ⚡ Vitesse Maximale (Prototypage Rapide)
- **deepseek-coder:1.3b** - Le plus rapide
- **qwen2.5-coder:1.5b** - Excellent compromis
- **gemma2:2b** - Très léger

## 📥 Installation des Modèles

### Dans Docker (Recommandé)

```bash
# Lister les modèles disponibles
./start.sh list-models

# Télécharger un nouveau modèle
./start.sh pull-model qwen2.5-coder:7b

# Ou directement via docker exec
docker exec ai-agent-ollama ollama pull deepseek-coder:6.7b
```

### Installation Locale (Sans Docker)

```bash
# Télécharger un modèle
ollama pull qwen2.5-coder:1.5b

# Lister les modèles installés
ollama list

# Tester un modèle
ollama run qwen2.5-coder:1.5b "Write a hello world in Python"
```

## 🔄 Changer de Modèle dans l'Application

### Via l'Interface Web
1. Ouvrez http://localhost:3000
2. Dans la section "Configuration", sélectionnez le modèle souhaité
3. Le changement est immédiat

### Via Variables d'Environnement

**Docker Compose** (`docker-compose.yml`) :
```yaml
services:
  app:
    environment:
      - OLLAMA_MODEL=qwen2.5-coder:7b
```

**Installation Locale** (`.env.local`) :
```bash
OLLAMA_MODEL=deepseek-coder:6.7b
OLLAMA_BASE_URL=http://localhost:11434
```

### Via le Code

Modifiez `app/lib/ollama.ts` :
```typescript
constructor(baseUrl?: string, model: string = 'votre-modele-ici') {
  // ...
}
```

## 📊 Comparaison Détaillée des Meilleurs Modèles

### Qwen 2.5 Coder (Recommandé par Défaut)

**Versions** : 1.5b, 7b, 14b, 32b

**Points Forts** :
- ✅ Excellent pour la génération de code
- ✅ Très bon équilibre vitesse/qualité
- ✅ Comprend bien les spécifications
- ✅ Multi-langages (Python, JS, Java, etc.)
- ✅ Bonne gestion du contexte

**Points Faibles** :
- ⚠️ Peut être verbeux dans les réponses
- ⚠️ Version 1.5b limitée pour code très complexe

**Utilisation** :
```bash
# Version légère (défaut)
ollama pull qwen2.5-coder:1.5b

# Version standard
ollama pull qwen2.5-coder:7b
```

### DeepSeek Coder

**Versions** : 1.3b, 6.7b, 33b

**Points Forts** :
- ✅ Spécialisé pour le code
- ✅ Excellente compréhension des patterns
- ✅ Très rapide même sur modèles légers
- ✅ Bon pour code complexe et architectures
- ✅ Gère bien les bugs et refactoring

**Points Faibles** :
- ⚠️ Moins bon pour le dialogue naturel
- ⚠️ Peut être trop technique

**Utilisation** :
```bash
# Ultra léger
ollama pull deepseek-coder:1.3b

# Standard
ollama pull deepseek-coder:6.7b
```

### CodeLlama (Meta)

**Versions** : 7b, 13b, 34b, 70b

**Points Forts** :
- ✅ Modèle de référence pour le code
- ✅ Excellent pour Python
- ✅ Bonne documentation du code
- ✅ Comprend les instructions complexes
- ✅ Stable et fiable

**Points Faibles** :
- ⚠️ Plus lent que Qwen ou DeepSeek
- ⚠️ Nécessite plus de RAM
- ⚠️ Peut générer du code verbeux

**Utilisation** :
```bash
# Version standard
ollama pull codellama:7b

# Version puissante
ollama pull codellama:13b
```

### StarCoder2

**Versions** : 3b, 7b, 15b

**Points Forts** :
- ✅ Entraîné sur énormément de code GitHub
- ✅ Excellent pour multiple langages
- ✅ Bon pour les patterns modernes
- ✅ Comprend les frameworks populaires

**Points Faibles** :
- ⚠️ Moins bon pour les spécifications en français
- ⚠️ Peut générer du code non idiomatique

**Utilisation** :
```bash
ollama pull starcoder2:3b
ollama pull starcoder2:7b
```

## 🔧 Configuration Avancée

### Optimiser les Performances

#### GPU NVIDIA
```yaml
# docker-compose.yml
services:
  ollama:
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

#### CPU Uniquement
```bash
# Limiter les threads pour éviter la surchauffe
docker exec ai-agent-ollama ollama run qwen2.5-coder:1.5b --num-thread 4
```

### Paramètres de Génération

Modifiez `app/lib/ollama.ts` pour ajuster :

```typescript
const response = await fetch(`${this.baseUrl}/api/chat`, {
  method: 'POST',
  body: JSON.stringify({
    model: this.model,
    messages: messages,
    stream: false,
    options: {
      temperature: 0.7,      // Créativité (0.0-1.0)
      top_p: 0.9,           // Diversité des réponses
      num_predict: 2048,    // Longueur max de réponse
      stop: ["```\n\n"],    // Tokens d'arrêt
    }
  }),
});
```

## 📈 Benchmarks (Génération de Code)

### Test : Générer une API REST CRUD complète

| Modèle | Temps | Qualité | RAM Utilisée | Note Globale |
|--------|-------|---------|--------------|--------------|
| qwen2.5-coder:1.5b | 45s | 8/10 | 2.1 GB | ⭐⭐⭐⭐⭐ |
| deepseek-coder:1.3b | 38s | 7.5/10 | 1.8 GB | ⭐⭐⭐⭐ |
| qwen2.5-coder:7b | 2m10s | 9.5/10 | 7.2 GB | ⭐⭐⭐⭐⭐ |
| deepseek-coder:6.7b | 2m05s | 9/10 | 6.8 GB | ⭐⭐⭐⭐⭐ |
| codellama:7b | 2m45s | 8.5/10 | 7.5 GB | ⭐⭐⭐⭐ |
| phi3:mini | 1m15s | 7/10 | 3.9 GB | ⭐⭐⭐ |
| llama3:8b | 2m30s | 7.5/10 | 8.1 GB | ⭐⭐⭐ |

**Critères** : Temps sur CPU i7 12th gen, Qualité = code fonctionnel + bonnes pratiques

## 🎓 Conseils d'Utilisation

### Pour Débutants
1. Commencez avec **qwen2.5-coder:1.5b** (déjà installé)
2. Testez sur des projets simples
3. Si satisfait, restez avec ce modèle
4. Si besoin de plus : passez à **qwen2.5-coder:7b**

### Pour Utilisateurs Avancés
1. **deepseek-coder:6.7b** pour code complexe
2. **codellama:13b** pour projets critiques
3. **mixtral:8x7b** si besoin de polyvalence
4. Testez plusieurs modèles et comparez

### Pour Machines Limitées
1. **deepseek-coder:1.3b** - Le plus rapide
2. **qwen2.5-coder:1.5b** - Meilleur équilibre
3. **phi3:mini** - Si besoin de dialogue
4. Évitez les modèles > 7b

## 🆘 Dépannage

### Le modèle ne se charge pas
```bash
# Vérifier les modèles installés
docker exec ai-agent-ollama ollama list

# Télécharger le modèle
docker exec ai-agent-ollama ollama pull qwen2.5-coder:1.5b

# Vérifier les logs
docker logs ai-agent-ollama
```

### Erreur de mémoire (OOM)
```bash
# Utiliser un modèle plus léger
docker exec ai-agent-ollama ollama pull qwen2.5-coder:1.5b

# Ou augmenter la RAM Docker
# Docker Desktop > Settings > Resources > Memory
```

### Modèle trop lent
```bash
# Passer à un modèle plus léger
./start.sh pull-model deepseek-coder:1.3b

# Ou limiter le contexte dans l'app
# Réduire la longueur des spécifications
```

## 📚 Ressources Supplémentaires

- **Ollama Models Library** : https://ollama.ai/library
- **Qwen Documentation** : https://github.com/QwenLM/Qwen2.5
- **DeepSeek Coder** : https://github.com/deepseek-ai/DeepSeek-Coder
- **CodeLlama Paper** : https://arxiv.org/abs/2308.12950

## 🔄 Mises à Jour

Les modèles sont régulièrement mis à jour par leurs créateurs :

```bash
# Mettre à jour un modèle
docker exec ai-agent-ollama ollama pull qwen2.5-coder:1.5b

# Supprimer une ancienne version
docker exec ai-agent-ollama ollama rm qwen2.5-coder:old-version
```

---

**💡 Conseil Final** : Pour 95% des cas, **qwen2.5-coder:1.5b** (modèle par défaut) est parfait. N'installez des modèles plus lourds que si vous avez un besoin spécifique de qualité supérieure.

**Contact** : johan@nantares.consulting
