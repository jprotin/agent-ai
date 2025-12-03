#!/bin/bash

# Script de démarrage enrichi pour l'Agent IA de Développement
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
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
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

print_info() {
    echo -e "${CYAN}[AI-Agent]${NC} $1"
}

# Utiliser la version sans healthcheck par défaut (plus compatible)
if [ -z "$COMPOSE_FILE_OVERRIDE" ] && [ -f "$COMPOSE_FILE_NOHEALTH" ]; then
    COMPOSE_FILE="$COMPOSE_FILE_NOHEALTH"
fi

# ═══════════════════════════════════════════════════════════════════════════
# FONCTIONS DE DÉTECTION SYSTÈME
# ═══════════════════════════════════════════════════════════════════════════

# Détecter la RAM disponible (en Go)
detect_ram() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        RAM_GB=$((RAM_KB / 1024 / 1024))
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        RAM_BYTES=$(sysctl -n hw.memsize)
        RAM_GB=$((RAM_BYTES / 1024 / 1024 / 1024))
    else
        # Par défaut, supposer 8 GB
        RAM_GB=8
    fi
    echo $RAM_GB
}

# Afficher les informations système
show_system_info() {
    RAM_GB=$(detect_ram)

    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}            INFORMATIONS SYSTÈME${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "  ${BLUE}Système d'exploitation:${NC} $OSTYPE"
    echo -e "  ${BLUE}RAM totale disponible:${NC}  ${GREEN}${RAM_GB} GB${NC}"
    echo ""

    # Recommandations selon la RAM
    if [ $RAM_GB -lt 4 ]; then
        echo -e "  ${RED}⚠️  RAM insuffisante (<4 GB)${NC}"
        echo -e "  ${YELLOW}Recommandation: Modèles ultra-légers uniquement${NC}"
    elif [ $RAM_GB -lt 8 ]; then
        echo -e "  ${YELLOW}⚠️  RAM limitée (4-8 GB)${NC}"
        echo -e "  ${YELLOW}Recommandation: Modèles légers recommandés${NC}"
    else
        echo -e "  ${GREEN}✓ RAM suffisante (≥8 GB)${NC}"
        echo -e "  ${GREEN}Vous pouvez utiliser la plupart des modèles${NC}"
    fi

    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
# FONCTIONS DE GESTION DES MODÈLES
# ═══════════════════════════════════════════════════════════════════════════

# Lister les modèles compatibles avec la RAM
list_compatible_models() {
    RAM_GB=$(detect_ram)

    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}            MODÈLES LLM COMPATIBLES${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "  ${BLUE}RAM détectée:${NC} ${GREEN}${RAM_GB} GB${NC}"
    echo ""

    # Modèles ultra-légers (< 4 GB RAM)
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  MODÈLES ULTRA-LÉGERS (1-2 GB RAM)${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${CYAN}1.${NC} qwen2.5-coder:1.5b     ${YELLOW}[RECOMMANDÉ]${NC}"
    echo -e "     └─ Taille: ~900 MB | RAM: ~2 GB"
    echo -e "     └─ Excellent pour le code, très rapide"
    echo ""
    echo -e "  ${CYAN}2.${NC} deepseek-coder:1.3b"
    echo -e "     └─ Taille: ~800 MB | RAM: ~1.5 GB"
    echo -e "     └─ Spécialisé dans le code"
    echo ""
    echo -e "  ${CYAN}3.${NC} tinyllama"
    echo -e "     └─ Taille: ~637 MB | RAM: ~1 GB"
    echo -e "     └─ Le plus léger, bonne performance générale"
    echo ""
    echo -e "  ${CYAN}4.${NC} phi3:mini"
    echo -e "     └─ Taille: ~2.3 GB | RAM: ~3 GB"
    echo -e "     └─ Microsoft, excellent rapport qualité/taille"
    echo ""

    # Modèles standards (≥ 8 GB RAM)
    if [ $RAM_GB -ge 8 ]; then
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BLUE}  MODÈLES STANDARDS (6-8 GB RAM)${NC}"
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "  ${CYAN}5.${NC} codellama"
        echo -e "     └─ Taille: ~3.8 GB | RAM: ~5.5 GB"
        echo -e "     └─ Meta, optimisé pour le code"
        echo ""
        echo -e "  ${CYAN}6.${NC} llama3"
        echo -e "     └─ Taille: ~4.7 GB | RAM: ~6 GB"
        echo -e "     └─ Meta, usage général"
        echo ""
        echo -e "  ${CYAN}7.${NC} qwen2.5-coder (standard)"
        echo -e "     └─ Taille: ~4.7 GB | RAM: ~6 GB"
        echo -e "     └─ Version complète de qwen2.5-coder"
        echo ""
        echo -e "  ${CYAN}8.${NC} deepseek-coder (standard)"
        echo -e "     └─ Taille: ~3.8 GB | RAM: ~5 GB"
        echo -e "     └─ Version complète de deepseek-coder"
        echo ""
    fi

    # Modèles avancés (≥ 16 GB RAM)
    if [ $RAM_GB -ge 16 ]; then
        echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${MAGENTA}  MODÈLES AVANCÉS (12+ GB RAM)${NC}"
        echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "  ${CYAN}9.${NC} llama3:70b"
        echo -e "     └─ Taille: ~39 GB | RAM: ~48 GB"
        echo -e "     └─ Très haute performance, nécessite beaucoup de RAM"
        echo ""
        echo -e "  ${CYAN}10.${NC} mistral:7b"
        echo -e "     └─ Taille: ~4.1 GB | RAM: ~8 GB"
        echo -e "     └─ Excellent équilibre performance/taille"
        echo ""
    fi

    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Menu interactif pour installer un modèle
install_model_interactive() {
    RAM_GB=$(detect_ram)

    # Vérifier qu'Ollama tourne
    if ! docker ps | grep -q ai-agent-ollama; then
        print_error "Le conteneur Ollama n'est pas en cours d'exécution"
        print_warning "Démarrez-le d'abord avec: ${CYAN}./start.sh start${NC}"
        exit 1
    fi

    # Attendre qu'Ollama soit prêt
    print_message "Vérification de la connexion à Ollama..."
    sleep 2

    if ! docker exec ai-agent-ollama curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        print_error "Ollama ne répond pas encore"
        print_warning "Attendez quelques secondes et réessayez"
        exit 1
    fi

    print_success "Ollama est accessible"

    # Afficher les modèles compatibles
    list_compatible_models

    # Menu de sélection
    echo -e "${YELLOW}Que souhaitez-vous faire ?${NC}"
    echo ""
    echo "  1) Installer un modèle ultra-léger (recommandé)"
    echo "  2) Installer un modèle standard (≥8 GB RAM)"
    echo "  3) Installer un modèle personnalisé"
    echo "  4) Lister les modèles déjà installés"
    echo "  5) Retour"
    echo ""
    read -p "Votre choix (1-5): " choice

    case $choice in
        1)
            install_ultralight_model
            ;;
        2)
            if [ $RAM_GB -lt 8 ]; then
                print_error "RAM insuffisante pour les modèles standards (minimum 8 GB)"
                print_warning "Votre système dispose de ${RAM_GB} GB de RAM"
                echo ""
                read -p "Voulez-vous installer un modèle ultra-léger à la place ? (o/n) " yn
                if [[ $yn =~ ^[Oo]$ ]]; then
                    install_ultralight_model
                fi
            else
                install_standard_model
            fi
            ;;
        3)
            install_custom_model
            ;;
        4)
            list_installed_models
            ;;
        5)
            return
            ;;
        *)
            print_error "Choix invalide"
            ;;
    esac
}

