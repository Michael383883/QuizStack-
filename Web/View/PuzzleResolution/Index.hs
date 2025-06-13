module Web.View.PuzzleResolution.Index where

import Web.View.Prelude
import Web.View.Components.Navigation (renderNavigation)
import Web.View.PuzzleResolution.PuzzleViewer
import Web.View.PuzzleResolution.CodeEditor
import Web.View.PuzzleResolution.MapPreview
import Data.Aeson (object, (.=))
import Data.String.Conversions (cs)

data PuzzleResolutionView = PuzzleResolutionView
    { puzzleQuestion :: Text
    , puzzleDifficulty :: Text
    }

instance View PuzzleResolutionView where
    html PuzzleResolutionView { puzzleQuestion, puzzleDifficulty } = [hsx|
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
                            <h1 class="page-title">Rompecabezas - {puzzleDifficulty}</h1>
                            <a href="#" class="next-link">
                                <span class="next-arrow">→</span>
                            </a>
                        </div>
                        <div class="preview-puzzle-content">
                            <div class="puzzle-tabs">
                                {renderPuzzleViewerWithQuestion puzzleQuestion}
                                {renderCodeEditor}
                                {renderMapPreview}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Variables para JavaScript -->
            <script id="puzzle-data" type="application/json">
                {preEscapedToHtml $ cs $ show $ object [
                    "question" .= puzzleQuestion,
                    "difficulty" .= puzzleDifficulty
                ]}
            </script>
            
            <!-- Script para pasar la pregunta al JavaScript -->
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    // Leer datos del script JSON
                    const puzzleDataScript = document.getElementById('puzzle-data');
                    let puzzleData = {};
                    
                    try {
                        puzzleData = JSON.parse(puzzleDataScript.textContent);
                        console.log('🎯 Datos del puzzle cargados:', puzzleData);
                    } catch (error) {
                        console.error('❌ Error parseando datos del puzzle:', error);
                        // Valores por defecto
                        puzzleData = {
                            question: 'Resuelve el puzzle geográfico',
                            difficulty: 'Fácil'
                        };
                    }
                    
                    // Guardar la pregunta en sessionStorage para acceso desde JavaScript
                    sessionStorage.setItem('currentPuzzleQuestion', puzzleData.question);
                    sessionStorage.setItem('currentPuzzleDifficulty', puzzleData.difficulty);
                    
                    // También guardar en el formato que espera el PuzzleViewer
                    sessionStorage.setItem('puzzleQuestion', puzzleData.question);
                    sessionStorage.setItem('puzzleDifficulty', puzzleData.difficulty);
                    
                    // Disparar evento para actualizar la pregunta en el viewer
                    window.dispatchEvent(new CustomEvent('updatePuzzleQuestion', {
                        detail: { 
                            question: puzzleData.question,
                            difficulty: puzzleData.difficulty
                        }
                    }));
                    
                    console.log('🎯 Pregunta del servidor cargada:', puzzleData.question);
                    console.log('🎯 Dificultad del servidor cargada:', puzzleData.difficulty);
                });
            </script>
        </body>
    |]