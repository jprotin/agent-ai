#!/bin/bash

# Script de démarrage pour l'Agent IA de Développement
# Usage: ./start.sh [commande]

set -e

COMPOSE_FILE="docker-compose.yml"
COMPOSE_FILE_SIMPLE="docker-compose.simple.yml"
COMPOSE_FILE_NOHEALTH="docker-compose.nohealth.yml"

# Détecter quelle commande docker-compose utiliser
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
elif docker compose version &> /dev/null 2>&1; then
    DOCKER_COMPOSE="docker compose"
else
    echo "Erreur: ni 'docker-compose' ni 'docker compose' n'est disponible"
    exit 1
fi

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher un message
print_message() {
    echo -e "${BLUE}[AI-Agent]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[AI-Agent]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[AI-Agent]${NC} $1"
}

print_error() {
    echo -e "${RED}[AI-Agent]${NC} $1"
}

# Utiliser la version sans healthcheck par défaut (plus compatible)
if [ -z "$COMPOSE_FILE_OVERRIDE" ] && [ -f "$COMPOSE_FILE_NOHEALTH" ]; then
    print_warning "Utilisation de docker-compose.nohealth.yml (maximum de compatibilité)"
    print_warning "Cette version évite les problèmes de healthcheck"
    COMPOSE_FILE="$COMPOSE_FILE_NOHEALTH"
fi

print_error() {
    echo -e "${RED}[AI-Agent]${NC} $1"
}

# Vérifier que Docker est installé
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker n'est pas installé. Veuillez l'installer depuis https://docker.com"
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        print_error "Docker Compose n'est pas installé."
        exit 1
    fi
}

# Démarrer les services
start_services() {
    print_message "Démarrage des services..."
    
    # Vérifier que package-lock.json existe
    if [ ! -f "package-lock.json" ]; then
        print_warning "package-lock.json manquant, génération..."
        npm install --package-lock-only
    fi
    
    $DOCKER_COMPOSE -f $COMPOSE_FILE up -d

    print_message "Attente du démarrage complet..."
    print_message "- Ollama démarre (10-20 secondes)"
    print_message "- Téléchargement du modèle codellama (5-10 minutes la première fois)"
    print_message ""
    print_warning "Soyez patient, cela peut prendre du temps la première fois!"
    print_message ""
    print_message "Pour suivre la progression:"
    print_message "  ${YELLOW}./start.sh logs${NC}"

    print_success "Services lancés!"
    print_message ""
    print_message "Application sera disponible sur: ${GREEN}http://localhost:3000${NC}"
    print_message "Ollama API sera disponible sur: ${GREEN}http://localhost:11434${NC}"
    print_message ""
    print_message "Commandes utiles:"
    print_message "  ${YELLOW}./start.sh logs${NC}     - Voir les logs"
    print_message "  ${YELLOW}./start.sh status${NC}   - Voir le statut"
    print_message "  ${YELLOW}./start.sh stop${NC}     - Arrêter"
}

# Arrêter les services
stop_services() {
    print_message "Arrêt des services..."
    $DOCKER_COMPOSE -f $COMPOSE_FILE down
    print_success "Services arrêtés!"
}

# Afficher les logs
show_logs() {
    $DOCKER_COMPOSE -f $COMPOSE_FILE logs -f
}

# Afficher le statut
show_status() {
    print_message "Statut des services:"
    $DOCKER_COMPOSE -f $COMPOSE_FILE ps
}

# Télécharger un modèle supplémentaire
pull_model() {
    if [ -z "$1" ]; then
        print_error "Usage: ./start.sh pull-model <nom-du-modele>"
        print_message "Exemples:"
        print_message "  ./start.sh pull-model llama3"
        print_message "  ./start.sh pull-model deepseek-coder"
        exit 1
    fi

    print_message "Téléchargement du modèle $1..."
    $DOCKER_COMPOSE -f $COMPOSE_FILE exec ollama ollama pull $1
    print_success "Modèle $1 téléchargé avec succès!"
}

# Lister les modèles
list_models() {
    print_message "Modèles installés:"
    $DOCKER_COMPOSE -f $COMPOSE_FILE exec ollama ollama list
}