# Installer un modèle ultra-léger
install_ultralight_model() {
    echo ""
    echo -e "${CYAN}Choisissez un modèle ultra-léger:${NC}"
    echo ""
    echo "  1) qwen2.5-coder:1.5b (RECOMMANDÉ - ~900 MB)"
    echo "  2) deepseek-coder:1.3b (~800 MB)"
    echo "  3) tinyllama (~637 MB)"
    echo "  4) phi3:mini (~2.3 GB)"
    echo "  5) Installer tous les modèles ultra-légers"
    echo ""
    read -p "Votre choix (1-5): " choice

    case $choice in
        1)
            pull_model_with_progress "qwen2.5-coder:1.5b"
            ;;
        2)
            pull_model_with_progress "deepseek-coder:1.3b"
            ;;
        3)
            pull_model_with_progress "tinyllama"
            ;;
        4)
            pull_model_with_progress "phi3:mini"
            ;;
        5)
            print_message "Installation de tous les modèles ultra-légers..."
            pull_model_with_progress "qwen2.5-coder:1.5b"
            pull_model_with_progress "deepseek-coder:1.3b"
            pull_model_with_progress "tinyllama"
            pull_model_with_progress "phi3:mini"
            ;;
        *)
            print_error "Choix invalide"
            ;;
    esac
}

