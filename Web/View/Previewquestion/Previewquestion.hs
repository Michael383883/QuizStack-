module Web.View.Previewquestion.Previewquestion where

import Web.View.Prelude
import Web.View.Components.Navigation (renderNavigation)

data PreviewquestionView = PreviewquestionView

instance View PreviewquestionView where
    html PreviewquestionView = [hsx|
        <head>
            <link rel="stylesheet" href="/css/preview-question.css" />
            <title>Previsualiza y Revisa tu Puzzle - QuizZZite</title>
        </head>
        <body>
            <div class="main-container">
                {renderNavigation}

                <div class="content-container">
                    <div class="preview-puzzle-container">
                        <div class="page-header">
                            <a href={pathTo NewCuestiontwoAction} class="back-link">
                                <span class="back-arrow">←</span>
                            </a>
                            <h1 class="page-title">Previsualiza y Revisa tu Puzzle</h1>
                        </div>

                        <div class="preview-puzzle-content">
                            <div class="puzzle-step-container">
                                <div class="preview-information">
                                    <h2 class="step-title">Paso 3: Vista previa y confirmación final</h2>
                                    <p class="instructions-label">Instrucciones</p>
                                    <p class="instructions-text">
                                        Observa cómo se verá tu puzzle antes de finalizar. Verifica que la imagen, 
                                        la pregunta y la pista estén correctas. Si todo está bien, ¡es hora de publicarlo!
                                    </p>
                                </div>
                            </div>

                            <div class="preview-container">
                                <div class="preview-frame">
                                    <div class="puzzle-image-preview">
                                        <img id="preview-image" src="#" alt="Vista previa del puzzle" />
                                    </div>
                                    <div class="puzzle-hint-preview">
                                        <div class="hint-bubble">
                                            <p id="preview-hint">Verifica si el puzzle creado tiene relación con la imagen que has subido</p>
                                        </div>
                                        <div class="hint-character">
                                             <img src="/images/teacher-character.png" alt="Personaje guía" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="form-actions">
                                <a href={pathTo NewCuestiontwoAction} class="back-button">Volver a crear</a>
                              <a href={pathTo PuzzleResolutionAction} class="finish-button">Terminar</a>
                               
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </body>
    |]