# 🎯 DÉMARRAGE EXPRESS

## Vous venez d'extraire l'archive ? Suivez ces étapes :

### 1️⃣ Démarrer l'Application (2 minutes)

```bash
chmod +x start.sh
./start.sh
```

**Attendez 1-2 minutes** que tout démarre.

### 2️⃣ Installer un Modèle IA (5-10 minutes)

```bash
chmod +x install-model.sh
./install-model.sh codellama
```

**Attendez le téléchargement** (~4 GB).

### 3️⃣ Utiliser l'Application

Ouvrez dans votre navigateur : **http://localhost:3000**

---

## 🆘 Problèmes ?

### L'application ne démarre pas
```bash
./clean-all.sh
./start.sh
```

### Erreur 500 dans le chat
```bash
./install-model.sh codellama
```

### Diagnostic complet
```bash
./diagnose.sh
```

---

## 📚 Documentation Complète

- **INDEX.md** - Table des matières de toute la documentation
- **DOCKER-QUICKSTART.md** - Guide Docker en 3 commandes
- **ERROR-500-FIX.md** - Résolution erreur 500
- **INSTALL-MODEL.md** - Guide installation de modèles

---

## ⚡ Commandes Essentielles

```bash
./start.sh              # Démarrer
./start.sh stop         # Arrêter
./start.sh logs         # Voir les logs
./diagnose.sh           # Diagnostic
./install-model.sh      # Installer un modèle
./clean-all.sh          # Nettoyer et recommencer
```

---

**C'est tout !** En 10-15 minutes vous devriez être opérationnel. 🚀

Pour toute question : **johan@nantares.consulting**
