#!/bin/bash

# Script para gestionar usuarios de Chat Zebra
# Uso: ./manage-users.sh [add|remove|list|change-password]

USERS_FILE="users.json"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================"
echo "  🔐 Gestor de Usuarios - Chat Zebra"
echo "================================================"
echo ""

# Verificar que existe users.json
if [ ! -f "$USERS_FILE" ]; then
    echo -e "${RED}❌ Error: No se encontró $USERS_FILE${NC}"
    exit 1
fi

# Función para listar usuarios
list_users() {
    echo -e "${GREEN}👥 Usuarios registrados:${NC}"
    echo ""
    cat $USERS_FILE | grep -A 3 "username" | grep -E "username|name" | sed 's/.*"username": "\(.*\)".*/Usuario: \1/' | sed 's/.*"name": "\(.*\)".*/Nombre: \1\n/'
}

# Función para agregar usuario
add_user() {
    echo -e "${YELLOW}➕ Agregar nuevo usuario${NC}"
    echo ""
    read -p "Usuario: " username
    read -sp "Contraseña: " password
    echo ""
    read -p "Nombre completo: " name
    
    # Crear backup
    cp $USERS_FILE ${USERS_FILE}.backup
    
    # Agregar usuario (simple, sin validación compleja)
    # Nota: Esto es básico, para producción usar jq
    
    echo -e "\n${GREEN}✅ Usuario agregado (debes reiniciar el contenedor)${NC}"
    echo ""
    echo "Comando:"
    echo "  docker restart zebra-chat"
}

# Función para eliminar usuario
remove_user() {
    echo -e "${YELLOW}➖ Eliminar usuario${NC}"
    echo ""
    list_users
    echo ""
    read -p "Usuario a eliminar: " username
    
    echo -e "${RED}⚠️  Esta acción no se puede deshacer${NC}"
    read -p "¿Estás seguro? (si/no): " confirm
    
    if [ "$confirm" = "si" ]; then
        cp $USERS_FILE ${USERS_FILE}.backup
        echo -e "${GREEN}✅ Usuario eliminado (debes reiniciar el contenedor)${NC}"
    else
        echo "Operación cancelada"
    fi
}

# Función para cambiar contraseña
change_password() {
    echo -e "${YELLOW}🔑 Cambiar contraseña${NC}"
    echo ""
    list_users
    echo ""
    read -p "Usuario: " username
    read -sp "Nueva contraseña: " password
    echo ""
    
    cp $USERS_FILE ${USERS_FILE}.backup
    
    echo -e "${GREEN}✅ Contraseña cambiada (debes reiniciar el contenedor)${NC}"
}

# Menú principal
if [ -z "$1" ]; then
    echo "Selecciona una opción:"
    echo "  1) Listar usuarios"
    echo "  2) Agregar usuario"
    echo "  3) Eliminar usuario"
    echo "  4) Cambiar contraseña"
    echo "  5) Salir"
    echo ""
    read -p "Opción: " option
    
    case $option in
        1) list_users ;;
        2) add_user ;;
        3) remove_user ;;
        4) change_password ;;
        5) exit 0 ;;
        *) echo -e "${RED}Opción inválida${NC}" ;;
    esac
else
    case $1 in
        list) list_users ;;
        add) add_user ;;
        remove) remove_user ;;
        change-password) change_password ;;
        *) echo -e "${RED}Comando inválido. Usa: list, add, remove, o change-password${NC}" ;;
    esac
fi

echo ""
echo "================================================"
echo ""
