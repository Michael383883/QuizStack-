module Web.View.Static.Home where
import Web.View.Prelude

data HomeView = HomeView

instance View HomeView where
    html HomeView = [hsx|
        <head>
            <link rel="stylesheet" href="/css/home.css" />
        </head>
        <body>
            <nav class="navbar">
                <div class="navbar-container">
                    <div class="navbar-brand">
                        <img src="/images/logoapp.png" alt="QuizZZite" class="logo"
                            onerror="this.onerror=null; this.src='/images/default-logo.png'; this.alt='Logo no encontrado'"/>
                        <span class="brand-name">QuizZZite</span>
                    </div>
                    <div class="navbar-menu">
                        <a href="#" class="nav-link">About</a>
                        <a href="#" class="nav-link">Features</a>
                        <a href="#" class="nav-link">Pricing</a>
                        <a href="#" class="nav-link">Gallery</a>
                        <a href="#" class="nav-link">Team</a>
                    </div>
                    <div class="nav-button-container">
                        <a href="#" class="nav-button">INICIAR PRUEBA</a>
                    </div>
                </div>
            </nav>

             <div class="hero-section">
                <div class="hero-content">
                    <div class="hero-text-container">
                        <h1 class="hero-title">Aprender nunca fue tan divertido: ¡resuelve, piensa y arma el conocimiento!</h1>
                        <button class="create-question-button">CREA UNA PREGUNTA</button>
                    </div>
                    <div class="hero-image-container">
                        <img src="/images/imagenfondo.png" alt="Imagen educativa" class="hero-image"/>
                    </div>
                </div>

                 <!-- Logos añadidos aquí -->
                
            </div>
            <div class="institutional-logos">
                    <img src="/images/titulofcyt.png" alt="FCyT" class="institutional-logo"/>
                    <img src="/images/tituloumss.png" alt="UMSS" class="institutional-logo"/>
                </div>
             
        </body>
    |]
