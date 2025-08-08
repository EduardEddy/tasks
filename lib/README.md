# Estructura del Proyecto

Este proyecto sigue la arquitectura limpia (Clean Architecture) con las siguientes características:

## Estructura de Carpetas

### `lib/core/`
- **errors/**: Manejo de errores de la aplicación
- **usecases/**: Casos de uso base
- **utils/**: Utilidades y constantes

### `lib/features/`
Cada feature sigue la arquitectura limpia con tres capas:

#### `tasks/` - Feature principal: Gestión de tareas
- **data/**: Implementación de datos
  - `datasources/`: Fuentes de datos (API, Base de datos)
  - `models/`: Modelos de datos (Freezed)
  - `repositories/`: Implementación de repositorios
- **domain/**: Lógica de negocio
  - `entities/`: Entidades del dominio
  - `repositories/`: Interfaces de repositorios
  - `usecases/`: Casos de uso
- **presentation/**: Capa de presentación
  - `providers/`: Providers de Riverpod
  - `screens/`: Pantallas
  - `widgets/`: Widgets reutilizables

#### `countries/` - Feature secundaria: Lista de países vía GraphQL
- Misma estructura que tasks pero para países

### Archivos principales
- `main.dart`: Punto de entrada de la aplicación
- `injection.dart`: Configuración de dependencias
- `router.dart`: Configuración de navegación

## Tecnologías utilizadas
- **Riverpod**: Gestión de estado
- **Freezed**: Generación de código inmutable
- **Go Router**: Navegación
- **GraphQL Flutter**: Para la feature de países
- **SQLite**: Base de datos local para tareas
- **Dio**: Cliente HTTP

## Comandos útiles
```bash
# Generar archivos de Freezed
flutter packages pub run build_runner build --delete-conflicting-outputs

# Ejecutar la aplicación
flutter run
``` 