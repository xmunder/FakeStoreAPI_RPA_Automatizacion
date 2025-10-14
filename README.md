# Automatización RPA - FakeStore API con PIX Robotics

## Descripción del Proyecto

Sistema de automatización RPA desarrollado en **PIX Studio** que integra múltiples servicios externos para realizar las siguientes operaciones:

1. **Consumo de API REST**: Obtiene productos desde FakeStore API
2. **Almacenamiento en BD**: Inserta productos en base de datos Supabase (PostgreSQL)
3. **Generación de Reportes**: Crea archivos Excel con métricas calculadas
4. **Almacenamiento en OneDrive**: Sube reportes usando Microsoft Graph API
5. **Envío de Formulario Web**: Completa automáticamente un formulario JotForm con los datos generados

El robot implementa el patrón **Universal** con gestión de transacciones, logs detallados y manejo robusto de excepciones.

---

## Estructura del Proyecto

```
PruebaTecnicaPIXRobotics2025/
│
├── Main.pix                          # Proceso principal (Patrón Universal)
├── ProcessTransactionItem.pix        # Procesamiento de transacciones
├── Data/
│   ├── Config.xlsx                   # Archivo de configuración
│   ├── Input/                        # Archivos de entrada
│   ├── Output/                       # Archivos de salida
│   └── Temp/                         # Archivos temporales
│
├── Framework/
│   ├── ReadConfig.pix                # Lectura de configuración
│   ├── InitApplications.pix          # Inicialización de aplicaciones web
│   ├── GetTransactionItem.pix        # Obtención de transacciones
│   ├── SetTransactionStatus.pix      # Actualización de estado
│   ├── CloseApplications.pix         # Cierre de aplicaciones
│   ├── KillApplications.pix          # Finalización forzada
│   ├── TakeScreenshot.pix            # Captura de pantallas
│   │
│   └── TransactionProcess/
│       ├── FetchAndUploadProducts.pix     # Consulta FakeStore API
│       ├── StoreProductsInDatabase.pix    # Inserción en Supabase
│       ├── CreateAndUploadReport.pix      # Generación y carga Excel
│       └── UploadReportToForm.pix         # Envío a Google Forms
│
├── Reportes/                         # Reportes Excel generados
├── Evidencias/                       # Capturas de pantalla (éxito)
└── Exceptions_Screenshots/           # Capturas de errores
```

---

## Variables de Configuración

El archivo `Data/Config.xlsx` contiene dos hojas: **Settings** y **Constants**. A continuación se detallan todas las variables de configuración:

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Valor</th>
      <th>Descripción</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>FakeStoreAPIEndpoint</code></td>
      <td>https://fakestoreapi.com/products</td>
      <td>Endpoint base de la API pública FakeStore para obtener productos</td>
    </tr>
    <tr>
      <td><code>OneDriveAPIEndpoint</code></td>
      <td>https://graph.microsoft.com/v1.0/me/drive/root:</td>
      <td>URL base del servicio de Microsoft Graph para interactuar con OneDrive</td>
    </tr>
    <tr>
      <td><code>OneDriveAPPClientID</code></td>
      <td>947259e8...</td>
      <td>Identificador único de la aplicación registrada en Azure AD con permisos para OneDrive</td>
    </tr>
    <tr>
      <td><code>OneDriveAPPRefreshToken</code></td>
      <td>M.C542_BAY.0.U.-CtNw...</td>
      <td>Token de actualización que permite obtener nuevos tokens de acceso sin reautenticación</td>
    </tr>
    <tr>
      <td><code>OneDriveAPPClientSecret</code></td>
      <td>wgv8Q~kAQ4upMt2YkH...</td>
      <td>Clave secreta generada en Azure para autenticar el acceso al API de OneDrive</td>
    </tr>
    <tr>
      <td><code>JSONOneDrivePath</code></td>
      <td>\RPA\Logs</td>
      <td>Ruta en OneDrive donde se almacenan los archivos JSON generados</td>
    </tr>
    <tr>
      <td><code>ExcelReportOneDrivePath</code></td>
      <td>\RPA\Reportes</td>
      <td>Ruta en OneDrive donde se guardan los reportes Excel generados</td>
    </tr>
    <tr>
      <td><code>TempFolder</code></td>
      <td>\Data\Temp</td>
      <td>Carpeta temporal para archivos intermedios durante la ejecución</td>
    </tr>
    <tr>
      <td><code>EvidencesFolder</code></td>
      <td>\Evidencias</td>
      <td>Carpeta donde se guardan capturas de pantalla de evidencias</td>
    </tr>
    <tr>
      <td><code>ReportsFolder</code></td>
      <td>\Reportes</td>
      <td>Carpeta local donde se generan los reportes finales</td>
    </tr>
    <tr>
      <td><code>WebFormURL</code></td>
      <td>https://form.jotform.com/252846236496064</td>
      <td>URL del formulario JotForm donde el robot sube el reporte</td>
    </tr>
    <tr>
      <td><code>SupabaseURL</code></td>
      <td>https://akpmuamlqktaueaxuegh.supabase.co</td>
      <td>URL base del proyecto Supabase con la base de datos PostgreSQL</td>
    </tr>
    <tr>
      <td><code>SupabaseAnonKey</code></td>
      <td>eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...</td>
      <td>Clave de autenticación (Service Role) para acceder a Supabase</td>
    </tr>
    <tr>
      <td><code>SupabaseTable</code></td>
      <td>productos</td>
      <td>Nombre de la tabla en Supabase donde se insertan los productos</td>
    </tr>
    <tr>
      <td><code>InterestAPIProductsKeys</code></td>
      <td>id, title, price, category, description</td>
      <td>Lista de campos relevantes extraídos desde la API de productos</td>
    </tr>
    <tr>
      <td><code>FormComments</code></td>
      <td>(vacío)</td>
      <td>Variable para comentarios adicionales en el formulario</td>
    </tr>
    <tr>
      <td><code>MaxRetryNumber</code></td>
      <td>3</td>
      <td>Número máximo de intentos para reintentar acciones fallidas</td>
    </tr>
    <tr>
      <td><code>ExScreenshotsDirectoryPath</code></td>
      <td>Exceptions_Screenshots</td>
      <td>Carpeta para capturas de pantalla tomadas durante excepciones</td>
    </tr>
    <tr>
      <td><code>ShouldStopMasterAssetName</code></td>
      <td>DummyShouldStopMasterAssetName</td>
      <td>Asset para controlar la detención del proceso maestro</td>
    </tr>
    <tr>
      <td><code>ScreenShotConfirmationFileName</code></td>
      <td>formulario_confirmacion.png</td>
      <td>Nombre del archivo de captura que confirma ejecución exitosa</td>
    </tr>
    <tr>
      <td><code>ScreenShotExceptionFileName</code></td>
      <td>formulario_excepcion.png</td>
      <td>Nombre del archivo de captura asociada a errores o excepciones</td>
    </tr>
    <tr>
      <td><code>CollaboratorName</code></td>
      <td>Robot RPA</td>
      <td>Nombre con el que se identifica el robot en registros y reportes</td>
    </tr>
    <tr>
      <td><code>JSONFileName</code></td>
      <td>Productos_</td>
      <td>Prefijo usado para nombrar los archivos JSON generados</td>
    </tr>
    <tr>
      <td><code>ExcelReportFileName</code></td>
      <td>Reporte_</td>
      <td>Prefijo para los reportes Excel generados automáticamente</td>
    </tr>
  </tbody>
