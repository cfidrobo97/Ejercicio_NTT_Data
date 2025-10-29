# Manual de Uso - API DevOps Service

## 📋 Descripción General

Este API REST procesa mensajes con autenticación mediante API Key y requiere un **JWT único por cada transacción**.

## 🔑 Requisitos de Autenticación

### 1. API Key (Fija)
- **Header:** `X-Parse-REST-API-Key`
- **Valor:** `2f5ae96c-b558-4c7b-a590-a501ae1c3f6c`
- **Descripción:** Clave de autenticación fija para acceso al servicio

### 2. JWT Único por Transacción
- **Header:** `X-JWT-KWY`
- **Valor:** **DEBE SER ÚNICO para cada petición**
- **Descripción:** Identificador único de transacción para prevenir replay attacks

---

## 🚀 Endpoint

### POST /DevOps

**Descripción:** Envía un mensaje con destinatario y tiempo de vida.

**URL:** `http://[tu-dominio]:8080/DevOps`

---

## 📤 Request

### Headers Requeridos

```http
Content-Type: application/json
X-Parse-REST-API-Key: 2f5ae96c-b558-4c7b-a590-a501ae1c3f6c
X-JWT-KWY: [JWT-ÚNICO-POR-TRANSACCIÓN]
```

### Body (JSON)

```json
{
  "message": "This is a test",
  "to": "Juan Perez",
  "from": "Rita Asturia",
  "timeToLifeSec": 45
}
```

**Campos obligatorios:**
- `message` (String): El mensaje a enviar
- `to` (String): Destinatario del mensaje
- `from` (String): Remitente del mensaje
- `timeToLifeSec` (Integer): Tiempo de vida del mensaje en segundos

---

## 📥 Response

### Respuesta Exitosa (200 OK)

**Headers:**
```http
X-JWT-KWY: [JWT-GENERADO-POR-SERVIDOR]
```

**Body:**
```json
{
  "message": "Hello Juan Perez your message will be sent"
}
```

### Errores Comunes

#### 400 Bad Request - JWT Reutilizado
```json
{
  "error": "JWT reutilizado. Cada transacción requiere un JWT único."
}
```
**Causa:** Intentaste usar el mismo JWT que en una petición anterior.

#### 400 Bad Request - Campos Faltantes
```json
{
  "error": "Payload inválido"
}
```
**Causa:** Faltan uno o más campos obligatorios en el body.

#### 400 Bad Request - JWT Faltante
**Causa:** No incluiste el header `X-JWT-KWY`.

#### 401 Unauthorized
**Causa:** API Key inválida o faltante.

#### 405 Method Not Allowed
```
ERROR
```
**Causa:** Intentaste usar un método HTTP diferente a POST (GET, PUT, DELETE, etc.).

---

## 💻 Ejemplos de Uso

### PowerShell

```powershell
# Generar JWT único para esta transacción
$uniqueJwt = [guid]::NewGuid().ToString()

# Realizar petición
$response = Invoke-RestMethod `
  -Method POST `
  -Uri "http://[tu-dominio]:8080/DevOps" `
  -Headers @{
    "X-Parse-REST-API-Key" = "2f5ae96c-b558-4c7b-a590-a501ae1c3f6c"
    "X-JWT-KWY"            = $uniqueJwt
    "Content-Type"         = "application/json"
  } `
  -Body '{"message":"This is a test","to":"Juan Perez","from":"Rita Asturia","timeToLifeSec":45}'

# Mostrar respuesta
Write-Host "Respuesta: $($response.message)"
Write-Host "JWT Respuesta: $($response.Headers.'X-JWT-KWY')"
```

### cURL (Linux/Mac)

```bash
# Generar JWT único
UNIQUE_JWT=$(uuidgen)

# Realizar petición
curl -X POST http://[tu-dominio]:8080/DevOps \
  -H "Content-Type: application/json" \
  -H "X-Parse-REST-API-Key: 2f5ae96c-b558-4c7b-a590-a501ae1c3f6c" \
  -H "X-JWT-KWY: $UNIQUE_JWT" \
  -d '{
    "message": "This is a test",
    "to": "Juan Perez",
    "from": "Rita Asturia",
    "timeToLifeSec": 45
  }'
```

### Python

```python
import requests
import uuid

# Generar JWT único
unique_jwt = str(uuid.uuid4())

# Headers
headers = {
    'Content-Type': 'application/json',
    'X-Parse-REST-API-Key': '2f5ae96c-b558-4c7b-a590-a501ae1c3f6c',
    'X-JWT-KWY': unique_jwt
}

# Body
payload = {
    'message': 'This is a test',
    'to': 'Juan Perez',
    'from': 'Rita Asturia',
    'timeToLifeSec': 45
}

# Realizar petición
response = requests.post(
    'http://[tu-dominio]:8080/DevOps',
    headers=headers,
    json=payload
)

# Mostrar respuesta
print(f"Status: {response.status_code}")
print(f"Respuesta: {response.json()}")
print(f"JWT Respuesta: {response.headers.get('X-JWT-KWY')}")
```

