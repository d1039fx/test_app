Estructura del Proyecto Flutter - Organización por Funcionalidad
Este documento define la organización de carpetas y archivos para el proyecto, siguiendo un enfoque de "Organización por Funcionalidad" (Feature-First) combinado con Arquitectura Limpia.

Filosofía Principal
En lugar de agrupar los archivos por su tipo a nivel raíz (ej: screens/, models/), los agrupamos por la funcionalidad a la que pertenecen. Cada funcionalidad es un módulo autocontenido dentro de la aplicación.

Estructura de Carpetas
lib/
├── features/                  <-- Contiene todas las funcionalidades de la app.
│   │
│   └── user_creation/         <-- Módulo para la funcionalidad "Creación de Usuario".
│       │
│       ├── data/              <-- Implementación de la obtención de datos.
│       │   ├── datasources/   (Fuentes de datos: API, DB local)
│       │   ├── models/        (Modelos de datos específicos de la fuente)
│       │   └── repositories/  (Implementación del repositorio del dominio)
│       │
│       ├── domain/            <-- El núcleo de la funcionalidad (lógica de negocio).
│       │   ├── entities/      (Objetos de negocio puros)
│       │   ├── repositories/  (Contratos/Interfaces para los repositorios)
│       │   └── usecases/      (Casos de uso específicos)
│       │
│       └── presentation/      <-- La capa de UI.
│           ├── bloc/          (Business Logic Components para la gestión de estado)
│           ├── screens/       (Las pantallas de esta funcionalidad)
│           └── widgets/       (Widgets reutilizables para esta funcionalidad)
│
│   └── login/                 <-- Otra funcionalidad (ejemplo)
│   └── home/                  <-- Otra funcionalidad (ejemplo)
│
├── core/                      <-- Código compartido por múltiples funcionalidades.
│   ├── error/                 (Manejo de errores comunes, excepciones)
│   ├── network/               (Cliente HTTP, etc.)
│   └── widgets/               (Widgets globales y reutilizables en toda la app)
│
└── main.dart                  <-- Punto de entrada de la aplicación.
└── injection_container.dart   <-- Configuración de Inyección de Dependencias.