</table>

---

## Servicios y APIs Utilizados

### 1. **FakeStore API**
- **Propósito**: Obtención de productos de ejemplo
- **Endpoint**: `https://fakestoreapi.com/products`
- **Método**: GET
- **Respuesta**: JSON con array de productos (id, title, price, category, description)

### 2. **Supabase (PostgreSQL)**
- **Propósito**: Almacenamiento persistente de productos
- **Tecnología**: REST API sobre PostgreSQL
- **Autenticación**: API Key (anon/public)
- **Operaciones**:
  - Verificación de duplicados por ID
  - Inserción de nuevos registros con timestamp
- **Estructura de tabla** (`productos`):
  - `id` - INTEGER PRIMARY KEY (autoincremental)
  - `fecha_creacion` - TIMESTAMP (valor por defecto: NOW())
  - `description` - TEXT
  - `title` - TEXT
  - `category` - TEXT
  - `price` - NUMERIC

**Script SQL para crear la tabla**:
```sql
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    fecha_creacion TIMESTAMP DEFAULT NOW(),
    description TEXT,
    title TEXT,
    category TEXT,
    price NUMERIC
);
```

### 3. **Microsoft Graph API (OneDrive)**
- **Propósito**: Almacenamiento de reportes Excel en la nube
- **Autenticación**: OAuth 2.0 con Refresh Token
- **Endpoints utilizados**:
  - `/me/drive/root:/{path}` - Verificación de carpetas
  - `/me/drive/root/children` - Creación de carpetas
  - `/me/drive/root:/{path}/{file}:/content` - Carga de archivos
- **Funcionalidades**:
  - Creación recursiva de estructura de carpetas
  - Renovación automática de Access Token
  - Soporte MIME para archivos .xlsx y .json

### 4. **JotForm**
- **Propósito**: Reegistro del reporte Excel generado en formulario web
- **Método**: Automatización web con actividades de PIX Studio - JavaScript Injection
- **Campos completados**:
  - Nombre del colaborador
  - Fecha de ejecución - formato dd/MM/yyyy
  - Comentarios adicionales (opcional)
  - Archivo adjunto (reporte Excel generado)
- **Técnicas implementadas**:
  - JavaScript Injection para mayor confiabilidad
  - Mecanismos Try/Fix para elementos dinámicos
  - Scroll automático y eventos DOM
  - Manejo de diálogos de Windows para carga de archivos

---

## Pasos para Ejecución

### Requisitos Previos

