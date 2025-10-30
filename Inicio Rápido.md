# 🚀 INICIO RÁPIDO - Chat Zebra v4

## ⚡ En 5 minutos tendrás login funcionando

### **PASO 1: Descomprimir (30 segundos)**
```bash
unzip Chat_n8n_v4_AUTH.zip
cd chat-n8n-v4
```

### **PASO 2: Construir y Deploy (2 minutos)**
```bash
# Detener versión anterior
docker stop zebra-chat 2>/dev/null
docker rm zebra-chat 2>/dev/null

# Construir nueva versión con PHP
docker build -t zebra-chat:v4 .

# Correr
docker run -d -p 80:80 --name zebra-chat --restart unless-stopped zebra-chat:v4
```

### **PASO 3: Probar (30 segundos)**
```bash
# Abrir en navegador
http://tu-servidor/

# Credenciales por defecto:
Usuario: admin
Contraseña: zebra2024
```

✅ **¡Listo! Ya tienes login funcionando**

---

## 🔐 CAMBIAR USUARIOS (1 minuto)

### **Método 1: Editar directamente**
```bash
nano users.json
```

Ejemplo:
```json
{
  "users": [
    {
      "username": "admin",
      "password": "tu_nueva_contraseña",
      "name": "Administrador"
    },
    {
      "username": "maria",
      "password": "maria123",
      "name": "María García"
    }
  ]
}
```

Reiniciar:
```bash
docker restart zebra-chat
```

### **Método 2: Con Docker volumen (sin rebuild)**
```bash
# Primera vez:
mkdir -p /var/zebra-data
cp users.json /var/zebra-data/

docker run -d -p 80:80 \
  -v /var/zebra-data/users.json:/var/www/html/users.json \
  --name zebra-chat \
  zebra-chat:v4

# Para cambiar usuarios después:
nano /var/zebra-data/users.json
docker restart zebra-chat
```

---

## 📊 ESTRUCTURA DE users.json

```json
{
  "users": [
    {
      "username": "nombre_usuario",    ← Login username
      "password": "contraseña",        ← Texto plano (cambiar en producción)
      "name": "Nombre Completo"        ← Se muestra en el header
    }
  ]
}
```

**Para agregar usuario:** Copia el bloque completo y cambia los valores  
**Para eliminar usuario:** Borra el bloque completo (incluyendo comas)  

---

## 🎯 CHECKLIST POST-DEPLOY

- [ ] Login funciona con `admin` / `zebra2024`
- [ ] Cambiar contraseña de `admin` en `users.json`
- [ ] Agregar usuarios reales
- [ ] Reiniciar contenedor: `docker restart zebra-chat`
- [ ] Probar login con nuevo usuario
- [ ] Probar botón "Cerrar Sesión"
- [ ] Verificar que sin login no puede acceder a `/index.html`

---

## 🔧 COMANDOS ÚTILES

```bash
# Ver logs
docker logs zebra-chat

# Ver usuarios dentro del contenedor
docker exec zebra-chat cat /var/www/html/users.json

# Editar usuarios sin salir del contenedor
docker exec -it zebra-chat nano /var/www/html/users.json

# Reiniciar
docker restart zebra-chat

# Backup de usuarios
docker cp zebra-chat:/var/www/html/users.json ./users.backup.json
```

---

## 🚨 IMPORTANTE PARA PRODUCCIÓN

1. **Cambiar contraseñas por defecto**
2. **Usar HTTPS** (Certbot + Nginx)
3. **Considerar cifrar contraseñas** (password_hash en PHP)

Ver `README.md` para detalles completos.

---

## 💡 TIPS

- Session dura mientras el navegador esté abierto
- Cerrar sesión limpia el sessionStorage
- Cada usuario mantiene su propia sesión de chat (sessionId separado)
- El archivo `users.json` se lee cada vez que alguien hace login

---

**¿Problemas?** Lee el README.md completo o verifica los logs.
