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
                            <a href="/CreateQuestiontwo/New" class="back-link">
                                <span class="back-arrow">←</span>
                            </a>
                            <h1 class="page-title">Previsualiza y Revisa tu Puzzle</h1>
                            <div class="step-indicator">
                                <span class="step completed">1</span>
                                <span class="step completed">2</span>
                                <span class="step active">3</span>
                            </div>
                        </div>
                        
                        <div class="preview-puzzle-content">
                            <div class="puzzle-step-container">
                                <div class="preview-information">
                                    <h2 class="step-title">Paso 3: Vista previa y confirmación final</h2>
                                    <p class="instructions-label">Instrucciones</p>
                                    <p class="instructions-text">
                                        Tu mapa será automáticamente pintado con colores distintivos para cada país. 
                                        Verifica que la detección y el coloreado sean correctos antes de publicar tu puzzle geográfico.
                                    </p>
                                </div>
                            </div>
                            
                            <!-- Resumen del puzzle creado -->
                            <div class="puzzle-summary">
                                <div class="summary-header">
                                    <h3>Resumen de tu Puzzle Geográfico</h3>
                                </div>
                                
                                <div class="summary-grid">
                                    <div class="summary-item">
                                        <label class="summary-label">Pregunta:</label>
                                        <p id="preview-question" class="summary-value">Cargando pregunta...</p>
                                    </div>
                                    
                                    <div class="summary-item">
                                        <label class="summary-label">Países detectados:</label>
                                        <p id="countries-count" class="summary-value">Analizando mapa...</p>
                                    </div>
                                    
                                    <div class="summary-item">
                                        <label class="summary-label">Nivel de dificultad:</label>
                                        <div class="difficulty-display">
                                            <span id="preview-difficulty" class="difficulty-value">Fácil</span>
                                            <div class="difficulty-dots">
                                                <span class="dot" id="dot-1"></span>
                                                <span class="dot" id="dot-2"></span>
                                                <span class="dot" id="dot-3"></span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="summary-item">
                                        <label class="summary-label">Pista incluida:</label>
                                        <p id="preview-hint-status" class="summary-value">Sí</p>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Processing Status -->
                            <div class="processing-status" id="processing-status">
                                <div class="processing-header">
                                    <h4>🎨 Procesando tu mapa...</h4>
                                    <div class="processing-spinner"></div>
                                </div>
                                <div class="processing-steps">
                                    <div class="step-item" id="step-analyze">
                                        <span class="step-icon">🔍</span>
                                        <span class="step-text">Analizando regiones del mapa...</span>
                                        <span class="step-status">⏳</span>
                                    </div>
                                    <div class="step-item" id="step-detect">
                                        <span class="step-icon">🗺️</span>
                                        <span class="step-text">Detectando países...</span>
                                        <span class="step-status">⏳</span>
                                    </div>
                                    <div class="step-item" id="step-paint">
                                        <span class="step-icon">🎨</span>
                                        <span class="step-text">Aplicando colores...</span>
                                        <span class="step-status">⏳</span>
                                    </div>
                                    <div class="step-item" id="step-labels">
                                        <span class="step-icon">🏷️</span>
                                        <span class="step-text">Agregando etiquetas...</span>
                                        <span class="step-status">⏳</span>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Vista previa interactiva del mapa pintado -->
                            <div class="interactive-preview" id="map-preview" style="display: none;">
                                <div class="preview-container">
                                    <div class="map-controls">
                                        <button type="button" class="control-btn" onclick="toggleOriginal()">
                                            <span id="toggle-text">Ver original</span>
                                        </button>
                                        <button type="button" class="control-btn" onclick="regenerateColors()">
                                            🎨 Nuevos colores
                                        </button>
                                        <button type="button" class="control-btn" onclick="toggleLabels()">
                                            🏷️ Mostrar/Ocultar etiquetas
                                        </button>
                                    </div>
                                    
                                    <div class="puzzle-game-preview">
                                        <div class="game-header">
                                            <h4>¿Cómo se verá tu puzzle geográfico?</h4>
                                            <div class="game-difficulty" id="game-difficulty">
                                                <span class="difficulty-badge">Fácil</span>
                                            </div>
                                        </div>
                                        
                                        <div class="puzzle-question-display">
                                            <div class="question-bubble">
                                                <p id="game-question">Tu pregunta aparecerá aquí</p>
                                            </div>
                                        </div>
                                        
                                        <div class="map-container">
                                            <div class="map-frame">
                                                <!-- Canvas para el mapa original -->
                                                <canvas id="original-canvas" style="display: none;"></canvas>
                                                
                                                <!-- Canvas para el mapa pintado -->
                                                <canvas id="painted-canvas"></canvas>
                                                
                                                <!-- Overlay para las etiquetas de países -->
                                                <div class="country-labels" id="country-labels"></div>
                                                
                                                <!-- Simulación de piezas de puzzle -->
                                                <div class="puzzle-pieces-overlay" id="puzzle-overlay">
                                                    <div class="puzzle-piece piece-1"></div>
                                                    <div class="puzzle-piece piece-2"></div>
                                                    <div class="puzzle-piece piece-3"></div>
                                                    <div class="puzzle-piece piece-4"></div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="countries-legend" id="countries-legend">
                                            <h5>Países en tu mapa:</h5>
                                            <div class="legend-items" id="legend-items"></div>
                                        </div>
                                        
                                        <div class="puzzle-hint-display" id="hint-display">
                                            <div class="hint-container">
                                                <div class="hint-icon">💡</div>
                                                <div class="hint-content">
                                                    <span class="hint-label">Pista:</span>
                                                    <p id="preview-hint">Tu pista aparecerá aquí</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Estado de validación -->
                            <div class="validation-status">
                                <div class="validation-header">
                                    <h4>Estado de tu puzzle geográfico</h4>
                                </div>
                                <div class="validation-items">
                                    <div class="validation-item" id="validation-question">
                                        <span class="status-icon">⚠️</span>
                                        <span class="status-text">Pregunta definida</span>
                                        <span class="status-detail" id="question-detail"></span>
                                    </div>
                                    <div class="validation-item" id="validation-image">
                                        <span class="status-icon">⚠️</span>
                                        <span class="status-text">Mapa cargado</span>
                                        <span class="status-detail" id="image-detail"></span>
                                    </div>
                                    <div class="validation-item" id="validation-countries">
                                        <span class="status-icon">⚠️</span>
                                        <span class="status-text">Países detectados</span>
                                        <span class="status-detail" id="countries-detail"></span>
                                    </div>
                                    <div class="validation-item" id="validation-hint">
                                        <span class="status-icon">⚠️</span>
                                        <span class="status-text">Pista configurada</span>
                                        <span class="status-detail" id="hint-detail"></span>
                                    </div>
                                    <div class="validation-item" id="validation-difficulty">
                                        <span class="status-icon">✅</span>
                                        <span class="status-text">Dificultad establecida</span>
                                        <span class="status-detail" id="difficulty-detail"></span>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Acciones finales -->
                            <div class="final-actions">
                                <div class="actions-container">
                                    <button type="button" class="back-button" onclick="window.location.href='/CreateQuestiontwo/New'">
                                        ← Editar imagen y pista
                                    </button>
                                    
                                    <button type="button" class="preview-button" id="test-puzzle-btn">
                                        🎮 Crear puzzle Personalizado
                                    </button>
                                    
                                    <button type="button" class="finish-button" id="publish-btn" disabled>
                                        ✨ Crear puzzle Automatico
                                    </button>
                                </div>
                                
                                <div class="publish-options" id="publish-options" style="display: none;">
                                    <div class="options-header">
                                        <h4>Opciones de publicación</h4>
                                    </div>
                                    <div class="options-content">
                                        <label class="option-item">
                                            <input type="checkbox" id="make-public" checked>
                                            <span class="option-text">Hacer público (otros pueden jugar)</span>
                                        </label>
                                        <label class="option-item">
                                            <input type="checkbox" id="allow-sharing">
                                            <span class="option-text">Permitir compartir</span>
                                        </label>
                                        <label class="option-item">
                                            <input type="checkbox" id="educational-mode" checked>
                                            <span class="option-text">Modo educativo (mostrar nombres al completar)</span>
                                        </label>
                                        <div class="difficulty-pieces-info">
                                            <p>Tu puzzle tendrá <span id="pieces-count">9</span> piezas basado en la dificultad seleccionada.</p>
                                        </div>
                                    </div>
                                    <div class="final-buttons">
                                        <button type="button" class="cancel-publish" onclick="hidePublishOptions()">Cancelar</button>
                                        <button type="button" class="confirm-publish" onclick="confirmPublish()">Confirmar y Publicar</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <style>
                .processing-status {
                    background: #f8fafc;
                    border: 2px solid #e2e8f0;
                    border-radius: 12px;
                    padding: 20px;
                    margin: 20px 0;
                }
                
                .processing-header {
                    display: flex;
                    align-items: center;
                    gap: 15px;
                    margin-bottom: 20px;
                }
                
                .processing-spinner {
                    width: 20px;
                    height: 20px;
                    border: 3px solid #e2e8f0;
                    border-top: 3px solid #3b82f6;
                    border-radius: 50%;
                    animation: spin 1s linear infinite;
                }
                
                @keyframes spin {
                    from { transform: rotate(0deg); }
                    to { transform: rotate(360deg); }
                }
                
                .processing-steps {
                    display: flex;
                    flex-direction: column;
                    gap: 12px;
                }
                
                .step-item {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    padding: 10px;
                    background: white;
                    border-radius: 8px;
                    transition: all 0.3s ease;
                }
                
                .step-item.completed {
                    background: #f0fdf4;
                    border-left: 4px solid #22c55e;
                }
                
                .step-item.active {
                    background: #eff6ff;
                    border-left: 4px solid #3b82f6;
                    animation: pulse 2s infinite;
                }
                
                @keyframes pulse {
                    0%, 100% { opacity: 1; }
                    50% { opacity: 0.7; }
                }
                
                .map-controls {
                    display: flex;
                    gap: 10px;
                    margin-bottom: 15px;
                    flex-wrap: wrap;
                }
                
                .control-btn {
                    padding: 8px 16px;
                    background: #3b82f6;
                    color: white;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 14px;
                    transition: all 0.2s ease;
                }
                
                .control-btn:hover {
                    background: #2563eb;
                    transform: translateY(-1px);
                }
                
                .map-container {
                    position: relative;
                    width: 100%;
                    max-width: 800px;
                    margin: 0 auto;
                }
                
                .map-frame {
                    position: relative;
                    background: #f8fafc;
                    border-radius: 12px;
                    overflow: hidden;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                }
                
                #painted-canvas, #original-canvas {
                    width: 100%;
                    height: auto;
                    display: block;
                }
                
                .country-labels {
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    pointer-events: none;
                }
                
                .country-label {
                    position: absolute;
                    background: rgba(255, 255, 255, 0.9);
                    color: #1f2937;
                    padding: 4px 8px;
                    border-radius: 4px;
                    font-size: 12px;
                    font-weight: 600;
                    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                    transform: translate(-50%, -50%);
                    white-space: nowrap;
                    backdrop-filter: blur(4px);
                    border: 1px solid rgba(0,0,0,0.1);
                }
                
                .countries-legend {
                    margin-top: 20px;
                    padding: 15px;
                    background: #f8fafc;
                    border-radius: 8px;
                    border: 1px solid #e2e8f0;
                }
                
                .countries-legend h5 {
                    margin: 0 0 15px 0;
                    color: #374151;
                    font-size: 16px;
                }
                
                .legend-items {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                    gap: 8px;
                }
                
                .legend-item {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    padding: 6px 10px;
                    background: white;
                    border-radius: 6px;
                    font-size: 14px;
                }
                
                .legend-color {
                    width: 16px;
                    height: 16px;
                    border-radius: 3px;
                    border: 1px solid rgba(0,0,0,0.1);
                    flex-shrink: 0;
                }
                
                .puzzle-pieces-overlay {
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    pointer-events: none;
                    opacity: 0.3;
                }
                
                .puzzle-piece {
                    position: absolute;
                    border: 2px dashed #6b7280;
                    background: rgba(255, 255, 255, 0.1);
                    backdrop-filter: blur(1px);
                }
            </style>
            
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    let puzzleData = {};
                    let paintedMapData = null;
                    let detectedCountries = [];
                    let showingOriginal = false;
                    let labelsVisible = true;
                    
                    // Colores predefinidos para países
                    const countryColors = [
                        '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7',
                        '#DDA0DD', '#98D8C8', '#F7DC6F', '#BB8FCE', '#85C1E9',
                        '#F8C471', '#82E0AA', '#F1948A', '#85C1E9', '#D7BDE2',
                        '#A3E4D7', '#FAD7A0', '#D5A6BD', '#AED6F1', '#A9DFBF',
                        '#F9E79F', '#D2B4DE', '#AED6F1', '#A3E4D7', '#FADBD8'
                    ];
                    
                    // Cargar todos los datos del puzzle
                    loadPuzzleData();
                    
                    // Iniciar el procesamiento del mapa
                    if (puzzleData.imageData) {
                        processMapImage(puzzleData.imageData);
                    }
                    
                    // Actualizar la vista previa básica
                    updateBasicPreview();
                    
                    // Event listeners
                    document.getElementById('test-puzzle-btn').addEventListener('click', testPuzzle);
                    document.getElementById('publish-btn').addEventListener('click', showPublishOptions);
                    
                    function loadPuzzleData() {
                        puzzleData = {
                            question: sessionStorage.getItem('puzzleQuestion') || '',
                            difficulty: parseInt(sessionStorage.getItem('puzzleDifficulty')) || 1,
                            hint: sessionStorage.getItem('puzzleHint') || '',
                            noHint: sessionStorage.getItem('puzzleNoHint') === 'true',
                            imageData: sessionStorage.getItem('puzzleImageData') || '',
                            imageName: sessionStorage.getItem('puzzleImageName') || ''
                        };
                    }
                    
                    function updateBasicPreview() {
                        const difficultyNames = ['Fácil', 'Medio', 'Difícil'];
                        const difficultyColors = ['#22c55e', '#f59e0b', '#ef4444'];
                        const pieceCounts = [9, 16, 25];
                        
                        // Actualizar pregunta
                        if (puzzleData.question) {
                            document.getElementById('preview-question').textContent = puzzleData.question;
                            document.getElementById('game-question').textContent = puzzleData.question;
                        }
                        
                        // Actualizar dificultad
                        const difficultyName = difficultyNames[puzzleData.difficulty - 1];
                        const difficultyColor = difficultyColors[puzzleData.difficulty - 1];
                        
                        document.getElementById('preview-difficulty').textContent = difficultyName;
                        document.querySelector('.difficulty-badge').textContent = difficultyName;
                        document.querySelector('.difficulty-badge').style.backgroundColor = difficultyColor;
                        document.getElementById('pieces-count').textContent = pieceCounts[puzzleData.difficulty - 1];
                        
                        // Actualizar dots de dificultad
                        for (let i = 1; i <= 3; i++) {
                            const dot = document.getElementById(`dot-${i}`);
                            if (i <= puzzleData.difficulty) {
                                dot.classList.add('active');
                                dot.style.backgroundColor = difficultyColor;
                            } else {
                                dot.classList.remove('active');
                            }
                        }
                        
                        // Actualizar pista
                        const hintDisplay = document.getElementById('hint-display');
                        const hintStatus = document.getElementById('preview-hint-status');
                        
                        if (puzzleData.noHint) {
                            hintDisplay.style.display = 'none';
                            hintStatus.textContent = 'No (mayor dificultad)';
                            hintStatus.style.color = '#ef4444';
                        } else if (puzzleData.hint) {
                            document.getElementById('preview-hint').textContent = puzzleData.hint;
                            hintStatus.textContent = 'Sí';
                            hintStatus.style.color = '#22c55e';
                        } else {
                            hintDisplay.style.display = 'none';
                            hintStatus.textContent = 'No configurada';
                            hintStatus.style.color = '#f59e0b';
                        }
                    }
                    
                    async function processMapImage(imageData) {
                        // Simular el procesamiento paso a paso
                        await simulateProcessingStep('step-analyze', 'Analizando estructura del mapa...', 1000);
                        await simulateProcessingStep('step-detect', 'Identificando regiones y fronteras...', 1500);
                        await simulateProcessingStep('step-paint', 'Aplicando colores a cada país...', 2000);
                        await simulateProcessingStep('step-labels', 'Agregando nombres de países...', 1000);
                        
                        // Cargar y procesar la imagen
                        const img = new Image();
                        img.onload = function() {
                            paintMap(img);
                        };
                        img.src = imageData;
                    }
                    
                    async function simulateProcessingStep(stepId, message, duration) {
                        const step = document.getElementById(stepId);
                        step.classList.add('active');
                        step.querySelector('.step-text').textContent = message;
                        
                        await new Promise(resolve => setTimeout(resolve, duration));
                        
                        step.classList.remove('active');
                        step.classList.add('completed');
                        step.querySelector('.step-status').textContent = '✅';
                    }
                    
                    function paintMap(originalImage) {
                        const originalCanvas = document.getElementById('original-canvas');
                        const paintedCanvas = document.getElementById('painted-canvas');
                        const originalCtx = originalCanvas.getContext('2d');
                        const paintedCtx = paintedCanvas.getContext('2d');
                        
                        // Establecer dimensiones
                        const aspectRatio = originalImage.width / originalImage.height;
                        const canvasWidth = Math.min(800, originalImage.width);
                        const canvasHeight = canvasWidth / aspectRatio;
                        
                        originalCanvas.width = paintedCanvas.width = canvasWidth;
                        originalCanvas.height = paintedCanvas.height = canvasHeight;
                        
                        // Dibujar imagen original
                        originalCtx.drawImage(originalImage, 0, 0, canvasWidth, canvasHeight);
                        paintedCtx.drawImage(originalImage, 0, 0, canvasWidth, canvasHeight);
                        
                        // Simular detección y pintado de países
                        detectAndPaintCountries(paintedCtx, canvasWidth, canvasHeight);
                        
                        // Ocultar estado de procesamiento y mostrar vista previa
                        document.getElementById('processing-status').style.display = 'none';
                        document.getElementById('map-preview').style.display = 'block';
                        
                        // Actualizar validación
                        validatePuzzleStatus();
                    }
                    
                    function detectAndPaintCountries(ctx, width, height) {
                        // Simular países detectados (en una implementación real, esto sería detección por IA/CV)
                        const mockCountries = [
                            { name: 'País A', x: 0.2, y: 0.3, width: 0.25, height: 0.4 },
                            { name: 'País B', x: 0.5, y: 0.2, width: 0.3, height: 0.35 },
                            { name: 'País C', x: 0.1, y: 0.6, width: 0.4, height: 0.3 },
                            { name: 'País D', x: 0.6, y: 0.6, width: 0.35, height: 0.25 },
                            { name: 'País E', x: 0.45, y: 0.45, width: 0.2, height: 0.15 }
                        ];
                        
                        detectedCountries = mockCountries.map((country, index) => ({
                            ...country,
                            color: countryColors[index % countryColors.length],
                            id: `country-${index}`
                        }));
                        
                        // Aplicar colores semi-transparentes a las regiones
                        detectedCountries.forEach(country => {
                            ctx.fillStyle = country.color + '80'; // 50% transparencia
                            ctx.fillRect(
                                country.x * width,
                                country.y * height,
                                country.width * width,
                                country.height * height
                            );
                            
                            // Agregar borde
                            ctx.strokeStyle = country.color;
                            ctx.lineWidth = 2;
                            ctx.strokeRect(
                                country.x * width,
                                country.y * height,
                                country.width * width,
                                country.height * height
                            );
                        });
                        
                        // Crear etiquetas de países
                        createCountryLabels();
                        
                        // Crear leyenda
                        createLegend();
                        
                        // Actualizar contador de países
                        document.getElementById('countries-count').textContent = `${detectedCountries.length} países detectados`;
                    }
                    
                    function createCountryLabels() {
                        const labelsContainer = document.getElementById('country-labels');
                        const canvasRect = document.getElementById('painted-canvas').getBoundingClientRect();
                        
                        detectedCountries.forEach(country => {
                            const label = document.createElement('div');
                            label.className = 'country-label';
                            label.textContent = country.name;
                            label.style.left = ((country.x + country.width/2) * 100) + '%';
                            label.style.top = ((country.y + country.height/2) * 100) + '%';
                            label.style.color = country.color;
                            label.style.borderColor = country.color;
                            
                            labelsContainer.appendChild(label);
                        });
                    }
                    
                    function createLegend() {
                        const legendItems = document.getElementById('legend-items');
                        
                        detectedCountries.forEach(country => {
                            const item = document.createElement('div');
                            item.className = 'legend-item';
                            
                            const colorBox = document.createElement('div');
                            colorBox.className = 'legend-color';
                            colorBox.style.backgroundColor = country.color;
                            
                            const name = document.createElement('span');
                            name.textContent = country.name;
                            
                            item.appendChild(colorBox);
                            item.appendChild(name);
                            legendItems.appendChild(item);
                        });
                    }
                    
                    window.toggleOriginal = function() {
                        const originalCanvas = document.getElementById('original-canvas');
                        const paintedCanvas = document.getElementById('painted-canvas');
                        const toggleText = document.getElementById('toggle-text');
                        const labels = document.getElementById('country-labels');
                        
                        if (showingOriginal) {
                            originalCanvas.style.display = 'none';
                            paintedCanvas.style.display = 'block';
                            labels.style.display = labelsVisible ? 'block' : 'none';
                            toggleText.textContent = 'Ver original';
                            showingOriginal = false;
                        } else {
                            originalCanvas.style.display = 'block';
                            paintedCanvas.style.display = 'none';
                            labels.style.display = 'none';
                            toggleText.textContent = 'Ver pintado';
                            showingOriginal = true;
                        }
                    }
                    
                    window.regenerateColors = function() {
                        // Mezclar colores para nueva combinación
                        const shuffledColors = [...countryColors].sort(() => Math.random() - 0.5);
                        
                        detectedCountries.forEach((country, index) => {
                            country.color = shuffledColors[index % shuffledColors.length];
                        });
                        
                        // Repintar el canvas
                        const paintedCanvas = document.getElementById('painted-canvas');
                        const ctx = paintedCanvas.getContext('2d');
                        
                        // Limpiar y redibujar imagen base
                        const img = new Image();
                        img.onload = function() {
                            ctx.clearRect(0, 0, paintedCanvas.width, paintedCanvas.height);
                            ctx.drawImage(img, 0, 0, paintedCanvas.width, paintedCanvas.height);
                            
                            // Repintar países con nuevos colores
                            detectedCountries.forEach(country => {
                                ctx.fillStyle = country.color + '80';
                                ctx.fillRect(
                                    country.x * paintedCanvas.width,
                                    country.y * paintedCanvas.height,
                                    country.width * paintedCanvas.width,
                                    country.height * paintedCanvas.height
                                );
                                
                                ctx.strokeStyle = country.color;
                                ctx.lineWidth = 2;
                                ctx.strokeRect(
                                    country.x * paintedCanvas.width,
                                    country.y * paintedCanvas.height,
                                    country.width * paintedCanvas.width,
                                    country.height * paintedCanvas.height
                                );
                            });
                            
                            // Actualizar etiquetas y leyenda
                            updateLabelsColors();
                            updateLegendColors();
                        };
                        img.src = puzzleData.imageData;
                    }
                    
                    window.toggleLabels = function() {
                        const labels = document.getElementById('country-labels');
                        labelsVisible = !labelsVisible;
                        
                        if (showingOriginal) {
                            labels.style.display = 'none';
                        } else {
                            labels.style.display = labelsVisible ? 'block' : 'none';
                        }
                    }
                    
                    function updateLabelsColors() {
                        const labels = document.querySelectorAll('.country-label');
                        labels.forEach((label, index) => {
                            if (detectedCountries[index]) {
                                label.style.color = detectedCountries[index].color;
                                label.style.borderColor = detectedCountries[index].color;
                            }
                        });
                    }
                    
                    function updateLegendColors() {
                        const legendItems = document.querySelectorAll('.legend-color');
                        legendItems.forEach((item, index) => {
                            if (detectedCountries[index]) {
                                item.style.backgroundColor = detectedCountries[index].color;
                            }
                        });
                    }
                    
                    function adjustPuzzleOverlay() {
                        const pieces = document.querySelectorAll('.puzzle-piece');
                        const gridSize = puzzleData.difficulty === 1 ? 3 : (puzzleData.difficulty === 2 ? 4 : 5);
                        
                        pieces.forEach((piece, index) => {
                            if (index < gridSize * gridSize) {
                                piece.style.display = 'block';
                                const size = 100 / gridSize;
                                piece.style.width = size + '%';
                                piece.style.height = size + '%';
                                piece.style.left = (index % gridSize) * size + '%';
                                piece.style.top = Math.floor(index / gridSize) * size + '%';
                            } else {
                                piece.style.display = 'none';
                            }
                        });
                    }
                    
                    function validatePuzzleStatus() {
                        const validations = {
                            question: validateQuestion(),
                            image: validateImage(),
                            countries: validateCountries(),
                            hint: validateHint(),
                            difficulty: validateDifficulty()
                        };
                        
                        updateValidationDisplay(validations);
                        
                        // Habilitar botón de publicar si todo está válido
                        const allValid = Object.values(validations).every(v => v.valid);
                        document.getElementById('publish-btn').disabled = !allValid;
                        
                        // Actualizar overlay de piezas
                        if (validations.image.valid && validations.countries.valid) {
                            adjustPuzzleOverlay();
                        }
                    }
                    
                    function validateQuestion() {
                        const isValid = puzzleData.question && puzzleData.question.length >= 10;
                        return {
                            valid: isValid,
                            message: isValid ? `"${puzzleData.question.substring(0, 30)}..."` : 'Falta pregunta válida',
                            icon: isValid ? '✅' : '❌'
                        };
                    }
                    
                    function validateImage() {
                        const isValid = puzzleData.imageData && puzzleData.imageName;
                        return {
                            valid: isValid,
                            message: isValid ? puzzleData.imageName : 'No se ha cargado mapa',
                            icon: isValid ? '✅' : '❌'
                        };
                    }
                    
                    function validateCountries() {
                        const isValid = detectedCountries.length > 0;
                        return {
                            valid: isValid,
                            message: isValid ? `${detectedCountries.length} países detectados` : 'No se detectaron países',
                            icon: isValid ? '✅' : '❌'
                        };
                    }
                    
                    function validateHint() {
                        const isValid = puzzleData.noHint || (puzzleData.hint && puzzleData.hint.length >= 5);
                        let message = 'Sin configurar';
                        
                        if (puzzleData.noHint) {
                            message = 'Sin pista (más difícil)';
                        } else if (puzzleData.hint) {
                            message = `"${puzzleData.hint.substring(0, 20)}..."`;
                        }
                        
                        return {
                            valid: isValid,
                            message: message,
                            icon: isValid ? '✅' : '⚠️'
                        };
                    }
                    
                    function validateDifficulty() {
                        const difficultyNames = ['Fácil', 'Medio', 'Difícil'];
                        return {
                            valid: true,
                            message: difficultyNames[puzzleData.difficulty - 1],
                            icon: '✅'
                        };
                    }
                    
                    function updateValidationDisplay(validations) {
                        Object.keys(validations).forEach(key => {
                            const validation = validations[key];
                            const element = document.getElementById(`validation-${key}`);
                            const icon = element.querySelector('.status-icon');
                            const detail = document.getElementById(`${key}-detail`);
                            
                            icon.textContent = validation.icon;
                            icon.style.color = validation.valid ? '#22c55e' : '#ef4444';
                            detail.textContent = validation.message;
                        });
                    }
                    function testPuzzle() {
                        if (puzzleData.imageData && detectedCountries.length > 0) {
                            // Crear datos de prueba del puzzle
                            const testData = {
                                ...puzzleData,
                                countries: detectedCountries,
                                paintedMapData: document.getElementById('painted-canvas').toDataURL()
                            };
                            
                            sessionStorage.setItem('testPuzzleData', JSON.stringify(testData));
                            
                            // Redireccionar directamente a /MapEditor
                            window.location.href = '/MapEditor';
                        } else {
                            alert('Necesitas cargar un mapa y que se detecten países antes de poder probar el puzzle.');
                        }
                    }

                    
                    function showPublishOptions() {
                        document.getElementById('publish-options').style.display = 'block';
                        document.getElementById('publish-btn').style.display = 'none';
                    }
                    
                    window.hidePublishOptions = function() {
                        document.getElementById('publish-options').style.display = 'none';
                        document.getElementById('publish-btn').style.display = 'inline-block';
                    }
                    
                   window.confirmPublish = function() {
                        const isPublic = document.getElementById('make-public').checked;
                        const allowSharing = document.getElementById('allow-sharing').checked;
                        const educationalMode = document.getElementById('educational-mode').checked;
                        
                        // Preparar datos finales del puzzle geográfico
                        const finalPuzzleData = {
                            ...puzzleData,
                            type: 'geographic',
                            countries: detectedCountries,
                            paintedMapData: document.getElementById('painted-canvas').toDataURL(),
                            originalMapData: puzzleData.imageData,
                            isPublic: isPublic,
                            allowSharing: allowSharing,
                            educationalMode: educationalMode,
                            createdAt: new Date().toISOString(),
                            pieceCount: [9, 16, 25][puzzleData.difficulty - 1],
                            countriesCount: detectedCountries.length,
                            // ASEGURAR que la pregunta esté incluida explícitamente
                            question: puzzleData.question || sessionStorage.getItem('puzzleQuestion') || ''
                        };
                        
                        // Guardar en sessionStorage para la siguiente página
                        sessionStorage.setItem('finalPuzzleData', JSON.stringify(finalPuzzleData));
                        
                        // *** NO ELIMINAR puzzleQuestion hasta después de crear finalPuzzleData ***
                        // Comentar o mover estas líneas al final:
                        // sessionStorage.removeItem('puzzleQuestion');
                        // sessionStorage.removeItem('puzzleDifficulty');
                        // sessionStorage.removeItem('puzzleHint');
                        // sessionStorage.removeItem('puzzleNoHint');
                        // sessionStorage.removeItem('puzzleImageData');
                        // sessionStorage.removeItem('puzzleImageName');
                        
                        // Mostrar confirmación
                        let message = `🎉 ¡Puzzle geográfico publicado exitosamente!\n\n`;
                        message += `📋 Detalles:\n`;
                        message += `• ${detectedCountries.length} países detectados\n`;
                        message += `• ${finalPuzzleData.pieceCount} piezas de dificultad\n`;
                        message += `• Modo educativo: ${educationalMode ? 'Activado' : 'Desactivado'}\n`;
                        message += `\n🎮 Redirigiendo al juego...`;
                        
                        alert(message);
                        
                        // Redireccionar al juego del puzzle
                        setTimeout(() => {
                            // Limpiar datos temporales DESPUÉS de la redirección
                            sessionStorage.removeItem('puzzleQuestion');
                            sessionStorage.removeItem('puzzleDifficulty');
                            sessionStorage.removeItem('puzzleHint');
                            sessionStorage.removeItem('puzzleNoHint');
                            sessionStorage.removeItem('puzzleImageData');
                            sessionStorage.removeItem('puzzleImageName');
                            
                            window.location.href = '/PuzzleResolution';
                        }, 2000);
                    }
                                        
                   
                    function simulateAdvancedCountryDetection(imageData) {
                        // Esta función simularía el uso de IA/Computer Vision para detectar países reales
                    
                        return new Promise((resolve) => {
                            
                            setTimeout(() => {
                                
                                const mockDetectedCountries = [
                                    { name: 'Brasil', confidence: 0.95, bounds: { x: 0.3, y: 0.4, width: 0.4, height: 0.35 } },
                                    { name: 'Argentina', confidence: 0.89, bounds: { x: 0.25, y: 0.6, width: 0.3, height: 0.25 } },
                                    { name: 'Chile', confidence: 0.87, bounds: { x: 0.15, y: 0.5, width: 0.1, height: 0.4 } },
                                    { name: 'Perú', confidence: 0.83, bounds: { x: 0.2, y: 0.35, width: 0.15, height: 0.2 } },
                                    { name: 'Colombia', confidence: 0.91, bounds: { x: 0.25, y: 0.2, width: 0.2, height: 0.15 } }
                                ];
                                
                                resolve(mockDetectedCountries);
                            }, 3000);
                        });
                    }
                });


                setTimeout(() => {
                    // Limpiar datos temporales DESPUÉS de un delay
                    sessionStorage.removeItem('puzzleQuestion');
                    sessionStorage.removeItem('puzzleDifficulty');
                    sessionStorage.removeItem('puzzleHint');
                    sessionStorage.removeItem('puzzleNoHint');
                    sessionStorage.removeItem('puzzleImageData');
                    sessionStorage.removeItem('puzzleImageName');
                }, 5000); // 5 segundos después de la redirección

            </script>
        </body>
    |]