1. **PIX Robotics Studio** (v2.27.4 o superior)
2. **Google Chrome** instalado
3. **Conexión a Internet** estable
4. **Credenciales configuradas** en `Data/Config.xlsx`:
   - Supabase: URL + API Key + nombre de tabla
   - Azure AD: Client ID + Secret + Refresh Token
   - JotForm: URL del formulario

### Configuración Inicial

1. **Clonar o descargar** el proyecto
2. **Abrir** `PruebaTecnicaPIXRobotics2025.pixproj` en PIX Studio
3. **Editar** `Data/Config.xlsx` con tus credenciales:
   ```
   - Supabase → Crear proyecto y tabla 'productos'
   - Azure AD → Registrar aplicación con permisos Files.ReadWrite
   - JotForm → Crear formulario con campos requeridos
   ```
4. **Crear cola** en PIX Orchestrator:
   - Nombre: Igual al valor de `QueueName` en Config.xlsx
   - Agregar al menos 1 ítem de transacción

### Ejecución

1. **Ejecutar** el archivo `Main.pix`
2. El robot seguirá este flujo:
   ```
   Init → Get → Process → End
   ```
3. **Monitorear** logs en la consola de PIX Studio
4. **Revisar** resultados:
   - Reportes: Carpeta `Reportes/`
   - Evidencias: Carpeta `Evidencias/`
   - Errores: Carpeta `Exceptions_Screenshots/`
   - OneDrive: Verificar carga exitosa
   - JotForm: Verificar respuesta registrada

### Ejecución por Componentes (Opcional)

Para pruebas individuales:
- **Solo API FakeStore**: `Framework/TransactionProcess/FetchAndUploadProducts.pix`
- **Solo Supabase**: `Framework/TransactionProcess/StoreProductsInDatabase.pix`
- **Solo Excel + OneDrive**: `Framework/TransactionProcess/CreateAndUploadReport.pix`
- **Solo Formulario**: `Framework/TransactionProcess/UploadReportToForm.pix`

---

## Requisitos y Dependencias

### Software
- **PIX Robotics Studio** 2.27.4+
- **Google Chrome** (última versión)
- **.NET Framework** 4.7.2+ (incluido en PIX)
- **Sistema Operativo**: Windows 10/11

### Librerías y Paquetes
El proyecto utiliza las siguientes librerías .NET (incluidas en PIX):
- `System.Net.Http` - Consumo de APIs REST
- `System.Data` - Manipulación de DataTables
- `System.Text.Json` - Procesamiento JSON
- `System.IO` - Operaciones de archivos
- `DocumentFormat.OpenXml` - Generación de Excel

### Servicios Externos (Gratuitos)
- **FakeStore API**: Sin autenticación, uso libre
- **Supabase**: Plan gratuito (500 MB, 50,000 req/mes)
- **Microsoft Graph**: Cuenta personal OneDrive (15 GB gratis)
- **JotForm**: Plan gratuito (5 formularios, 100 respuestas/mes)

### Permisos Requeridos
- **Azure AD App**: `Files.ReadWrite`, `Files.ReadWrite.All`, `offline_access`, `User.Read` (OneDrive)
- **Supabase**: Permisos RLS desactivados y configurados para tabla `productos`

---

## Enlace del Formulario

**URL del formulario JotForm utilizado**:  
🔗 [Formulario RPA - FakeStore API Automation](https://form.jotform.com/252846236496064)

El formulario JotForm también está configurado en el archivo `Data/Config.xlsx` bajo la variable `WebFormURL`.

**Estructura del formulario**:
- **Campo 1**: Nombre del colaborador - Texto corto
- **Campo 2**: Fecha de ejecución - Formato dd/MM/yyyy
- **Campo 3**: Comentarios adicionales (opcional) - Texto largo
- **Campo 4**: Archivo adjunto - Carga de archivo Excel (.xlsx)

---

## Características Técnicas

- ✅ **Patrón Universal** completo con manejo de estados
- ✅ **Logs detallados** en cada paso del proceso
- ✅ **Gestión de errores** con capturas automáticas
- ✅ **Reintentos automáticos** en operaciones críticas
- ✅ **Validación de duplicados** en Supabase
- ✅ **Renovación de tokens** OAuth 2.0
- ✅ **Creación dinámica** de carpetas en OneDrive
- ✅ **Cálculo de métricas** (promedios, totales por categoría)
- ✅ **Automatización web robusta** con JavaScript injection

---

## Autor

**Cristian Camilo Gómez Fernández**   
Fecha: Octubre 2025

---

## Notas Adicionales

- Los reportes Excel incluyen métricas calculadas: total de productos, precio promedio general, precio promedio por categoría
- El sistema evita duplicados en Supabase verificando por ID antes de insertar
- La estructura de carpetas en OneDrive se crea automáticamente si no existe
- El formulario web se completa usando las actividades de PixStudio junto con la inyección de JavaScript para máxima compatibilidad
- Todos los errores generan capturas de pantalla automáticas con timestamp
