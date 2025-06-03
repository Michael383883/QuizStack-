

module Web.View.PuzzleResolution.PuzzleViewer where
import Web.View.Prelude
import Web.View.PuzzleResolution.PuzzleMap (renderPuzzleMap)

renderPuzzleViewer = [hsx|
<link rel="stylesheet" href="/css/puzzle-viewer.css" />
    <div class="puzzle-container">
        <div class="puzzle-header">
            <h2 class="puzzle-title" id="puzzle-title">Cargando pregunta...</h2>  
            <div class="piece-info">
                <div class="current-piece-info">
                    <span id="currentPieceLabel">Bolivia - Pieza Faltante</span>
                    <div class="piece-stats">
                        <span>Pos: <span id="piecePosition">(0,0)</span></span>
                        <span>Dir: <span id="pieceDirection">Norte</span></span>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="puzzle-main">
            
            {renderPuzzleMap}
            
            <!-- Panel de información del mapa -->
            <div class="map-info-panel">
                <div class="map-legend">
                    <h4>Leyenda del Mapa</h4>
                    <div class="legend-items">
                        <div class="legend-item">
                            <div class="legend-color start"></div>
                            <span>Inicio (S)</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color goal bolivia-target"></div>
                            <span>Lugar de Bolivia (META)</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color country"></div>
                            <span>Otros Países</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color ocean"></div>
                            <span>Océano (Obstáculo)</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color mountain"></div>
                            <span>Montañas</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color path"></div>
                            <span>Frontera Libre</span>
                        </div>
                    </div>
                </div>
                
                <div class="countries-info">
                    <h4>Países en el Mapa</h4>
                    <div class="countries-list">
                        <div class="country-item">🇵🇪 Perú</div>
                        <div class="country-item">🇧🇷 Brasil</div>
                        <div class="country-item">🇦🇷 Argentina</div>
                        <div class="country-item">🇨🇱 Chile</div>
                        <div class="country-item">🇵🇾 Paraguay</div>
                        <div class="country-item bolivia-missing">🇧🇴 Bolivia (FALTANTE)</div>
                    </div>
                </div>
                
                <div class="execution-status">
                    <h4>Estado de Ejecución</h4>
                    <div class="status-info">
                        <div class="status-item">
                            <span>Instrucción actual:</span>
                            <span id="currentInstruction">Ninguna</span>
                        </div>
                        <div class="status-item">
                            <span>Paso:</span>
                            <span id="executionStep">0/0</span>
                        </div>
                        <div class="status-item">
                            <span>Estado:</span>
                            <span id="executionStatus">Listo</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>

        
        document.addEventListener('DOMContentLoaded', function() {
            console.log('🎮 PuzzleViewer iniciando...');
            
            // Elementos DOM para displays
            const positionDisplay = document.getElementById('piecePosition');
            const directionDisplay = document.getElementById('pieceDirection');
            const currentInstructionDisplay = document.getElementById('currentInstruction');
            const executionStepDisplay = document.getElementById('executionStep');
            const executionStatusDisplay = document.getElementById('executionStatus');
            

                        }
                    }
                }
            }
            
            // Función para mostrar mensaje de éxito
            window.showSuccessMessage = function() {
                console.log('🎉 ¡Éxito! Bolivia llegó al objetivo');
                
                // Remover mensaje anterior si existe
                const existingMessage = document.querySelector('.success-message');
                if (existingMessage) {
                    existingMessage.remove();
                }
                
                const messageDiv = document.createElement('div');
                messageDiv.className = 'success-message';
                messageDiv.innerHTML = `
                    <div class="message-content">
                        <h3>¡Felicitaciones!</h3>
                        <p>🇧🇴 Bolivia ha encontrado su lugar en el mapa</p>
                        <p>El puzzle de Sudamérica está completo</p>
                        <button onclick="window.puzzleControls.resetSimulation()" class="reset-button">Nuevo Desafío</button>
                    </div>
                `;
                document.body.appendChild(messageDiv);
                
                setTimeout(() => {
                    messageDiv.classList.add('show');
                }, 100);
            };
            
            // Callback cuando se alcanza el objetivo
            window.onPuzzleSolved = function() {
                console.log('🏆 Puzzle resuelto - callback desde PuzzleMap');
                showSuccessMessage();
                executionStatusDisplay.textContent = '¡Bolivia encontró su lugar!';
            };
            
            // Monitorear cambios en el estado del agente
            function startStatusMonitoring() {
                setInterval(updateViewerDisplays, 200);
            }
            
            // Esperar a que el PuzzleMap esté listo y luego inicializar
            function waitForPuzzleMap() {
                if (window.puzzleControls && typeof window.puzzleControls.isReady === 'function') {
                    try {
                        if (window.puzzleControls.isReady()) {
                            console.log('✅ PuzzleMap detectado y listo');
                            console.log('🔗 PuzzleViewer conectado exitosamente');
                            
                            // Inicializar displays
                            updateViewerDisplays();
                            
                            // Comenzar monitoreo de estado
                            startStatusMonitoring();
                            
                            // Dispatch evento para notificar que el viewer está listo
                            window.dispatchEvent(new CustomEvent('puzzleViewerReady'));
                            
                            return;
                        }
                    } catch (error) {
                        console.log('⏳ PuzzleMap aún no está listo:', error.message);
                    }
                }
                
                // Reintentar en 100ms
                setTimeout(waitForPuzzleMap, 100);
            }
            
            // Inicializar cuando todo esté listo
            waitForPuzzleMap();
            
            console.log('🎮 PuzzleViewer script cargado');
        });
        
        console.log('🎮 PuzzleViewer módulo cargado');


                


                document.addEventListener('DOMContentLoaded', function() {
    // Función mejorada para cargar la pregunta
    function loadPuzzleQuestion() {
        let question = '';
        
        // 1. Primero intentar desde finalPuzzleData (más confiable)
        const finalPuzzleData = sessionStorage.getItem('finalPuzzleData');
        if (finalPuzzleData) {
            try {
                const data = JSON.parse(finalPuzzleData);
                question = data.question;
                console.log('✅ Pregunta cargada desde finalPuzzleData:', question);
            } catch (error) {
                console.error('❌ Error parseando finalPuzzleData:', error);
            }
        }
        
        // 2. Si no se encontró, intentar desde sessionStorage directo
        if (!question) {
            question = sessionStorage.getItem('puzzleQuestion');
            if (question) {
                console.log('✅ Pregunta cargada desde sessionStorage:', question);
            }
        }
        
        // 3. Actualizar el título con la pregunta
        const titleElement = document.getElementById('puzzle-title');
        if (question && question.trim()) {
            titleElement.textContent = question;
            console.log('🎯 Pregunta mostrada en el título');
        } else {
            titleElement.textContent = 'Resuelve el puzzle geográfico';
            console.warn('⚠️ No se encontró pregunta, usando título por defecto');
        }
        
        return question;
    }
    
    // Cargar la pregunta
    const loadedQuestion = loadPuzzleQuestion();
    
    // Log para debugging
    console.log('🔍 Debug - Datos disponibles en sessionStorage:');
    console.log('- puzzleQuestion:', sessionStorage.getItem('puzzleQuestion'));
    console.log('- finalPuzzleData existe:', !!sessionStorage.getItem('finalPuzzleData'));
    console.log('- Pregunta cargada:', loadedQuestion);
    
    // Resto del código del PuzzleViewer...
});


    </script>
|]