### JavaScript (Node.js)

```javascript
const axios = require('axios');
const { v4: uuidv4 } = require('uuid');

// Generar JWT único
const uniqueJwt = uuidv4();

// Realizar petición
axios.post('http://[tu-dominio]:8080/DevOps', {
  message: 'This is a test',
  to: 'Juan Perez',
  from: 'Rita Asturia',
  timeToLifeSec: 45
}, {
  headers: {
    'Content-Type': 'application/json',
    'X-Parse-REST-API-Key': '2f5ae96c-b558-4c7b-a590-a501ae1c3f6c',
    'X-JWT-KWY': uniqueJwt
  }
})
.then(response => {
  console.log('Status:', response.status);
  console.log('Respuesta:', response.data);
  console.log('JWT Respuesta:', response.headers['x-jwt-kwy']);
})
.catch(error => {
  console.error('Error:', error.response?.data || error.message);
});
```

---

## ⚠️ Importante: JWT Único por Transacción

### ✅ Correcto

```powershell
# Petición 1
$jwt1 = [guid]::NewGuid().ToString()  # Genera: "abc123-..."
Invoke-RestMethod ... -Headers @{ "X-JWT-KWY" = $jwt1 }

# Petición 2
$jwt2 = [guid]::NewGuid().ToString()  # Genera: "def456-..." (DIFERENTE)
Invoke-RestMethod ... -Headers @{ "X-JWT-KWY" = $jwt2 }
```

### ❌ Incorrecto

```powershell
# Petición 1
$jwt = "fixed-jwt-12345"
Invoke-RestMethod ... -Headers @{ "X-JWT-KWY" = $jwt }

# Petición 2 - REUTILIZA EL MISMO JWT
Invoke-RestMethod ... -Headers @{ "X-JWT-KWY" = $jwt }  # ❌ ERROR
```

---

## 🔄 Múltiples Peticiones en Loop

```powershell
# Ejemplo: Enviar 5 mensajes con JWT único cada uno
for ($i = 1; $i -le 5; $i++) {
    # Generar JWT único para ESTA iteración
    $uniqueJwt = [guid]::NewGuid().ToString()
    
    Write-Host "📤 Enviando petición $i con JWT: $uniqueJwt"
    
    $body = @{
        message = "Test message $i"
        to = "User $i"
        from = "System"
        timeToLifeSec = 45
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod `
            -Method POST `
            -Uri "http://[tu-dominio]:8080/DevOps" `
            -Headers @{
                "X-Parse-REST-API-Key" = "2f5ae96c-b558-4c7b-a590-a501ae1c3f6c"
                "X-JWT-KWY" = $uniqueJwt
                "Content-Type" = "application/json"
            } `
            -Body $body
        
        Write-Host "✅ Respuesta $i`: $($response.message)" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Error en petición $i`: $_" -ForegroundColor Red
    }
    
    Start-Sleep -Milliseconds 500
}
```

---

## 🔒 Seguridad

### Por qué JWT único por transacción:

1. **Previene Replay Attacks:** Si un atacante intercepta tu petición, no puede reutilizar el JWT
2. **Rastreabilidad:** Cada transacción es identificable de manera única
3. **Auditoría:** Facilita el seguimiento de peticiones en logs

### Generación de JWT Único:

El JWT puede ser cualquier valor único. Recomendamos usar:
- **UUID/GUID:** Garantiza unicidad globalmente
- **Timestamp + Random:** Combinación de timestamp y valor aleatorio
- **Hash Único:** SHA256 de timestamp + datos de la petición

**Ejemplo de generación:**

```powershell
# Opción 1: GUID (Recomendado)
$jwt = [guid]::NewGuid().ToString()

# Opción 2: Timestamp + Random
$jwt = "$(Get-Date -Format 'yyyyMMddHHmmssfff')-$(Get-Random)"

# Opción 3: Hash
$data = "$(Get-Date)-$([guid]::NewGuid())"
$jwt = [Convert]::ToBase64String(
    [System.Security.Cryptography.SHA256]::Create().ComputeHash(
        [System.Text.Encoding]::UTF8.GetBytes($data)
    )
)
```

---

## 📞 Soporte

Para preguntas o problemas, contactar al equipo de DevOps.

---

## 📝 Notas de Versión

- **v1.0.0** - Implementación inicial con validación de JWT único por transacción

