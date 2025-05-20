
module Web.View.Components.Navigation where

import Web.View.Prelude

-- Este componente renderiza la barra de navegación que puedes reutilizar en toda tu aplicación
renderNavigation :: Html
renderNavigation = [hsx|
    <nav class="navbar">
        <div class="navbar-container">
            <div class="navbar-brand">
                <img src="/images/logoapp.png" alt="QuizZZite" class="logo"
                            onerror="this.onerror=null; this.src='/images/default-logo.png'; this.alt='Logo no encontrado'"/>
            </div>
            <div class="navbar-menu">
                <a href="#" class="nav-link">About</a>
                <a href="#" class="nav-link">Features</a>
                <a href="#" class="nav-link">Pricing</a>
                <a href="#" class="nav-link dropdown">Gallery</a>
                <a href="#" class="nav-link">Team</a>
            </div>
            <div class="nav-button-container">
                <a href="#" class="nav-button">INICIAR PRUEBA</a>
            </div>
        </div>
    </nav>
|]