# Installer un modèle standard
install_standard_model() {
    echo ""
    echo -e "${CYAN}Choisissez un modèle standard:${NC}"
    echo ""
    echo "  1) codellama (~3.8 GB)"
    echo "  2) llama3 (~4.7 GB)"
    echo "  3) qwen2.5-coder (~4.7 GB)"
    echo "  4) deepseek-coder (~3.8 GB)"
    echo ""
    read -p "Votre choix (1-4): " choice

    case $choice in
        1)
            pull_model_with_progress "codellama"
            ;;
        2)
            pull_model_with_progress "llama3"
            ;;
        3)
            pull_model_with_progress "qwen2.5-coder"
            ;;
        4)
            pull_model_with_progress "deepseek-coder"
            ;;
        *)
            print_error "Choix invalide"
            ;;
    esac
}

# Installer un modèle personnalisé
install_custom_model() {
    echo ""
    read -p "Entrez le nom du modèle (ex: mistral, llama3:70b): " model_name

    if [ -z "$model_name" ]; then
        print_error "Nom de modèle invalide"
        return
    fi

    pull_model_with_progress "$model_name"
}

# Télécharger un modèle avec barre de progression
pull_model_with_progress() {
    local model=$1

    echo ""
    print_message "Téléchargement du modèle: ${CYAN}${model}${NC}"
    print_warning "Cela peut prendre 2-15 minutes selon la taille et votre connexion"
    echo ""

    docker exec -it ai-agent-ollama ollama pull $model

    if [ $? -eq 0 ]; then
        echo ""
        print_success "Modèle ${CYAN}${model}${NC} installé avec succès !"
        echo ""
    else
        echo ""
        print_error "Erreur lors de l'installation du modèle"
        print_warning "Vérifiez votre connexion internet et réessayez"
        echo ""
    fi
}

# Lister les modèles installés
list_installed_models() {
    echo ""
    print_message "Modèles installés sur votre système:"
    echo ""
    docker exec ai-agent-ollama ollama list
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
# FONCTIONS DE GESTION DES SERVICES
# ═══════════════════════════════════════════════════════════════════════════

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

    echo ""
    print_message "Attente du démarrage complet..."
    print_info "- Ollama démarre (10-20 secondes)"
    print_info "- Téléchargement du modèle qwen2.5-coder:1.5b (2-5 minutes la première fois)"
    print_info "- Application Next.js démarre (30-40 secondes)"
    echo ""
    print_warning "Soyez patient, cela peut prendre du temps la première fois !"
    echo ""

    # Attendre un peu pour laisser les services démarrer
    sleep 5

    print_success "Services lancés !"
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "  ${BLUE}Application:${NC}      ${GREEN}http://localhost:3000${NC}"
    echo -e "  ${BLUE}API Ollama:${NC}       ${GREEN}http://localhost:11434${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    print_info "Commandes utiles:"
    echo -e "  ${YELLOW}./start.sh logs${NC}           - Voir les logs en temps réel"
    echo -e "  ${YELLOW}./start.sh status${NC}         - Voir le statut des services"
    echo -e "  ${YELLOW}./start.sh install-model${NC}  - Installer un modèle LLM"
    echo -e "  ${YELLOW}./start.sh help${NC}           - Afficher toutes les commandes"
    echo ""
}

