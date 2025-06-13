module Web.View.PuzzleResolution.PuzzleViewer where
import Web.View.Prelude
import Web.View.PuzzleResolution.PuzzleMap (renderPuzzleMap)

-- Función para renderizar el PuzzleViewer con la pregunta como parámetro
renderPuzzleViewerWithQuestion :: Text -> Html
renderPuzzleViewerWithQuestion questionText = [hsx|
<link rel="stylesheet" href="/css/puzzle-viewer.css" />
    <div class="puzzle-container">
        <div class="puzzle-header">
            <h2 class="puzzle-title" id="puzzle-title">{questionText}</h2>  
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
            const titleElement = document.getElementById('puzzle-title');
            
            // Función para actualizar displays del viewer
            function updateViewerDisplays() {
                if (window.puzzleControls && typeof window.puzzleControls.getAgentState === 'function') {
                    try {
                        const state = window.puzzleControls.getAgentState();
                        
                        if (state) {
                            positionDisplay.textContent = `(${state.x},${state.y})`;
                            directionDisplay.textContent = state.direction || 'Norte';
                            
                            // Actualizar información de ejecución si está disponible
                            if (state.currentInstruction) {
                                currentInstructionDisplay.textContent = state.currentInstruction;
                            }
                            
                            if (state.executionStep !== undefined && state.totalSteps !== undefined) {
                                executionStepDisplay.textContent = `${state.executionStep}/${state.totalSteps}`;
                            }
                            
                            if (state.status) {
                                executionStatusDisplay.textContent = state.status;
                            }
                        }
                    } catch (error) {
                        // Silenciar errores de estado no disponible
                    }
                }
            }
            
            // Función para recuperar la pregunta de múltiples fuentes
            function loadPuzzleQuestion() {
                let question = '';
                
                // 1. La pregunta ya está establecida desde el servidor
                const currentTitle = titleElement.textContent;
                if (currentTitle && currentTitle !== 'Cargando pregunta...' && currentTitle !== 'Resuelve el puzzle geográfico') {
                    console.log('✅ Pregunta ya cargada desde servidor:', currentTitle);
                    return currentTitle;
                }
                
                // 2. Intentar desde finalPuzzleData (sessionStorage)
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
                
                // 3. Intentar desde sessionStorage directo
                if (!question) {
                    question = sessionStorage.getItem('puzzleQuestion');
                    if (question) {
                        console.log('✅ Pregunta cargada desde sessionStorage:', question);
                    }
                }
                
                // 4. Intentar desde currentPuzzleQuestion (nueva fuente desde el servidor)
                if (!question) {
                    question = sessionStorage.getItem('currentPuzzleQuestion');
                    if (question) {
                        console.log('✅ Pregunta cargada desde currentPuzzleQuestion:', question);
                    }
                }
                
                // 5. Actualizar el título si se encontró una pregunta
                if (question && question.trim()) {
                    titleElement.textContent = question;
                    console.log('🎯 Pregunta actualizada en el título');
                    
                    // Guardar también en sessionStorage para futuras referencias
                    sessionStorage.setItem('puzzleQuestion', question);
                } else {
                    console.warn('⚠️ No se encontró pregunta en ninguna fuente');
                }
                
                return question;
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
            
            // Función para resetear el estado del viewer
            window.resetPuzzleViewer = function() {
                positionDisplay.textContent = '(0,0)';
                directionDisplay.textContent = 'Norte';
                currentInstructionDisplay.textContent = 'Ninguna';
                executionStepDisplay.textContent = '0/0';
                executionStatusDisplay.textContent = 'Listo';
                
                // Remover mensaje de éxito si existe
                const existingMessage = document.querySelector('.success-message');
                if (existingMessage) {
                    existingMessage.remove();
                }
                
                console.log('🔄 PuzzleViewer reseteado');
            };
            
            // Monitorear cambios en el estado del agente
            function startStatusMonitoring() {
                setInterval(updateViewerDisplays, 200);
            }
            
            // Función para verificar si PuzzleMap está disponible
            function isPuzzleMapReady() {
                return window.puzzleControls && 
                       typeof window.puzzleControls.isReady === 'function' &&
                       window.puzzleControls.isReady();
            }
            
            // Esperar a que el PuzzleMap esté listo y luego inicializar
            function waitForPuzzleMap() {
                if (isPuzzleMapReady()) {
                    try {
                        console.log('✅ PuzzleMap detectado y listo');
                        console.log('🔗 PuzzleViewer conectado exitosamente');
                        
                        // Inicializar displays
                        updateViewerDisplays();
                        
                        // Comenzar monitoreo de estado
                        startStatusMonitoring();
                        
                        // Dispatch evento para notificar que el viewer está listo
                        window.dispatchEvent(new CustomEvent('puzzleViewerReady', {
                            detail: { 
                                viewer: 'ready',
                                question: titleElement.textContent 
                            }
                        }));
                        
                        return;
                    } catch (error) {
                        console.error('❌ Error inicializando PuzzleViewer:', error);
                    }
                } else {
                    console.log('⏳ Esperando PuzzleMap...');
                }
                
                // Reintentar en 100ms
                setTimeout(waitForPuzzleMap, 100);
            }
            
            // Función de debug para mostrar estado actual
            window.debugPuzzleViewer = function() {
                console.log('🔍 Debug PuzzleViewer:');
                console.log('- Título actual:', titleElement.textContent);
                console.log('- PuzzleMap ready:', isPuzzleMapReady());
                console.log('- sessionStorage puzzleQuestion:', sessionStorage.getItem('puzzleQuestion'));
                console.log('- sessionStorage finalPuzzleData:', sessionStorage.getItem('finalPuzzleData'));
                console.log('- sessionStorage currentPuzzleQuestion:', sessionStorage.getItem('currentPuzzleQuestion'));
                
                if (window.puzzleControls) {
                    try {
                        const state = window.puzzleControls.getAgentState();
                        console.log('- Estado del agente:', state);
                    } catch (error) {
                        console.log('- Error obteniendo estado:', error.message);
                    }
                }
            };
            
            // Exponer funciones globalmente para debugging
            window.puzzleViewer = {
                loadQuestion: loadPuzzleQuestion,
                updateDisplays: updateViewerDisplays,
                reset: window.resetPuzzleViewer,
                debug: window.debugPuzzleViewer,
                isReady: isPuzzleMapReady
            };
            
            // Cargar la pregunta al inicializar
            const loadedQuestion = loadPuzzleQuestion();
            console.log('🎯 Pregunta inicial cargada:', loadedQuestion);
            
            // Inicializar cuando todo esté listo
            waitForPuzzleMap();
            
            // Log para debugging
            console.log('🔍 Debug - Datos disponibles en sessionStorage:');
            console.log('- puzzleQuestion:', sessionStorage.getItem('puzzleQuestion'));
            console.log('- finalPuzzleData existe:', !!sessionStorage.getItem('finalPuzzleData'));
            console.log('- currentPuzzleQuestion:', sessionStorage.getItem('currentPuzzleQuestion'));
            console.log('- Pregunta mostrada:', loadedQuestion);
            
            console.log('🎮 PuzzleViewer script cargado completamente');
        });
        
        // Event listener para cuando se actualiza la pregunta externamente
        window.addEventListener('updatePuzzleQuestion', function(event) {
            const titleElement = document.getElementById('puzzle-title');
            if (event.detail && event.detail.question) {
                titleElement.textContent = event.detail.question;
                console.log('🔄 Pregunta actualizada externamente:', event.detail.question);
            }
        });
        
        console.log('🎮 PuzzleViewer módulo cargado');
    </script>
|]

-- Función de compatibilidad con el código existente
renderPuzzleViewer :: Html
renderPuzzleViewer = renderPuzzleViewerWithQuestion "Resuelve el puzzle geográfico"