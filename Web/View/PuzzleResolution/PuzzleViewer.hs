module Web.View.PuzzleResolution.PuzzleViewer where
import Web.View.Prelude

renderPuzzleViewer = [hsx|
<link rel="stylesheet" href="/css/puzzle-viewer.css" />
    <div class="puzzle-container">
        <div class="puzzle-header">
            <h2 class="puzzle-title">Navegación Algorítmica - Sudamérica</h2>
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
            <!-- Área del mapa puzzle -->
            <div class="puzzle-map">
                <div class="map-title">
                    <h3>Mapa de Sudamérica - Encuentra el lugar de Bolivia</h3>
                </div>
                <div class="map-grid" id="mapGrid">
                    <!-- El grid se genera dinámicamente con países -->
                </div>
                
                <!-- Pieza Bolivia que navega -->
                <div class="navigating-piece" id="navigatingPiece">
                    <div class="piece-body bolivia-piece">
                        <span class="piece-label">BOL</span>
                        <div class="piece-direction-indicator"></div>
                    </div>
                </div>
            </div>
            
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
            console.log('🗺️ PuzzleViewer iniciando...');
            
            // Configuración del mapa de Sudamérica
            const MAP_CONFIG = {
                width: 10,
                height: 8,
                cellSize: 60,
                startPos: {x: 0, y: 0}, // Esquina superior izquierda
                goalPos: {x: 4, y: 4}, // Posición central donde va Bolivia
                countries: [
                    // Brasil (grande en la derecha)
                    {x: 6, y: 1, name: 'Brasil', code: 'BRA', color: '#4CAF50'},
                    {x: 7, y: 1, name: 'Brasil', code: 'BRA', color: '#4CAF50'},
                    {x: 8, y: 1, name: 'Brasil', code: 'BRA', color: '#4CAF50'},
                    {x: 6, y: 2, name: 'Brasil', code: 'BRA', color: '#4CAF50'},
                    {x: 7, y: 2, name: 'Brasil', code: 'BRA', color: '#4CAF50'},
                    {x: 8, y: 2, name: 'Brasil', code: 'BRA', color: '#4CAF50'},
                    {x: 5, y: 3, name: 'Brasil', code: 'BRA', color: '#4CAF50'},
                    {x: 6, y: 3, name: 'Brasil', code: 'BRA', color: '#4CAF50'},
                    {x: 7, y: 3, name: 'Brasil', code: 'BRA', color: '#4CAF50'},
                    
                    // Perú (izquierda)
                    {x: 1, y: 3, name: 'Perú', code: 'PER', color: '#FF9800'},
                    {x: 2, y: 3, name: 'Perú', code: 'PER', color: '#FF9800'},
                    {x: 1, y: 4, name: 'Perú', code: 'PER', color: '#FF9800'},
                    {x: 2, y: 4, name: 'Perú', code: 'PER', color: '#FF9800'},
                    
                    // Chile (izquierda abajo)
                    {x: 1, y: 5, name: 'Chile', code: 'CHI', color: '#F44336'},
                    {x: 1, y: 6, name: 'Chile', code: 'CHI', color: '#F44336'},
                    {x: 2, y: 6, name: 'Chile', code: 'CHI', color: '#F44336'},
                    
                    // Argentina (abajo centro)
                    {x: 3, y: 5, name: 'Argentina', code: 'ARG', color: '#2196F3'},
                    {x: 4, y: 5, name: 'Argentina', code: 'ARG', color: '#2196F3'},
                    {x: 3, y: 6, name: 'Argentina', code: 'ARG', color: '#2196F3'},
                    {x: 4, y: 6, name: 'Argentina', code: 'ARG', color: '#2196F3'},
                    {x: 4, y: 7, name: 'Argentina', code: 'ARG', color: '#2196F3'},
                    
                    // Paraguay (pequeño)
                    {x: 5, y: 4, name: 'Paraguay', code: 'PAR', color: '#9C27B0'},
                    {x: 5, y: 5, name: 'Paraguay', code: 'PAR', color: '#9C27B0'}
                ],
                oceans: [
                    // Océano Pacífico (izquierda)
                    {x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 0, y: 4}, {x: 0, y: 5}, {x: 0, y: 6}, {x: 0, y: 7},
                    // Océano Atlántico (derecha)
                    {x: 9, y: 0}, {x: 9, y: 1}, {x: 9, y: 2}, {x: 9, y: 3}, {x: 9, y: 4}, {x: 9, y: 5}, {x: 9, y: 6}, {x: 9, y: 7}
                ],
                mountains: [
                    // Cordillera de los Andes
                    {x: 2, y: 1}, {x: 3, y: 1}, {x: 2, y: 2}, {x: 3, y: 2}
                ]
            };
            
            // Estado del agente (pieza Bolivia)
            let agent = {
                x: MAP_CONFIG.startPos.x,
                y: MAP_CONFIG.startPos.y,
                direction: 0, // 0=Norte, 1=Este, 2=Sur, 3=Oeste
                isAtGoal: false,
                isMoving: false
            };
            
            // Estado de ejecución
            let execution = {
                commands: [],
                currentIndex: 0,
                isRunning: false,
                isPaused: false,
                speed: 1000, // ms entre comandos
                intervalId: null
            };
            
            // Elementos DOM
            const mapGrid = document.getElementById('mapGrid');
            const navigatingPiece = document.getElementById('navigatingPiece');
            const positionDisplay = document.getElementById('piecePosition');
            const directionDisplay = document.getElementById('pieceDirection');
            const currentInstructionDisplay = document.getElementById('currentInstruction');
            const executionStepDisplay = document.getElementById('executionStep');
            const executionStatusDisplay = document.getElementById('executionStatus');
            
            // Inicializar mapa
            function initializeMap() {
                mapGrid.innerHTML = '';
                mapGrid.style.gridTemplateColumns = `repeat(${MAP_CONFIG.width}, ${MAP_CONFIG.cellSize}px)`;
                mapGrid.style.gridTemplateRows = `repeat(${MAP_CONFIG.height}, ${MAP_CONFIG.cellSize}px)`;
                
                // Asegurar que el contenedor del mapa tiene posición relativa
                document.querySelector('.puzzle-map').style.position = 'relative';
                
                for (let y = 0; y < MAP_CONFIG.height; y++) {
                    for (let x = 0; x < MAP_CONFIG.width; x++) {
                        const cell = document.createElement('div');
                        cell.className = 'map-cell';
                        cell.dataset.x = x;
                        cell.dataset.y = y;
                        
                        // Determinar tipo de celda
                        if (x === MAP_CONFIG.startPos.x && y === MAP_CONFIG.startPos.y) {
                            cell.classList.add('start');
                            cell.innerHTML = '<span class="cell-label">S</span>';
                        } else if (x === MAP_CONFIG.goalPos.x && y === MAP_CONFIG.goalPos.y) {
                            cell.classList.add('goal', 'bolivia-target');
                            cell.innerHTML = '<span class="cell-label">🇧🇴</span>';
                        } else {
                            // Verificar si es país
                            const country = MAP_CONFIG.countries.find(c => c.x === x && c.y === y);
                            if (country) {
                                cell.classList.add('country');
                                cell.style.backgroundColor = country.color;
                                cell.innerHTML = `<span class="cell-label">${country.code}</span>`;
                                cell.title = country.name;
                            }
                            // Verificar si es océano
                            else if (MAP_CONFIG.oceans.some(o => o.x === x && o.y === y)) {
                                cell.classList.add('ocean');
                                cell.innerHTML = '<span class="cell-label">🌊</span>';
                            }
                            // Verificar si es montaña
                            else if (MAP_CONFIG.mountains.some(m => m.x === x && m.y === y)) {
                                cell.classList.add('mountain');
                                cell.innerHTML = '<span class="cell-label">⛰️</span>';
                            }
                            // Camino libre
                            else {
                                cell.classList.add('path');
                            }
                        }
                        
                        mapGrid.appendChild(cell);
                    }
                }
                
                updateAgentPosition();
            }
            
            // Actualizar posición del agente con animación suave
            function updateAgentPosition(animate = false) {
                // Calcular posición en píxeles basada en la celda del grid
                const x = agent.x * MAP_CONFIG.cellSize + (MAP_CONFIG.cellSize / 4);
                const y = agent.y * MAP_CONFIG.cellSize + (MAP_CONFIG.cellSize / 4);
                
                if (animate) {
                    navigatingPiece.style.transition = 'all 0.5s ease-in-out';
                } else {
                    navigatingPiece.style.transition = 'none';
                }
                
                // Aplicar posición y rotación
                navigatingPiece.style.left = `${x}px`;
                navigatingPiece.style.top = `${y}px`;
                navigatingPiece.style.transform = `rotate(${agent.direction * 90}deg)`;
                
                // Actualizar displays
                positionDisplay.textContent = `(${agent.x},${agent.y})`;
                directionDisplay.textContent = ['Norte', 'Este', 'Sur', 'Oeste'][agent.direction];
                
                // Verificar si llegó al objetivo
                if (agent.x === MAP_CONFIG.goalPos.x && agent.y === MAP_CONFIG.goalPos.y && !agent.isAtGoal) {
                    agent.isAtGoal = true;
                    showSuccessMessage();
                }
            }
            
            // Verificar si una posición es válida
            function isValidPosition(x, y) {
                if (x < 0 || x >= MAP_CONFIG.width || y < 0 || y >= MAP_CONFIG.height) {
                    return false;
                }
                
                // Verificar océanos (obstáculos)
                if (MAP_CONFIG.oceans.some(o => o.x === x && o.y === y)) {
                    return false;
                }
                
                // Verificar montañas (obstáculos)
                if (MAP_CONFIG.mountains.some(m => m.x === x && m.y === y)) {
                    return false;
                }
                
                // Verificar países (obstáculos, no se puede pasar por encima)
                if (MAP_CONFIG.countries.some(c => c.x === x && c.y === y)) {
                    return false;
                }
                
                return true;
            }
            
            // Comandos disponibles
            const commands = {
                avanzar: function() {
                    const directions = [
                        {x: 0, y: -1}, // Norte
                        {x: 1, y: 0},  // Este
                        {x: 0, y: 1},  // Sur
                        {x: -1, y: 0}  // Oeste
                    ];
                    
                    const dir = directions[agent.direction];
                    const newX = agent.x + dir.x;
                    const newY = agent.y + dir.y;
                    
                    if (isValidPosition(newX, newY) || (newX === MAP_CONFIG.goalPos.x && newY === MAP_CONFIG.goalPos.y)) {
                        agent.x = newX;
                        agent.y = newY;
                        updateAgentPosition(true);
                        console.log(`✅ Avanzar: (${agent.x}, ${agent.y})`);
                        return true;
                    } else {
                        console.log(`❌ No se puede avanzar a (${newX}, ${newY}) - posición bloqueada`);
                        return false;
                    }
                },
                
                girar_derecha: function() {
                    agent.direction = (agent.direction + 1) % 4;
                    updateAgentPosition(true);
                    console.log(`🔄 Girar derecha: ${['Norte', 'Este', 'Sur', 'Oeste'][agent.direction]}`);
                    return true;
                },
                
                girar_izquierda: function() {
                    agent.direction = (agent.direction + 3) % 4;
                    updateAgentPosition(true);
                    console.log(`🔄 Girar izquierda: ${['Norte', 'Este', 'Sur', 'Oeste'][agent.direction]}`);
                    return true;
                },
                
                verificar_frente: function() {
                    const directions = [
                        {x: 0, y: -1}, // Norte
                        {x: 1, y: 0},  // Este
                        {x: 0, y: 1},  // Sur
                        {x: -1, y: 0}  // Oeste
                    ];
                    
                    const dir = directions[agent.direction];
                    const frontX = agent.x + dir.x;
                    const frontY = agent.y + dir.y;
                    
                    const canMove = isValidPosition(frontX, frontY) || (frontX === MAP_CONFIG.goalPos.x && frontY === MAP_CONFIG.goalPos.y);
                    console.log(`👁️ Verificar frente: (${frontX}, ${frontY}) - ${canMove ? 'Libre' : 'Bloqueado'}`);
                    return canMove;
                }
            };
            
            // Ejecutar un comando
            function executeCommand(commandName) {
                console.log(`🎯 Ejecutando comando: ${commandName}`);
                
                if (commands[commandName]) {
                    const success = commands[commandName]();
                    
                    // Verificar si llegó al objetivo
                    if (agent.x === MAP_CONFIG.goalPos.x && agent.y === MAP_CONFIG.goalPos.y) {
                        executionStatusDisplay.textContent = '¡Bolivia encontró su lugar!';
                        execution.isRunning = false;
                        if (execution.intervalId) {
                            clearTimeout(execution.intervalId);
                            execution.intervalId = null;
                        }
                    }
                    
                    return success;
                } else {
                    console.error(`❌ Comando desconocido: ${commandName}`);
                    return false;
                }
            }
            
            // Mostrar mensaje de éxito
            function showSuccessMessage() {
                console.log('🎉 ¡Éxito! Bolivia llegó al objetivo');
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
            }
            
            // Resetear simulación
            function resetSimulation() {
                console.log('🔄 Reseteando simulación...');
                
                // Limpiar interval si existe
                if (execution.intervalId) {
                    clearTimeout(execution.intervalId);
                    execution.intervalId = null;
                }
                
                agent.x = MAP_CONFIG.startPos.x;
                agent.y = MAP_CONFIG.startPos.y;
                agent.direction = 0;
                agent.isAtGoal = false;
                
                execution.currentIndex = 0;
                execution.isRunning = false;
                execution.isPaused = false;
                
                // Remover mensaje de éxito si existe
                const successMessage = document.querySelector('.success-message');
                if (successMessage) {
                    successMessage.remove();
                }
                
                updateAgentPosition();
                updateExecutionDisplay();
                executionStatusDisplay.textContent = 'Listo';
            }
            
            // Actualizar display de ejecución
            function updateExecutionDisplay() {
                const currentCommand = execution.currentIndex < execution.commands.length ? 
                    execution.commands[execution.currentIndex] : 'Ninguna';
                
                currentInstructionDisplay.textContent = currentCommand;
                executionStepDisplay.textContent = `${execution.currentIndex}/${execution.commands.length}`;
            }
            
            // Ejecutar secuencia de comandos
            function runExecution() {
                if (!execution.isRunning || execution.isPaused) {
                    return;
                }
                
                if (execution.currentIndex < execution.commands.length) {
                    const command = execution.commands[execution.currentIndex];
                    executeCommand(command);
                    execution.currentIndex++;
                    updateExecutionDisplay();
                    
                    // Programar siguiente comando
                    if (execution.isRunning && !execution.isPaused) {
                        execution.intervalId = setTimeout(runExecution, execution.speed);
                    }
                } else {
                    execution.isRunning = false;
                    executionStatusDisplay.textContent = 'Terminado';
                    console.log('✅ Ejecución completada');
                }
            }
            
            // API pública para comunicarse con el CodeEditor
            window.puzzleControls = {
                resetSimulation: resetSimulation,
                
                setCommands: function(commandList) {
                    console.log('📥 Recibiendo comandos:', commandList);
                    execution.commands = [...commandList]; // Hacer copia del array
                    execution.currentIndex = 0;
                    updateExecutionDisplay();
                    console.log('✅ Comandos configurados exitosamente');
                },
                
                addCommand: function(command) {
                    execution.commands.push(command);
                    updateExecutionDisplay();
                },
                
                clearCommands: function() {
                    execution.commands = [];
                    execution.currentIndex = 0;
                    updateExecutionDisplay();
                },
                
                executeStep: function() {
                    if (execution.currentIndex < execution.commands.length) {
                        const command = execution.commands[execution.currentIndex];
                        executeCommand(command);
                        execution.currentIndex++;
                        updateExecutionDisplay();
                    }
                },
                
                startExecution: function() {
                    console.log('🚀 Iniciando ejecución desde API');
                    if (!execution.isRunning && execution.commands.length > 0) {
                        execution.isRunning = true;
                        execution.isPaused = false;
                        executionStatusDisplay.textContent = 'Ejecutando...';
                        console.log('▶️ Iniciando ejecución automática');
                        runExecution();
                    }
                },
                
                getAgentStatus: function() {
                    return {
                        position: {x: agent.x, y: agent.y},
                        direction: agent.direction,
                        isAtGoal: agent.isAtGoal
                    };
                },
                
                isReady: function() {
                    return true;
                }
            };
            
            // Inicializar
            initializeMap();
            updateExecutionDisplay();
            
            console.log('✅ PuzzleViewer inicializado correctamente');
            console.log('🔗 puzzleControls expuesto globalmente');
        });
    </script>
|]