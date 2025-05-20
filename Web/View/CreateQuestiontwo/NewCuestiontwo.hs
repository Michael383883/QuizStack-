module Web.View.CreateQuestiontwo.NewCuestiontwo where

import Web.View.Prelude
import Web.View.Components.Navigation (renderNavigation)

data NewCuestiontwoView = NewCuestiontwoView

instance View NewCuestiontwoView where
    html NewCuestiontwoView = [hsx|
        <head>
            <link rel="stylesheet" href="/css/create-questiontwo.css" />
            <title>Sube Imagen y Escribe la Pista - QuizZZite</title>
        </head>
        <body>
            <div class="main-container">
                {renderNavigation}

                <div class="content-container">
                    <div class="create-puzzle-container">
                        <div class="page-header">
                            <a href={pathTo NewCreateQuestionAction} class="back-link">
                                <span class="back-arrow">←</span>
                            </a>
                            <h1 class="page-title">Sube tu Imagen y Escribe la Pista</h1>
                            <a href="#" class="next-link">
                                <span class="next-arrow">→</span>
                            </a>
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
                                    <h2 class="step-title">Paso 2: Imagen del Puzzle y Pista de Ayuda</h2>
                                    <p class="instructions-label">Instrucciones</p>
                                    <p class="instructions-text">
                                        Selecciona una imagen clara y de buena calidad. Luego, escribe una pista que oriente al
                                        jugador sin revelar completamente la respuesta.
                                    </p>
                                </div>
                            </div>

                            <div class="form-container">
                                <div class="form-group">
                                    <label for="hint" class="form-label">¿Cuál será la pista que irá dentro del puzzle?</label>
                                    <input type="text" id="hint" name="hint" placeholder="Ingresa tu pista" class="form-input" />
                                    
                                    <div class="hint-toggle-container">
                                        <label class="switch">
                                            <input type="checkbox" id="no-hint" name="noHint">
                                            <span class="slider round"></span>
                                        </label>
                                        <span class="hint-toggle-label">No hay pista</span>
                                    </div>
                                </div>

                                <div class="form-group image-upload-container">
                                    <div class="upload-area">
                                        <div class="upload-icon">
                                            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                                <polyline points="17 8 12 3 7 8"></polyline>
                                                <line x1="12" y1="3" x2="12" y2="15"></line>
                                            </svg>
                                        </div>
                                        <p class="upload-text">Elija un archivo o arrástrelo y suéltelo aquí.</p>
                                        <p class="upload-format">Formatos JPEG, PNG, WebP, hasta 10 MB.</p>

                                        <div class="upload-button-container">
                                            <label for="file-upload" class="upload-button">
                                                Buscar Archivo
                                                <input id="file-upload" type="file" accept="image/jpeg,image/png,image/webp" hidden />
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                 <div class="form-actions">
                                     <a href={pathTo PreviewquestionAction} class="next-button">Siguiente</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </body>
    |]
