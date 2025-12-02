.PHONY: help start stop restart logs status pull-model list-models rebuild clean shell ollama-shell install

# Couleurs pour les messages
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m # No Color

help: ## Afficher cette aide
	@echo "$(BLUE)Agent IA de Développement - Commandes disponibles:$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)Exemples:$(NC)"
	@echo "  make start              # Démarrer l'application"
	@echo "  make logs               # Voir les logs"
	@echo "  make pull-model MODEL=llama3  # Télécharger un modèle"

install: ## Installer et démarrer pour la première fois
	@echo "$(BLUE)Installation de l'Agent IA de Développement...$(NC)"
	@chmod +x start.sh
	@./start.sh start
	@echo "$(GREEN)Installation terminée! Application disponible sur http://localhost:3000$(NC)"

start: ## Démarrer tous les services
	@./start.sh start

stop: ## Arrêter tous les services
	@./start.sh stop

restart: ## Redémarrer tous les services
	@./start.sh restart

logs: ## Afficher les logs en temps réel
	@./start.sh logs

status: ## Afficher le statut des services
	@./start.sh status

pull-model: ## Télécharger un modèle (usage: make pull-model MODEL=llama3)
	@if [ -z "$(MODEL)" ]; then \
		echo "$(YELLOW)Usage: make pull-model MODEL=nom-du-modele$(NC)"; \
		echo "Exemples:"; \
		echo "  make pull-model MODEL=llama3"; \
		echo "  make pull-model MODEL=deepseek-coder"; \
		exit 1; \
	fi
	@./start.sh pull-model $(MODEL)

list-models: ## Lister les modèles installés
	@./start.sh list-models

rebuild: ## Reconstruire l'application
	@./start.sh rebuild

clean: ## Nettoyer complètement (supprime tout)
	@./start.sh clean

shell: ## Ouvrir un shell dans le conteneur app
	@./start.sh shell

ollama-shell: ## Ouvrir un shell dans le conteneur ollama
	@./start.sh ollama-shell

dev: start ## Alias pour start (mode développement)

prod: ## Build et démarrer en mode production
	@docker-compose -f docker-compose.yml up -d --build

down: stop ## Alias pour stop

ps: status ## Alias pour status

# Commandes de développement local (sans Docker)
dev-local: ## Démarrer en mode développement local (sans Docker)
	@echo "$(BLUE)Démarrage en mode développement local...$(NC)"
	@npm run dev

build-local: ## Build l'application localement
	@echo "$(BLUE)Build de l'application...$(NC)"
	@npm run build

test-ollama: ## Tester la connexion à Ollama
	@echo "$(BLUE)Test de connexion à Ollama...$(NC)"
	@curl -s http://localhost:11434/api/tags | jq '.' || echo "$(YELLOW)Ollama n'est pas accessible$(NC)"

# Commandes de maintenance
backup: ## Sauvegarder les modèles Ollama
	@echo "$(BLUE)Sauvegarde des modèles...$(NC)"
	@docker run --rm -v ai-coding-agent_ollama_data:/data -v $(PWD):/backup \
		alpine tar czf /backup/ollama-backup-$$(date +%Y%m%d-%H%M%S).tar.gz -C /data .
	@echo "$(GREEN)Sauvegarde terminée!$(NC)"

restore: ## Restaurer les modèles Ollama (usage: make restore FILE=ollama-backup.tar.gz)
	@if [ -z "$(FILE)" ]; then \
		echo "$(YELLOW)Usage: make restore FILE=ollama-backup.tar.gz$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)Restauration des modèles depuis $(FILE)...$(NC)"
	@docker run --rm -v ai-coding-agent_ollama_data:/data -v $(PWD):/backup \
		alpine tar xzf /backup/$(FILE) -C /data
	@echo "$(GREEN)Restauration terminée!$(NC)"

update: ## Mettre à jour et redémarrer l'application
	@echo "$(BLUE)Mise à jour de l'application...$(NC)"
	@git pull
	@./start.sh rebuild
	@./start.sh restart
	@echo "$(GREEN)Mise à jour terminée!$(NC)"

stats: ## Afficher les statistiques d'utilisation
	@docker stats --no-stream

open: ## Ouvrir l'application dans le navigateur
	@echo "$(BLUE)Ouverture de l'application...$(NC)"
	@open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Ouvrez http://localhost:3000 dans votre navigateur"

.DEFAULT_GOAL := help
