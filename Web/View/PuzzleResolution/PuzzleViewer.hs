
module Web.View.PuzzleResolution.PuzzleViewer where
import Web.View.Prelude

renderPuzzleViewer = [hsx|
<link rel="stylesheet" href="/css/puzzle-viewer.css" />
    <div class="puzzle-container">
        <div class="puzzle-header">
            <h2 class="puzzle-title">Puzzle</h2>
            <div class="piece-selector">
                <select class="piece-dropdown" id="pieceSelector">
                    <option value="piece1">Pieza 1</option>
                    <option value="piece2">Pieza 2</option>
                    <option value="piece3">Pieza 3</option>
                    <option value="piece4">Pieza 4</option>
                </select>
                <div class="controls">
                    <button class="control-btn" id="resetBtn" title="Reiniciar">↻</button>
                    <button class="control-btn" id="rotateBtn" title="Rotar">⟲</button>
                </div>
            </div>
        </div>
        
        <div class="puzzle-main">
            <!-- Área del puzzle armado -->
            <div class="assembled-puzzle">
                <div class="puzzle-grid">
                    <div class="puzzle-piece assembled blue-piece" data-position="top"></div>
                    <div class="puzzle-piece assembled orange-piece" data-position="middle-left"></div>
                    <div class="puzzle-piece assembled yellow-piece" data-position="middle-right"></div>
                    <div class="puzzle-piece assembled red-piece" data-position="bottom"></div>
                </div>
            </div>
            
            <!-- Instrucciones -->
            <div class="puzzle-instructions">
                <div class="instruction-text">
                    <p>Puedes usar la pieza según lo que interpretes</p>
                </div>
                <div class="teacher-character">
                    <div class="teacher-avatar">
                        <div class="teacher-head"></div>
                        <div class="teacher-body"></div>
                        <div class="teacher-arm"></div>
                        <div class="teacher-pointer"></div>
                    </div>
                </div>
            </div>
            
            <!-- Área de piezas disponibles -->
            <div class="available-pieces">
                <h3 class="pieces-title">Piezas Disponibles</h3>
                <div class="pieces-container">
                    <div class="puzzle-piece draggable piece-1" data-piece="1" draggable="true">
                        <div class="piece-3d">
                            <div class="piece-front"></div>
                            <div class="piece-back"></div>
                            <div class="piece-top"></div>
                            <div class="piece-bottom"></div>
                            <div class="piece-left"></div>
                            <div class="piece-right"></div>
                        </div>
                    </div>
                    
                    <div class="puzzle-piece draggable piece-2" data-piece="2" draggable="true">
                        <div class="piece-3d">
                            <div class="piece-front"></div>
                            <div class="piece-back"></div>
                            <div class="piece-top"></div>
                            <div class="piece-bottom"></div>
                            <div class="piece-left"></div>
                            <div class="piece-right"></div>
                        </div>
                    </div>
                    
                    <div class="puzzle-piece draggable piece-3" data-piece="3" draggable="true">
                        <div class="piece-3d">
                            <div class="piece-front"></div>
                            <div class="piece-back"></div>
                            <div class="piece-top"></div>
                            <div class="piece-bottom"></div>
                            <div class="piece-left"></div>
                            <div class="piece-right"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
                <script>
        // Funcionalidad para el puzzle interactivo
        document.addEventListener('DOMContentLoaded', function() {
            const draggablePieces = document.querySelectorAll('.draggable');
            const assembledPuzzle = document.querySelector('.puzzle-grid');
            const resetBtn = document.getElementById('resetBtn');
            const rotateBtn = document.getElementById('rotateBtn');
            const pieceSelector = document.getElementById('pieceSelector');
            const piecesContainer = document.querySelector('.pieces-container');
            
            // Inicializar: mostrar solo la primera pieza
            showSelectedPiece('piece1');
            
            // Cambio de pieza en el selector
            pieceSelector.addEventListener('change', function() {
                const selectedValue = this.value;
                showSelectedPiece(selectedValue);
                
                // Efecto de transición suave
                piecesContainer.style.transform = 'scale(0.8)';
                setTimeout(() => {
                    piecesContainer.style.transform = 'scale(1)';
                }, 200);
            });
            
            // Función para mostrar solo la pieza seleccionada
            function showSelectedPiece(pieceValue) {
                draggablePieces.forEach((piece, index) => {
                    const pieceNumber = index + 1;
                    const shouldShow = pieceValue === `piece${pieceNumber}`;
                    
                    if (shouldShow) {
                        piece.style.display = 'block';
                        piece.style.opacity = '0';
                        piece.style.transform = 'translateY(30px) scale(0.8)';
                        
                        // Animación de entrada
                        setTimeout(() => {
                            piece.style.opacity = '1';
                            piece.style.transform = 'translateY(0) scale(1)';
                        }, 100);
                    } else {
                        piece.style.opacity = '0';
                        piece.style.transform = 'translateY(-30px) scale(0.8)';
                        
                        // Ocultar después de la animación
                        setTimeout(() => {
                            piece.style.display = 'none';
                        }, 300);
                    }
                });
            }
            
            // Drag and drop functionality
            draggablePieces.forEach(piece => {
                piece.addEventListener('dragstart', handleDragStart);
                piece.addEventListener('click', function() {
                    this.classList.add('selected');
                    setTimeout(() => this.classList.remove('selected'), 300);
                });
            });
            
            // Reset functionality con efecto mejorado
            resetBtn.addEventListener('click', function() {
                this.style.transform = 'scale(0.9)';
                setTimeout(() => {
                    this.style.transform = 'scale(1)';
                }, 150);
                
                document.querySelector('.puzzle-grid').classList.add('reset-animation');
                setTimeout(() => {
                    document.querySelector('.puzzle-grid').classList.remove('reset-animation');
                }, 1000);
            });
            
            // Rotate functionality mejorada
            rotateBtn.addEventListener('click', function() {
                this.style.transform = 'scale(0.9)';
                setTimeout(() => {
                    this.style.transform = 'scale(1)';
                }, 150);
                
                const visiblePiece = document.querySelector('.draggable[style*="opacity: 1"]');
                if (visiblePiece) {
                    const currentRotation = visiblePiece.dataset.rotation || 0;
                    const newRotation = parseInt(currentRotation) + 90;
                    visiblePiece.dataset.rotation = newRotation;
                    visiblePiece.style.transform += ` rotateZ(${newRotation}deg)`;
                    
                    // Efecto de rotación suave
                    visiblePiece.style.transition = 'transform 0.6s cubic-bezier(0.4, 0.0, 0.2, 1)';
                }
            });
            
            function handleDragStart(e) {
                e.dataTransfer.setData('text/plain', e.target.dataset.piece);
                e.target.style.opacity = '0.7';
            }
            
            // Efecto al terminar el drag
            draggablePieces.forEach(piece => {
                piece.addEventListener('dragend', function() {
                    this.style.opacity = '1';
                });
            });
        });
    </script>
|]