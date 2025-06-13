# QuizFusion


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
* Creación y gestión de cuestionarios interactivos en base a imagenes y puzztle
* Se puede jugar mediante comandos de programacion interactivos
* Análisis de resultados y guarda las preguntas en la base de datos
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

### Para Windows

* **Nix Package Manager**:
  * Instala WSL2 (Windows Subsystem for Linux) siguiendo [la guía oficial de Microsoft](https://learn.microsoft.com/es-es/windows/wsl/install)
  * Una vez instalado WSL2, abre una terminal de Linux y ejecuta:
    ```bash
    sh <(curl -L https://nixos.org/nix/install) --daemon
    ```

* **PostgreSQL**:
  * Descarga el instalador desde [la página oficial de PostgreSQL](https://www.postgresql.org/download/windows/)
  * Instala la versión 13 o superior
  * Asegúrate de anotar la contraseña del usuario postgres durante la instalación

* **Haskell Stack**:
  * Descarga el instalador desde [la página oficial de Haskell Stack](https://docs.haskellstack.org/en/stable/install_and_upgrade/#windows)
  * Sigue las instrucciones de instalación

* **IHP Framework**:
  * En WSL2, ejecuta:
    ```bash
    nix-env -if https://ihp.digitallyinduced.com/ihp-new.tar.gz
    ```

### Para macOS

* **Nix Package Manager**:
  * Abre Terminal y ejecuta:
    ```bash
    sh <(curl -L https://nixos.org/nix/install)
    ```
  * Cierra y vuelve a abrir Terminal después de la instalación

* **PostgreSQL**:
  * Usando Homebrew (instálalo primero desde [brew.sh](https://brew.sh/)):
    ```bash
    brew install postgresql@13
    brew services start postgresql@13
    ```

* **Haskell Stack**:
  * Usando Homebrew:
    ```bash
    brew install haskell-stack
    ```

* **IHP Framework**:
  * Ejecuta:
    ```bash
    nix-env -if https://ihp.digitallyinduced.com/ihp-new.tar.gz
    ```

### Para Linux (Ubuntu/Debian)

* **Nix Package Manager**:
  * Ejecuta:
    ```bash
    sh <(curl -L https://nixos.org/nix/install) --daemon
    ```

* **PostgreSQL**:
  * Instala PostgreSQL:
    ```bash
    sudo apt update
    sudo apt install postgresql postgresql-contrib
    sudo systemctl enable postgresql
    sudo systemctl start postgresql
    ```

* **Haskell Stack**:
  * Ejecuta:
    ```bash
    curl -sSL https://get.haskellstack.org/ | sh
    ```

* **IHP Framework**:
  * Ejecuta:
    ```bash
    nix-env -if https://ihp.digitallyinduced.com/ihp-new.tar.gz

    
## ⚙️ Configuración del entorno

### Instalación

1. Clona el repositorio:
   ```bash
   git clone https://github.com/usuario/quizfusion.git
   cd quizfusion
   ```

2. Configuración de la base de datos:
   
   **Windows (PostgreSQL)**:
   ```bash
   # Accede a PostgreSQL como administrador
   psql -U postgres
   # Dentro de PostgreSQL, crea un usuario y base de datos
   CREATE USER quizfusion WITH PASSWORD 'contraseña';
   CREATE DATABASE quizfusion_db OWNER quizfusion;
   \q
   ```

   **macOS/Linux**:
   ```bash
   # Accede a PostgreSQL como superusuario
   sudo -u postgres psql
   # Dentro de PostgreSQL, crea un usuario y base de datos
   CREATE USER quizfusion WITH PASSWORD 'contraseña';
   CREATE DATABASE quizfusion_db OWNER quizfusion;
   \q
   ```

3. Configuración del proyecto IHP:
   ```bash
   ./start
   ```
   Este comando iniciará el servidor de desarrollo, configurará la base de datos y abrirá la aplicación en tu navegador predeterminado.

4. La aplicación estará disponible en: http://localhost:8000

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
