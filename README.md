# 🔐 Chat Zebra v4 - Con Autenticación

## 🆕 Novedades v4

✅ **Login con usuario/contraseña** - Protección de acceso  
✅ **Gestión simple de usuarios** - Archivo JSON fácil de editar  
✅ **Botón de logout** - Cerrar sesión segura  
✅ **Session storage** - Sesión persiste durante la navegación  

---

## 👥 GESTIÓN DE USUARIOS

### **Archivo: `users.json`**

Este archivo contiene todos los usuarios permitidos. Es **muy fácil de editar**.

**Estructura:**
```json
{
  "users": [
    {
      "username": "admin",
      "password": "zebra2024",
      "name": "Administrador"
    },
    {
      "username": "usuario1",
      "password": "pass123",
      "name": "Usuario Demo"
    }
  ]
}
```

### **Cómo agregar un usuario:**

1. Abre el archivo `users.json`
2. Agrega un nuevo objeto al array `users`:
   ```json
   {
     "username": "nuevo_usuario",
     "password": "su_contraseña",
     "name": "Nombre Completo"
   }
   ```
3. Guarda el archivo
4. **Si está en Docker:** Reinicia el contenedor
   ```bash
   docker restart zebra-chat
   ```

### **Cómo eliminar un usuario:**

1. Abre `users.json`
2. Elimina todo el bloque del usuario (desde `{` hasta `}` incluyendo la coma)
3. Guarda y reinicia el contenedor

### **Cómo cambiar una contraseña:**

1. Abre `users.json`
2. Busca el usuario
3. Cambia el valor de `"password"`
4. Guarda y reinicia el contenedor

---

## 🚀 DEPLOY

### **Opción 1: Docker (Recomendado)**

```bash
# 1. Descomprimir
unzip Chat_n8n_v4_AUTH.zip
cd chat-n8n-v4

# 2. OPCIONAL: Editar usuarios ANTES de construir
nano users.json

# 3. Construir imagen
docker build -t zebra-chat:v4 .

# 4. Detener versión anterior (si existe)
docker stop zebra-chat
docker rm zebra-chat

# 5. Correr nueva versión
docker run -d \
  -p 80:80 \
  --name zebra-chat \
  --restart unless-stopped \
  zebra-chat:v4

# 6. Verificar que funciona
docker logs zebra-chat
```

### **Opción 2: Docker con volumen para users.json (Para cambios sin rebuild)**

```bash
# Crear directorio para datos
mkdir -p /var/zebra-data

# Copiar users.json inicial
cp users.json /var/zebra-data/

# Correr con volumen montado
docker run -d \
  -p 80:80 \
  -v /var/zebra-data/users.json:/var/www/html/users.json \
  --name zebra-chat \
  --restart unless-stopped \
  zebra-chat:v4
```

**Ventaja:** Puedes editar `/var/zebra-data/users.json` y reiniciar sin rebuild:
```bash
nano /var/zebra-data/users.json
docker restart zebra-chat
```

---

## 🧪 PRUEBAS

### **Test 1: Login**

1. Abre: `http://tu-servidor/`
2. Deberías ver la página de login
3. Prueba con:
   - Usuario: `admin`
   - Contraseña: `zebra2024`
4. Deberías entrar al chat

### **Test 2: Protección**

1. Abre: `http://tu-servidor/index.html`
2. Si no estás autenticado, deberías ser redirigido a `/login.html`

### **Test 3: Logout**

1. Dentro del chat, click en "Cerrar Sesión" (arriba a la derecha)
2. Deberías volver al login
3. Intenta acceder a `/index.html` de nuevo
4. Deberías ser redirigido al login

---

## 📁 ESTRUCTURA DE ARCHIVOS

```
chat-n8n-v4/
├── index.html           # Chat (protegido)
├── login.html          # Página de login
├── auth.php            # Script de autenticación
├── users.json          # Base de datos de usuarios ⭐
├── Logo_Zebra_Blanco.png
├── Dockerfile
└── README.md
```

---

## 🔒 SEGURIDAD

### **Nivel Actual: Básico**
- ✅ Login requerido
- ✅ Session storage
- ❌ Sin cifrado de contraseñas (están en texto plano)
- ❌ Sin HTTPS

### **Para Producción (Recomendado):**

1. **Usar HTTPS:**
   ```bash
   # Con Nginx + Certbot
   sudo certbot --nginx -d tu-dominio.com
   ```

2. **Cifrar contraseñas en users.json:**
   
   Modifica `auth.php` para usar password_hash():
   ```php
   // Generar hash (una vez):
   echo password_hash('tu_contraseña', PASSWORD_BCRYPT);
   
   // En auth.php, reemplaza:
   if ($user['username'] === $username && $user['password'] === $password)
   
   // Por:
   if ($user['username'] === $username && password_verify($password, $user['password']))
   ```

3. **Agregar rate limiting** para prevenir brute force

4. **Variables de entorno** para datos sensibles

---

## 🛠️ TROUBLESHOOTING

### **"403 Forbidden" al hacer login**
- Verifica permisos de `users.json`:
  ```bash
  chmod 644 users.json
  ```

### **Login no funciona después de cambiar contraseña**
- Asegúrate de reiniciar el contenedor:
  ```bash
  docker restart zebra-chat
  ```

### **"Cannot read users.json"**
- Verifica que el archivo existe en el contenedor:
  ```bash
  docker exec zebra-chat ls -la /var/www/html/users.json
  ```

### **Redirige a login aunque esté autenticado**
- Limpia el sessionStorage:
  - F12 → Application → Session Storage → Clear

---

## 💡 TIPS

1. **Usuario por defecto:**
   - Usuario: `admin`
   - Contraseña: `zebra2024`
   - **¡CÁMBIALA EN PRODUCCIÓN!**

2. **Múltiples usuarios:**
   - Puedes agregar tantos usuarios como quieras en `users.json`
   - No hay límite

3. **Nombres descriptivos:**
   - Usa el campo `"name"` para identificar usuarios fácilmente
   - Aparece en el header: "👤 Nombre Completo"

4. **Backup de usuarios:**
   ```bash
   cp users.json users.json.backup
   ```

---

## 🔄 MIGRACIÓN DESDE v3

Si ya tienes v3 corriendo:

1. **Detén v3:**
   ```bash
   docker stop zebra-chat
   docker rm zebra-chat
   ```

2. **Deploy v4:**
   ```bash
   docker build -t zebra-chat:v4 .
   docker run -d -p 80:80 --name zebra-chat zebra-chat:v4
   ```

3. **Tus datos de Redis y workflows se mantienen** (están en n8n, no en la app)

---

## 📞 SOPORTE

**Usuarios por defecto:**
- `admin` / `zebra2024`
- `usuario1` / `pass123`

**Recuerda cambiar las contraseñas en producción!** 🔐

---

**Versión:** 4.0 (Con Autenticación)  
**Última actualización:** Octubre 2025
