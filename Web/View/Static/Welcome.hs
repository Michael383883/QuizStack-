-- Web/View/Static/Welcome.hs
module Web.View.Static.Welcome where

import Web.View.Prelude

data WelcomeView = WelcomeView

instance View WelcomeView where
    html WelcomeView = [hsx|
        <div class="welcome-container">
            <h1>Bienvenido a QuizZZite</h1>
            <p>Crea puzzles educativos interactivos</p>
            <a href="/NewCreateQuestion" class="btn btn-primary">Crear Puzzle</a>
        </div>
    |]



