module Web.View.CreateQuestion.New where

import Web.View.Prelude
import Web.View.Components.Navigation (renderNavigation)

data NewView = NewView

instance View NewView where
    html NewView = [hsx|
        <head>
            <link rel="stylesheet" href="/css/create-question.css" />
            <title>Crea tu Puzzle Educativo - QuizZZite</title>
        </head>
        <body>
            <div class="main-container">
                {renderNavigation}
                
                <div class="content-container">
                    <div class="create-puzzle-container">
                        <div class="page-header">
                            <a href="/" class="back-link">
                                <span class="back-arrow">←</span>
                            </a>
                            <h1 class="page-title">Crea tu Puzzle Educativo</h1>
                        </div>
                        
                        <div class="create-puzzle-content">
                            <div class="puzzle-step-container">
                                <div class="puzzle-image-preview">
                                    <div class="shapes-container">
                                        <div class="shape triangle"></div>
                                        <div class="shape square"></div>
                                        <div class="shape circle"></div>
                                    </div>
                                </div>
                                
                                <div class="puzzle-step-instructions">
                                    <h2 class="step-title">Paso 1: Define la pregunta y el nivel de dificultad</h2>
                                    <p class="instructions-label">Instrucciones</p>
                                    <p class="instructions-text">
                                        Este es el primer paso para crear tu puzzle educativo. Aquí debes elegir la 
                                        dificultad (fácil, media o difícil) y definir una pregunta que estará relacionada con 
                                        el contenido visual del puzzle. La pregunta servirá como una guía o reto adicional 
                                        que estimule el pensamiento crítico mientras se arma la imagen.
                                    </p>
                                    <p class="instructions-text">
                                        Nuestra aplicación está diseñada en tres pasos simples. En este primer paso 
                                        defines la base del contenido. Luego, en el segundo paso, podrás subir la imagen 
                                        que se convertirá en el puzzle y escribir una pista para ayudar al jugador...
                                    </p>
                                </div>
                            </div>
                            
                            <div class="form-container">
                                <div class="form-group">
                                    <label for="question" class="form-label">Cual sera la pregunta a resolver</label>
                                    <input type="text" id="question" name="question" placeholder="Ingresa tu pregunta" class="form-input" />
                                </div>
                                
                                <div class="form-group">
                                    <label class="form-label">Establese el nivel de dificultad del puzzle</label>
                                    <div class="difficulty-slider-container">
                                        <span class="difficulty-label">Facil</span>
                                        <input type="range" min="1" max="3" value="1" class="difficulty-slider" id="difficulty" name="difficulty" />
                                        <span class="difficulty-label">Dificil</span>
                                    </div>
                                    <div class="difficulty-labels">
                                        <span class="difficulty-min">Facil</span>
                                        <span class="difficulty-mid">Medio</span>
                                        <span class="difficulty-max">Difícil</span>
                                    </div>
                                </div>
                                
                                <div class="form-actions">
                                     <a href={pathTo NewCuestiontwoAction} class="next-button">Siguiente</a>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </body>
    |]