# Arrêter les services
stop_services() {
    print_message "Arrêt des services..."
    $DOCKER_COMPOSE -f $COMPOSE_FILE down
    print_success "Services arrêtés !"
}

# Redémarrer les services
restart_services() {
    stop_services
    sleep 2
    start_services
}

# Afficher les logs
show_logs() {
    print_message "Affichage des logs (Ctrl+C pour quitter)..."
    echo ""
    $DOCKER_COMPOSE -f $COMPOSE_FILE logs -f
}

# Afficher le statut
show_status() {
    echo ""
    print_message "Statut des services:"
    echo ""
    $DOCKER_COMPOSE -f $COMPOSE_FILE ps
    echo ""

    # Vérifier la connectivité Ollama
    if docker ps | grep -q ai-agent-ollama; then
        if docker exec ai-agent-ollama curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
            print_success "Ollama est en ligne et opérationnel"
        else
            print_warning "Ollama démarre encore..."
        fi
    else
        print_error "Ollama n'est pas en cours d'exécution"
    fi

    echo ""
}

# Rebuild l'application
rebuild() {
    print_message "Reconstruction de l'application..."
    $DOCKER_COMPOSE -f $COMPOSE_FILE build --no-cache app
    print_success "Application reconstruite !"
    echo ""
    print_info "Redémarrez avec: ${YELLOW}./start.sh restart${NC}"
}

# Nettoyer complètement
clean() {
    print_warning "Cette action va supprimer tous les conteneurs, images et volumes."
    print_warning "Vous perdrez tous les modèles téléchargés !"
    echo ""
    read -p "Êtes-vous sûr? (o/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Oo]$ ]]; then
        print_message "Nettoyage en cours..."

        # Arrêter tous les conteneurs
        print_info "Arrêt des conteneurs..."
        docker stop ai-agent-ollama ai-agent-ollama-setup ai-agent-app 2>/dev/null || true

        # Supprimer les conteneurs
        print_info "Suppression des conteneurs..."
        docker rm -f ai-agent-ollama ai-agent-ollama-setup ai-agent-app 2>/dev/null || true

        # Supprimer avec docker-compose
        $DOCKER_COMPOSE -f $COMPOSE_FILE down -v 2>/dev/null || true

        # Nettoyer les conteneurs orphelins
        docker container prune -f 2>/dev/null || true

        # Supprimer le réseau
        docker network rm ai-agent-network 2>/dev/null || true

        # Supprimer les images
        docker rmi ai-coding-agent-app ai-coding-agent_app 2>/dev/null || true

        print_success "Nettoyage terminé !"
        echo ""
        print_info "Vous pouvez redémarrer avec: ${YELLOW}./start.sh${NC}"
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

    print_success "Conteneurs nettoyés !"
    print_info "Les volumes (modèles) ont été conservés."
}

# Shell interactif dans le conteneur app
shell() {
    print_message "Ouverture d'un shell dans le conteneur app..."
    $DOCKER_COMPOSE -f $COMPOSE_FILE exec app sh
}

# Shell interactif dans le conteneur ollama
ollama_shell() {
    print_message "Ouverture d'un shell dans le conteneur ollama..."
    $DOCKER_COMPOSE -f $COMPOSE_FILE exec ollama bash
}

