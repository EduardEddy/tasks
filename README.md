## Tasks

Aplicación Flutter de ejemplo para gestionar tareas y consultar países. Incluye:

- Gestión de tareas con persistencia local (SQLite con `sqflite`) y consumo remoto (REST con `dio`).
- Listado de países consumiendo una API GraphQL (`graphql_flutter`).
- Estado global con `flutter_riverpod` y navegación con `go_router`.
- Modelos inmutables y serialización con `freezed` y `json_serializable`.

### Tecnologías principales
- Flutter, Dart 3.5+
- Riverpod (`flutter_riverpod`)
- GoRouter (`go_router`)
- Freezed (`freezed`, `freezed_annotation`) + `build_runner` + `json_serializable`
- REST (`dio`) y GraphQL (`graphql_flutter`)
- SQLite (`sqflite`) y `path_provider`

## Requisitos previos
- Flutter instalado (canal estable)
- Dart >= 3.5.0
- Android SDK y/o Xcode (según plataforma objetivo)

Verifica tu entorno:
```
flutter --version
dart --version
```

## Instalación
```
git clone git@github.com:EduardEddy/tasks.git
cd tasks
flutter pub get
```

## Ejecución
```
flutter run
```

Plataformas específicas:
- Android: un emulador o dispositivo conectado
- iOS: requiere Xcode y un simulador/dispositivo
- Web/desktop: según soporte de tu SDK de Flutter

## Generación de código (Freezed / JSON)
Genera o regenera modelos y código auxiliar:
```
dart run build_runner build --delete-conflicting-outputs
```

Modo observador (opcional):
```
dart run build_runner watch --delete-conflicting-outputs
```

## Estructura del proyecto (resumen)
- `lib/core/`
  - `utils/constants.dart`: URLs de APIs y configuración base (REST y GraphQL), nombre de BD.
- `lib/features/tasks/`
  - `data/`: datasources (local/remote) y repositorio (`TaskRepositoryImpl`).
  - `domain/`: entidades, contratos de repositorio y casos de uso.
  - `presentation/`: providers (Riverpod) y pantallas (`TasksScreen`, `NewTaskScreen`, `EditTaskScreen`).
- `lib/features/countries/`
  - `data/`: datasource GraphQL y modelos.
  - `domain/`: entidades, repositorio y caso de uso `GetCountriesUseCase`.
  - `presentation/`: providers y pantalla `CountriesScreen`.
- `lib/router.dart`: configuración de rutas con `go_router`.
- `lib/main.dart`: punto de entrada. Inicializa dependencias e Hive para GraphQL.


## Navegación (rutas)
- `/tasks`: pantalla principal de tareas.
- `/countries`: listado de países (GraphQL).
- `/new-task`: creación de tarea local.
- `/edit-task`: edición de tarea (recibe un `Task` vía `state.extra`).

## Configuración
Edita `lib/core/utils/constants.dart` para ajustar endpoints y base de datos:

```dart
class AppConstants {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String baseUrlGraphql = 'https://countries.trevorblades.com/';
  static const String databaseName = 'tasks.db';
}
```

- REST (tareas): `GET {baseUrl}/todos`.
- GraphQL (países): se inicializa un `GraphQLClient` con `HttpLink(baseUrlGraphql)`.
- Base de datos local: `tasks.db` vía `sqflite`.

## Comandos útiles
- Analizar código:
```
flutter analyze
```

- Formatear código:
```
dart format .
```

- Ejecutar tests:
```
flutter test
```

## Problemas comunes
- Conflictos con `build_runner`: usa la bandera `--delete-conflicting-outputs` o detén procesos `watch` previos.
- Errores de `GraphQLCache`/Hive: asegúrate de que `initHiveForFlutter()` se ejecute antes de usar `GraphQLClient` (ya se hace en `main.dart`).

## Licencia
Este proyecto es solo para fines educativos/demostrativos.
