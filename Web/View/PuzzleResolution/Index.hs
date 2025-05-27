module Web.View.PuzzleResolution.Index where
import Web.View.Prelude
import Web.View.Components.Navigation (renderNavigation)
import Web.View.PuzzleResolution.PuzzleViewer
import Web.View.PuzzleResolution.CodeEditor
import Web.View.PuzzleResolution.MapPreview

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
                                {renderPuzzleViewer}
                                {renderCodeEditor}
                                {renderMapPreview}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </body>
    |]