# Diagnostic complet du système
diagnose() {
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}            DIAGNOSTIC DU SYSTÈME${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""

    # 1. Vérifier Docker
    print_message "1. Vérification de Docker..."
    if command -v docker &> /dev/null; then
        print_success "Docker est installé ($(docker --version))"
    else
        print_error "Docker n'est pas installé"
    fi
    echo ""

    # 2. Vérifier les conteneurs
    print_message "2. Vérification des conteneurs..."
    if docker ps | grep -q ai-agent-ollama; then
        print_success "Conteneur Ollama en cours d'exécution"
    else
        print_error "Conteneur Ollama non démarré"
    fi

    if docker ps | grep -q ai-agent-app; then
        print_success "Conteneur App en cours d'exécution"
    else
        print_error "Conteneur App non démarré"
    fi
    echo ""

    # 3. Vérifier la connectivité Ollama
    print_message "3. Vérification de la connectivité Ollama..."
    if docker ps | grep -q ai-agent-ollama; then
        if docker exec ai-agent-ollama curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
            print_success "Ollama API accessible"
        else
            print_error "Ollama API non accessible"
        fi
    else
        print_warning "Ollama non démarré, impossible de vérifier"
    fi
    echo ""

    # 4. Vérifier les modèles installés
    print_message "4. Vérification des modèles installés..."
    if docker ps | grep -q ai-agent-ollama; then
        MODEL_COUNT=$(docker exec ai-agent-ollama ollama list 2>/dev/null | tail -n +2 | wc -l)
        if [ "$MODEL_COUNT" -gt 0 ]; then
            print_success "$MODEL_COUNT modèle(s) installé(s)"
            docker exec ai-agent-ollama ollama list
        else
            print_error "Aucun modèle installé"
            print_info "Installez un modèle avec: ${YELLOW}./start.sh install-model${NC}"
        fi
    else
        print_warning "Ollama non démarré, impossible de vérifier"
    fi
    echo ""

    # 5. Vérifier les logs récents
    print_message "5. Logs récents de l'application..."
    if docker ps | grep -q ai-agent-app; then
        docker logs ai-agent-app 2>&1 | tail -20
    else
        print_warning "Application non démarrée"
    fi
    echo ""

    # 6. RAM disponible
    show_system_info

    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
# MENU D'AIDE COMPLET
# ═══════════════════════════════════════════════════════════════════════════

show_help() {

echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}        AGENT IA DE DÉVELOPPEMENT - GUIDE COMPLET${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"

echo -e "${YELLOW}USAGE:${NC}"
echo -e "  ./start.sh [commande]"

echo -e "${YELLOW}COMMANDES PRINCIPALES:${NC}"

echo -e "  ${GREEN}start${NC}"
echo -e "    Démarre tous les services Docker (Ollama + Application)${NC}"
echo -e "    - Télécharge automatiquement le modèle par défaut${NC}"
echo -e "    - Lance l'application sur http://localhost:3000${NC}"
echo -e "    - Lance l'API Ollama sur http://localhost:11434${NC}"
echo -e "    ${CYAN}Exemple: ./start.sh start${NC}"

echo -e "  ${GREEN}stop${NC}"
echo -e "    Arrête tous les services en cours d'exécution${NC}"
echo -e "    - Conserve les volumes (modèles téléchargés)${NC}"
echo -e "    - Arrête proprement tous les conteneurs${NC}"
echo -e "    ${CYAN}Exemple: ./start.sh stop${NC}"

echo -e "  ${GREEN}restart${NC}"
echo -e "    Redémarre tous les services${NC}"
echo -e "    - Équivalent à stop puis start${NC}"
echo -e "    ${CYAN}Exemple: ./start.sh restart${NC}"

echo -e "${YELLOW}COMMANDES DE MONITORING:${NC}"

echo -e "  ${GREEN}logs${NC}"
echo -e "    Affiche les logs en temps réel de tous les services${NC}"
echo -e "    - Utile pour le débogage${NC}"
echo -e "    - Appuyez sur Ctrl+C pour quitter${NC}"
echo -e "    ${CYAN}Exemple: ./start.sh logs${NC}"

echo -e "  ${GREEN}status${NC}"
echo -e "    Affiche le statut de tous les services${NC}"
echo -e "    - Montre si les conteneurs sont en cours d'exécution${NC}"
echo -e "    - Vérifie la connectivité Ollama${NC}"
echo -e "    ${CYAN}Exemple: ./start.sh status${NC}"

echo -e "  ${GREEN}diagnose${NC}"
echo -e "    Effectue un diagnostic complet du système${NC}"
echo -e "    - Vérifie Docker, les conteneurs, Ollama${NC}"
echo -e "    - Liste les modèles installés${NC}"
echo -e "    - Affiche la RAM disponible${NC}"
echo -e "    - Montre les logs récents${NC}"
echo -e "    ${CYAN}Exemple: ./start.sh diagnose${NC}"

echo -e "${YELLOW}COMMANDES DE GESTION DES MODÈLES LLM:${NC}"

echo -e "  ${GREEN}install-model${NC}"
echo -e "    Menu interactif pour installer des modèles LLM${NC}"
echo -e "    - Détecte automatiquement votre RAM${NC}"
echo -e "    - Propose uniquement les modèles compatibles${NC}"
echo -e "    - Installation guidée étape par étape${NC}"
echo -e "    ${CYAN}Exemple: ./start.sh install-model${NC}"

echo -e "  ${GREEN}list-models${NC}"
echo -e "    Liste tous les modèles Ollama installés${NC}"
echo -e "    - Affiche le nom, la taille et la date de modification${NC}"
echo -e "    ${CYAN}Exemple: ./start.sh list-models${NC}"

echo -e "  ${GREEN}show-compatible${NC}"
echo -e "    Affiche tous les modèles compatibles avec votre RAM${NC}"
echo -e "    - Détecte automatiquement votre RAM disponible${NC}"
echo -e "    - Catégorise par niveau de RAM requis${NC}"
echo -e "    ${CYAN}Exemple: ./start.sh show-compatible${NC}"

echo -e "  ${GREEN}system-info${NC}"
echo -e "    Affiche les informations système${NC}"
echo -e "    - RAM totale disponible${NC}"
echo -e "    - Système d'exploitation${NC}"
echo -e "    - Recommandations de modèles${NC}"
echo -e "    ${CYAN}Exemple: ./start.sh system-info${NC}"

echo -e "${YELLOW}COMMANDES DE MAINTENANCE:${NC}"

echo -e "  ${GREEN}rebuild${NC}"
echo -e "    Reconstruit l'image Docker de l'application${NC}"
echo -e "    - Utile après modification du code${NC}"
echo -e "    - Force une reconstruction complète (--no-cache)${NC}"
echo -e "    ${CYAN}Exemple: ./start.sh rebuild${NC}"

echo -e "  ${GREEN}clean-containers${NC}"
echo -e "    Nettoie seulement les conteneurs${NC}"
echo -e "    - Conserve les volumes (modèles)${NC}"
echo -e "    - Utile en cas de conteneurs corrompus${NC}"
echo -e "    ${CYAN}Exemple: ./start.sh clean-containers${NC}"

echo -e "  ${GREEN}clean${NC}"
echo -e "    Nettoyage complet du système${NC}"
echo -e "    ${RED}⚠️  ATTENTION: Supprime TOUT (conteneurs, images, volumes)${NC}"
echo -e "    - Vous perdrez tous les modèles téléchargés${NC}"
echo -e "    - Demande confirmation avant suppression${NC}"
echo -e "    ${CYAN}Exemple: ./start.sh clean${NC}"

echo -e "${YELLOW}COMMANDES AVANCÉES:${NC}"

echo -e "  ${GREEN}shell${NC}"
echo -e "    Ouvre un shell interactif dans le conteneur de l'application${NC}"
echo -e "    - Utile pour le débogage avancé${NC}"
echo -e "    - Accès direct au filesystem du conteneur${NC}"
echo -e "    ${CYAN}Exemple: ./start.sh shell${NC}"

echo -e "  ${GREEN}ollama-shell${NC}"
echo -e "    Ouvre un shell interactif dans le conteneur Ollama${NC}"
echo -e "    - Permet d'exécuter des commandes Ollama directement${NC}"
echo -e "    ${CYAN}Exemple: ./start.sh ollama-shell${NC}"

echo -e "  ${GREEN}help${NC}"
echo -e "    Affiche cette aide complète${NC}"
echo -e "    ${CYAN}Exemple: ./start.sh help${NC}"

echo -e "${YELLOW}EXEMPLES D'UTILISATION COURANTS:${NC}"

echo -e "  ${CYAN}# Démarrage initial${NC}"
echo -e "  ./start.sh start${NC}"

echo -e "  ${CYAN}# Installer un modèle compatible avec votre RAM${NC}"
echo -e "  ./start.sh install-model${NC}"

echo -e "  ${CYAN}# Vérifier que tout fonctionne${NC}"
echo -e "  ./start.sh diagnose${NC}"

echo -e "  ${CYAN}# Voir les logs en temps réel${NC}"
echo -e "  ./start.sh logs${NC}"

echo -e "  ${CYAN}# Nettoyer et redémarrer proprement${NC}"
echo -e "  ./start.sh clean-containers${NC}"
echo -e "  ./start.sh start${NC}"

echo -e "${YELLOW}RÉSOLUTION DE PROBLÈMES:${NC}"

echo -e "  ${RED}Problème:${NC} Erreur 500 sur l'application${NC}"
echo -e "  ${GREEN}Solution:${NC} ./start.sh diagnose${NC}"
echo -e "             Vérifiez qu'au moins un modèle est installé${NC}"
echo -e "             ./start.sh install-model${NC}"

echo -e "  ${RED}Problème:${NC} Les conteneurs ne démarrent pas${NC}"
echo -e "  ${GREEN}Solution:${NC} ./start.sh clean-containers${NC}"
echo -e "             ./start.sh start${NC}"

echo -e "  ${RED}Problème:${NC} Modèle trop lourd pour votre RAM${NC}"
echo -e "  ${GREEN}Solution:${NC} ./start.sh show-compatible${NC}"
echo -e "             Installez un modèle ultra-léger (ex: qwen2.5-coder:1.5b)${NC}"

echo -e "${YELLOW}INFORMATIONS:${NC}"

echo -e "  ${BLUE}Documentation:${NC}  README.md${NC}"
echo -e "  ${BLUE}Logs:${NC}           docker-compose logs -f${NC}"
echo -e "  ${BLUE}Application:${NC}    http://localhost:3000${NC}"
echo -e "  ${BLUE}API Ollama:${NC}     http://localhost:11434${NC}"

echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"

}

# ═══════════════════════════════════════════════════════════════════════════
# POINT D'ENTRÉE PRINCIPAL
# ═══════════════════════════════════════════════════════════════════════════

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
            restart_services
            ;;
        logs)
            show_logs
            ;;
        status)
            show_status
            ;;
        install-model)
            install_model_interactive
            ;;
        list-models)
            list_installed_models
            ;;
        show-compatible)
            list_compatible_models
            ;;
        system-info)
            show_system_info
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
        diagnose)
            diagnose
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Commande inconnue: $1"
            echo ""
            print_info "Utilisez ${YELLOW}./start.sh help${NC} pour voir toutes les commandes disponibles"
            exit 1
            ;;
    esac
}

main "$@"
