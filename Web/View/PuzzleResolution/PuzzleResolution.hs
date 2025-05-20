module Web.View.PuzzleResolution.PuzzleResolution where
import Web.View.Prelude
import Web.View.Components.Navigation (renderNavigation)

data PuzzleResolutionView = PuzzleResolutionView

instance View PuzzleResolutionView where
    html PuzzleResolutionView = [hsx|
        <head>
            <link rel="stylesheet" href="/css/puzzle-resolution.css" />
            <title>Rompecabezas - QuizZite</title>
        </head>
        <body>
            <div class="main-container">
                {renderNavigation}
                <div class="content-container">
                    <div class="preview-puzzle-container">
                        <div class="page-header">
                            <a href="#" class="back-link">
                                <span class="back-arrow">←</span>
                            </a>
                            <h1 class="page-title">Rompecabezas</h1>
                            <a href="#" class="next-link">
                                <span class="next-arrow">→</span>
                            </a>
                        </div>
                        <div class="preview-puzzle-content">
                            <div class="puzzle-tabs">
                                <div class="puzzle-tab">
                                    <h2 class="tab-title">Puzzle</h2>
                                    <div class="piece-selector">
                                        <select class="piece-dropdown">
                                            <option>Pieza 1</option>
                                        </select>
                                    </div>
                                    <div class="puzzle-content">
                                        <p class="puzzle-instructions">Puedes usar la pieza según lo que interpretes</p>
                                        <div class="puzzle-piece-preview">
                                            <img src="/images/puzzle-piece-blue.png" alt="Pieza de puzzle" class="piece-image" />
                                        </div>
                                        <div class="puzzle-character">
                                            <img src="/images/teacher-character.png" alt="Profesor" />
                                        </div>
                                    </div>
                                </div>
                                <div class="puzzle-tab">
                                    <h2 class="tab-title">Editor de Código</h2>
                                    <div class="code-editor">
                                        <div class="editor-dots">
                                            <span class="dot dot-green"></span>
                                            <span class="dot dot-blue"></span>
                                        </div>
                                        <div class="editor-content"></div>
                                    </div>
                                    <button class="build-button">Armar</button>
                                </div>
                                <div class="puzzle-tab">
                                    <h2 class="tab-title">Puzzle en Proceso</h2>
                                    <div class="puzzle-preview">
                                        <img src="/images/southamerica-map.png" alt="Mapa de Sudamérica" class="map-image" />
                                    </div>
                                    <button class="finalize-button">Finalizar</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </body>
    |]