# Rebuild l'application
rebuild() {
    print_message "Reconstruction de l'application..."
    $DOCKER_COMPOSE -f $COMPOSE_FILE build --no-cache app
    print_success "Application reconstruite!"
}

# Nettoyer complètement
clean() {
    print_warning "Cette action va supprimer tous les conteneurs, images et volumes."
    read -p "Êtes-vous sûr? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_message "Nettoyage en cours..."
        
        # Arrêter tous les conteneurs
        print_message "Arrêt des conteneurs..."
        docker stop ai-agent-ollama ai-agent-ollama-setup ai-agent-app 2>/dev/null || true
        
        # Supprimer les conteneurs
        print_message "Suppression des conteneurs..."
        docker rm -f ai-agent-ollama ai-agent-ollama-setup ai-agent-app 2>/dev/null || true
        
        # Supprimer avec docker-compose
        $DOCKER_COMPOSE -f $COMPOSE_FILE down -v 2>/dev/null || true
        
        # Nettoyer les conteneurs orphelins
        docker container prune -f 2>/dev/null || true
        
        # Supprimer le réseau
        docker network rm ai-agent-network 2>/dev/null || true
        
        # Supprimer les images
        docker rmi ai-coding-agent-app ai-coding-agent_app 2>/dev/null || true
        
        print_success "Nettoyage terminé!"
        print_message "Vous pouvez redémarrer avec: ./start.sh"
    else
        print_message "Annulé."
    fi
}

# Nettoyage léger (conteneurs seulement, garde les volumes)
clean_containers() {
    print_message "Nettoyage des conteneurs..."
    
    docker stop ai-agent-ollama ai-agent-ollama-setup ai-agent-app 2>/dev/null || true
    docker rm -f ai-agent-ollama ai-agent-ollama-setup ai-agent-app 2>/dev/null || true
    docker container prune -f 2>/dev/null || true
    
    print_success "Conteneurs nettoyés!"
    print_message "Les volumes (modèles) ont été conservés."
}

# Shell interactif dans le conteneur app
shell() {
    $DOCKER_COMPOSE -f $COMPOSE_FILE exec app sh
}

# Shell interactif dans le conteneur ollama
ollama_shell() {
    $DOCKER_COMPOSE -f $COMPOSE_FILE exec ollama bash
}

# Afficher l'aide
show_help() {
    cat << EOF
Usage: ./start.sh [commande]

Commandes disponibles:
  start              Démarrer tous les services (défaut)
  stop               Arrêter tous les services
  restart            Redémarrer tous les services
  logs               Afficher les logs en temps réel
  status             Afficher le statut des services
  pull-model         Télécharger un nouveau modèle Ollama
  list-models        Lister les modèles Ollama installés
  rebuild            Reconstruire l'image de l'application
  clean              Tout nettoyer (conteneurs, images, volumes)
  clean-containers   Nettoyer seulement les conteneurs (garde les volumes)
  shell              Ouvrir un shell dans le conteneur app
  ollama-shell       Ouvrir un shell dans le conteneur ollama
  help               Afficher cette aide

Exemples:
  ./start.sh                      # Démarrer l'application
  ./start.sh logs                 # Voir les logs
  ./start.sh pull-model llama3    # Télécharger le modèle llama3
  ./start.sh clean-containers     # Nettoyer les conteneurs corrompus
  ./start.sh stop                 # Arrêter l'application

EOF
}

# Point d'entrée principal
main() {
    check_docker

    case "${1:-start}" in
        start)
            start_services
            ;;
        stop)
            stop_services
            ;;
        restart)
            stop_services
            sleep 2
            start_services
            ;;
        logs)
            show_logs
            ;;
        status)
            show_status
            ;;
        pull-model)
            pull_model "$2"
            ;;
        list-models)
            list_models
            ;;
        rebuild)
            rebuild
            ;;
        clean)
            clean
            ;;
        clean-containers)
            clean_containers
            ;;
        shell)
            shell
            ;;
        ollama-shell)
            ollama_shell
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Commande inconnue: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
