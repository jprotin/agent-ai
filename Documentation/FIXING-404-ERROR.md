# Guide de résolution de l'erreur 404 sur /api/chat

## 🔍 Problème identifié

L'erreur 404 sur l'endpoint `/api/chat` d'Ollama signifie que **le modèle n'est pas installé**.

### Symptômes

Dans les logs Docker, vous voyez :
```
ai-agent-ollama | [GIN] 2025/12/02 - 11:59:52 | 404 | POST "/api/chat"
ai-agent-app    | Error: Ollama error: Not Found
```

## ✅ Solution rapide

### 1. Vérifier les modèles installés

```bash
docker exec ai-agent-ollama ollama list
```

Si la liste est vide ou ne contient pas le modèle souhaité, installez-le.

### 2. Installer un modèle

#### Option A : Utiliser le script d'installation interactif

```bash
chmod +x install-models.sh
./install-models.sh
```

#### Option B : Installation manuelle

**Pour codellama (recommandé pour le code):**
```bash
docker exec ai-agent-ollama ollama pull codellama
```

**Pour llama3 (modèle général performant):**
```bash
docker exec ai-agent-ollama ollama pull llama3
```

**Pour qwen2.5-coder (excellent pour le code):**
```bash
docker exec ai-agent-ollama ollama pull qwen2.5-coder
```

**Pour deepseek-coder (spécialisé code):**
```bash
docker exec ai-agent-ollama ollama pull deepseek-coder
```

### 3. Vérifier que l'installation a réussi

```bash
docker exec ai-agent-ollama ollama list
```

Vous devriez voir quelque chose comme :
```
NAME                    ID              SIZE    MODIFIED
codellama:latest        8fdf8f752f6e    3.8 GB  2 minutes ago
```

### 4. Redémarrer l'application (optionnel)

```bash
docker compose restart app
```

### 5. Tester l'application

1. Ouvrez http://localhost:3000
2. Vérifiez que le statut indique "✓ Connecté à Ollama" en vert
3. Uploadez une spécification ou envoyez un message
4. L'erreur 404 devrait avoir disparu !

## 🛠️ Diagnostic avancé

Si le problème persiste, utilisez le script de diagnostic :

```bash
chmod +x test-ollama.sh
./test-ollama.sh
```

Cela vous donnera des informations détaillées sur :
- Les modèles installés
- L'état de l'API Ollama
- Les erreurs éventuelles

## 📋 Modèles recommandés

| Modèle | Taille | Usage | Commande |
|--------|--------|-------|----------|
| codellama | ~3.8 GB | Code (Python, JS, etc.) | `ollama pull codellama` |
| llama3 | ~4.7 GB | Usage général | `ollama pull llama3` |
| qwen2.5-coder | ~4.7 GB | Code (meilleur) | `ollama pull qwen2.5-coder` |
| deepseek-coder | ~3.8 GB | Code spécialisé | `ollama pull deepseek-coder` |

## 🔄 Changer de modèle dans l'interface

Une fois les modèles installés :
1. Ouvrez http://localhost:3000
2. Le sélecteur de modèle apparaîtra automatiquement à côté du statut Ollama
3. Choisissez le modèle souhaité dans la liste déroulante

## ❓ Questions fréquentes

### Q: Pourquoi le modèle n'est-il pas installé par défaut ?

R: Le téléchargement automatique est configuré dans `docker-compose.yml` via le service `ollama-setup`, mais il peut échouer ou prendre du temps. L'installation manuelle est plus fiable.

### Q: Combien de temps prend l'installation ?

R: Cela dépend de votre connexion Internet. Comptez 5-10 minutes pour un modèle de 4 GB.

### Q: Puis-je installer plusieurs modèles ?

R: Oui ! Installez autant de modèles que vous voulez, puis sélectionnez celui à utiliser dans l'interface.

### Q: L'erreur persiste après l'installation du modèle

R:
1. Vérifiez que le nom du modèle est correct avec `ollama list`
2. Redémarrez l'application avec `docker compose restart app`
3. Vérifiez les logs avec `docker compose logs app --tail=50`

## 🎯 Amélioration apportées

Les changements suivants ont été apportés pour mieux gérer cette erreur :

1. **Vérification du modèle avant utilisation** - L'API vérifie maintenant si le modèle existe avant de l'utiliser
2. **Messages d'erreur détaillés** - Les erreurs incluent maintenant le nom du modèle manquant et la commande pour l'installer
3. **Logs améliorés** - Plus de détails dans les logs pour faciliter le diagnostic
4. **Scripts d'installation** - Scripts automatisés pour installer les modèles facilement

## 📝 Logs utiles

Pour voir les logs en temps réel :
```bash
docker compose logs -f app
```

Pour voir les logs d'Ollama :
```bash
docker compose logs -f ollama
```

## 🚀 Prochaines étapes

Une fois le modèle installé :
1. L'interface affichera "✓ Connecté à Ollama" en vert
2. Vous pourrez uploader des spécifications
3. L'agent pourra analyser et générer du code
4. Plus d'erreur 404 !
