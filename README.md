# QuizFusion

![QuizFusion Logo](https://via.placeholder.com/150?text=QuizFusion)

QuizFusion es una aplicación fullstack para la gestión de preguntas interactivas en tiempo real. Desarrollada como parte del curso de Programación Web, combina tecnologías modernas para ofrecer una experiencia ágil y dinámica en un entorno completamente basado en IHP.

## 👨‍💻 Autor
* **Michael Asencio Quintana**

## 📘 Información académica
* **Materia:** Programación Web
* **Gestión:** 2025

## 💻 Stack tecnológico
* **Frontend:** IHP (Framework Haskell para desarrollo web fullstack)
* **Backend:** IHP
* **Base de datos:** PostgreSQL
* **Lenguaje de programación:** Haskell

## 🌟 ¿Por qué IHP?
IHP es un moderno framework web en Haskell que permite un desarrollo rápido y tipo seguro, con características como:
- Generación automática de código
- Hot reloading
- Sistema de consultas tipo seguro
- Vistas con sintaxis HSX (similar a JSX)
- Sistema integrado de autenticación
- Migraciones automáticas de base de datos

## 📁 Estructura del Proyecto

```
quizfusion/
├── Application/
│   ├── Helper/
│   └── Schema.sql
├── Config/
├── Controller/
├── Model/
├── View/
├── Web/
│   ├── Controller/
│   ├── View/
│   ├── Routes.hs
│   └── Types.hs
├── .gitignore
├── package.json
├── default.nix
└── README.md
```

## 🚀 Características principales
* Creación y gestión de cuestionarios interactivos
* Participación en tiempo real mediante websockets
* Análisis de resultados y estadísticas
* Interfaz intuitiva con diseño responsive
* Autenticación y autorización de usuarios
* Persistencia de datos en PostgreSQL

## 🚧 Estado del proyecto
🔧 En desarrollo – funcionalidades básicas en construcción.

## 📋 Requisitos previos
* [Nix](https://nixos.org/download.html) (gestor de paquetes)
* [IHP](https://ihp.digitallyinduced.com/Guide/installation.html)
* PostgreSQL (versión 13 o superior)
* [Haskell Stack](https://docs.haskellstack.org/en/stable/install_and_upgrade/)

## ⚙️ Configuración del entorno

### Instalación

1. Clona el repositorio:
   ```bash
   git clone https://github.com/usuario/quizfusion.git
   cd quizfusion
   ```

2. Configuración del proyecto IHP:
   ```bash
   ./start
   ```
   Este comando iniciará el servidor de desarrollo, configurará la base de datos y abrirá la aplicación en tu navegador predeterminado.

### Configuración de la base de datos

IHP creará automáticamente la base de datos PostgreSQL según el esquema definido en `Application/Schema.sql`. Para acceder directamente a la base de datos:

```bash
make psql
```

## 🌿 Flujo de trabajo Git

### Ramas principales
* `main`: Código en producción estable. NO se permite pushear directamente a esta rama.
* `develop`: Rama de desarrollo integrado. Todo el desarrollo se fusiona aquí antes de pasar a producción.

### Ramas de trabajo
* `feature/nombre-caracteristica`: Para nuevas características o mejoras.
* `bugfix/nombre-error`: Para corrección de errores.
* `hotfix/nombre-urgencia`: Para correcciones urgentes que van directamente a producción.
* `release/v1.x.x`: Para preparar una nueva versión para producción.

### Convenciones de commits
Todos los commits deben seguir el formato:

```
tipo(alcance): breve descripción

Descripción más detallada si es necesaria
```

Donde `tipo` puede ser:
- `feat`: Nueva característica
- `fix`: Corrección de error
- `docs`: Cambios en la documentación
- `style`: Cambios de formato (indentación, etc.)
- `refactor`: Refactorización de código
- `test`: Añadir o modificar pruebas
- `chore`: Tareas de mantenimiento

### Reglas de contribución
1. **No pushear directamente a `main` o `develop`.**
2. Crear una rama específica desde `develop` para cada tarea.
3. Los commits deben seguir la convención establecida.
4. Mantener las ramas actualizadas con `develop` mediante rebase.
5. Todo merge a `develop` o `main` requiere una revisión de código.
6. Asegurarse de que el código pasa todas las pruebas antes de solicitar un merge.

## 🤝 ¿Cómo contribuir?
1. Clona el repositorio.
2. Crea una rama desde `develop` con el formato adecuado.
3. Realiza tus cambios siguiendo las convenciones de código.
4. Ejecuta las pruebas localmente.
5. Sube tus cambios y crea un Pull Request hacia `develop`.
6. Espera la revisión y aprobación.

## 📚 Recursos de aprendizaje
- [Documentación oficial de IHP](https://ihp.digitallyinduced.com/Guide/)
- [Aprende Haskell](https://learnyouahaskell.com/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 🐛 Reporte de errores
Si encuentras algún error, por favor reportalo creando un issue en este repositorio con la siguiente información:
- Breve descripción del problema
- Pasos para reproducir el error
- Comportamiento esperado
- Comportamiento actual
- Capturas de pantalla (si aplica)

## 📄 Licencia
Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

---

⭐️ Si te gusta este proyecto, ¡no dudes en darle una estrella!
