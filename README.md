# Datos Abiertos de Colombia (Flutter)

App Flutter que consume **API Colombia** y muestra un **Dashboard**, un **Listado** y un **Detalle** navegando con `go_router`, con manejo de estados (cargando / exito / error) y separacion por capas.

- Sitio: https://api-colombia.com/
- Swagger: https://api-colombia.com/swagger/index.html
- URL base: `https://api-colombia.com/api/v1`

## API usada

API Colombia es una API REST publica, abierta y sin autenticacion con informacion general del pais. Limita algunos endpoints a 60 solicitudes por minuto por IP, por eso el servicio guarda los listados en memoria.

### Endpoints seleccionados (5)

| Endpoint (GET)                         | Uso en la app                  |
| -------------------------------------- | ------------------------------ |
| `/api/v1/Department`                   | Listado de departamentos       |
| `/api/v1/President`                    | Listado de presidentes         |
| `/api/v1/TouristicAttraction`          | Listado de atracciones         |
| `/api/v1/TypicalDish`                  | Listado de platos tipicos      |
| `/api/v1/Region`                       | Listado de regiones            |
| `/api/v1/{Endpoint}/{id}`              | Detalle de cualquiera de ellos |

### Ejemplo de respuesta JSON

`GET https://api-colombia.com/api/v1/Department` (recortado):

```json
[
  {
    "id": 2,
    "name": "Antioquia",
    "description": "...",
    "municipalities": 125,
    "surface": 63612,
    "population": 6900000,
    "phonePrefix": "4",
    "regionId": 5,
    "region": { "id": 5, "name": "Andina" }
  }
]
```

> Los campos exactos pueden variar; los modelos usan parseo tolerante (`models/json_utils.dart`) para campos nulos o numeros como texto.

## Arquitectura

```
lib/
  config/     env.dart                  // lee .env (URL base, timeout)
  models/     api_entity.dart           // contrato comun de los modelos
              department.dart, president.dart, touristic_attraction.dart,
              typical_dish.dart, region.dart   // fromJson / toJson
              api_endpoint.dart         // enum con path, slug, titulo, icono, parser
              json_utils.dart          // helpers de parseo
  routes/     app_router.dart           // go_router con rutas con nombre
  services/   colombia_service.dart     // GET con Dio + status codes + cache
              api_exception.dart        // errores controlados
  themes/     app_theme.dart            // tema Material 3 (colores de Colombia)
  views/      dashboard_view.dart       // Home con cards
              list_view.dart            // Listado (ListView.builder)
              detail_view.dart          // Detalle completo
  widgets/    endpoint_card, entity_list_tile, detail_row,
              network_thumb, state_views (loading / error / empty)
main.dart
```

Decisiones tecnicas:

- **Separacion de capas:** las vistas nunca hacen HTTP; llaman a `ColombiaService`, que devuelve modelos o lanza `ApiException`.
- **Un solo listado y un solo detalle genericos:** el enum `ApiEndpoint` define como parsear cada recurso, y cada modelo implementa `ApiEntity` para presentarse. Agregar un endpoint nuevo es agregar un modelo y un valor al enum.
- **Status codes:** `200` ok, `404` no encontrado, `429` demasiadas solicitudes, `5xx` error del servidor; ademas timeout y falta de conexion.
- **Estados:** `LoadStatus { loading, success, error }` en listado y detalle, con boton de reintento y pull-to-refresh.
- **Detalle:** hace `GET /{Endpoint}/{id}` a partir de los parametros de la ruta, asi tambien funciona con enlaces directos.

## Rutas (go_router)

| Nombre      | Path                                   | Parametros                                                          |
| ----------- | -------------------------------------- | ------------------------------------------------------------------- |
| `dashboard` | `/`                                    | -                                                                   |
| `list`      | `/list/:endpoint`                      | `endpoint`: slug (`department`, `president`, `touristic-attraction`, `typical-dish`, `region`) |
| `detail`    | `/list/:endpoint/detail/:id?name=...`  | `endpoint`, `id` (path), `name` (query, titulo para la AppBar)      |

Ejemplo de navegacion:

```dart
context.pushNamed(
  'detail',
  pathParameters: {'endpoint': 'department', 'id': '2'},
  queryParameters: {'name': 'Antioquia'},
);
// -> /list/department/detail/2?name=Antioquia
```

## Paquetes

- `dio`: consumo de la API (cliente HTTP con timeouts y manejo de errores tipado)
- `go_router`: navegacion
- `flutter_dotenv`: variables de entorno (`.env`)

## Como ejecutar

```bash
flutter create .          # genera android/ios/web si no existen
flutter pub get
flutter run
flutter test
```

Variables en `.env`:

```
API_BASE_URL=https://api-colombia.com/api/v1
REQUEST_TIMEOUT_SECONDS=15
```

## Capturas

### Dashboard, listado y detalle

| Dashboard | Listado | Detalle |
|---|---|---|
| ![Dashboard](https://raw.githubusercontent.com/zDaniMC/taller_datos_abiertos/feature/taller_api_colombia/docs/screenshots/dashboard.png) | ![Listado](https://raw.githubusercontent.com/zDaniMC/taller_datos_abiertos/feature/taller_api_colombia/docs/screenshots/listado.png) | ![Detalle](https://raw.githubusercontent.com/zDaniMC/taller_datos_abiertos/feature/taller_api_colombia/docs/screenshots/detalle.png) |

### Estados de la aplicación

| Cargando | Error |
|---|---|
| ![Cargando](https://raw.githubusercontent.com/zDaniMC/taller_datos_abiertos/feature/taller_api_colombia/docs/screenshots/cargando.png) | ![Error](https://raw.githubusercontent.com/zDaniMC/taller_datos_abiertos/feature/taller_api_colombia/docs/screenshots/error.png) |

## Flujo de trabajo (GitFlow)

- `main`: rama estable
- `dev`: rama de integracion
- `feature/taller_api_colombia`: desarrollo del taller (commits atomicos `feat:`, `docs:`, `chore:`)
- Pull Request `feature/taller_api_colombia` -> `dev`, luego merge de `dev` -> `main`
