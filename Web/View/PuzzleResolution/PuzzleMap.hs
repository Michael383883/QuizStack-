module Web.View.PuzzleResolution.PuzzleMap where
import Web.View.Prelude

renderPuzzleMap = [hsx|
<link rel="stylesheet" href="/css/PuzzleMap.css" />
<div class="puzzle-map">
    
    <div class="map-container">
        <div class="map-grid" id="mapGrid">
        
        </div>
        
        <!-- Pieza Bolivia que navega -->
        <div class="navigating-piece" id="navigatingPiece">
            <div class="piece-body bolivia-piece">
                <span class="piece-label">BOL</span>
                <div class="piece-direction-indicator"></div>
            </div>
        </div>
    </div>
    
    <!-- Panel de estado -->
    <div class="status-panel">
        <div class="agent-status">
            <h4>Estado del Agente</h4>
            <div class="status-item">
                <span>Posición: </span>
                <span id="agentPosition">(0, 0)</span>
            </div>
            <div class="status-item">
                <span>Dirección: </span>
                <span id="agentDirection">Norte</span>
            </div>
            <div class="status-item">
                <span>En objetivo: </span>
                <span id="agentAtGoal">No</span>
            </div>
        </div>
        
        <div class="execution-status">
            <h4>Ejecución</h4>
            <div class="status-item">
                <span>Comando actual: </span>
                <span id="currentCommand">-</span>
            </div>
            <div class="status-item">
                <span>Progreso: </span>
                <span id="executionProgress">0/0</span>
            </div>
        </div>
    </div>
</div>

<script>
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
    let executionState = {
        commands: [],
        currentIndex: 0,
        isExecuting: false,
        animationSpeed: 800 // milisegundos por comando
    };
    
    // Elementos DOM del mapa
    const mapGrid = document.getElementById('mapGrid');
    const navigatingPiece = document.getElementById('navigatingPiece');
    
    // Elementos de estado
    const agentPosition = document.getElementById('agentPosition');
    const agentDirection = document.getElementById('agentDirection');
    const agentAtGoal = document.getElementById('agentAtGoal');
    const currentCommand = document.getElementById('currentCommand');
    const executionProgress = document.getElementById('executionProgress');
    
    // Inicializar mapa
    function initializeMap() {
        console.log('🗺️ Inicializando mapa...');
        
        mapGrid.innerHTML = '';
        mapGrid.style.gridTemplateColumns = `repeat(${MAP_CONFIG.width}, ${MAP_CONFIG.cellSize}px)`;
        mapGrid.style.gridTemplateRows = `repeat(${MAP_CONFIG.height}, ${MAP_CONFIG.cellSize}px)`;
        
        // Crear celdas del mapa
        for (let y = 0; y < MAP_CONFIG.height; y++) {
            for (let x = 0; x < MAP_CONFIG.width; x++) {
                const cell = document.createElement('div');
                cell.className = 'map-cell';
                cell.dataset.x = x;
                cell.dataset.y = y;
                
                // Determinar tipo de celda
                if (x === MAP_CONFIG.startPos.x && y === MAP_CONFIG.startPos.y) {
                    cell.classList.add('start');
                    cell.innerHTML = '<span class="cell-label">🚀</span>';
                    cell.title = 'Posición inicial';
                } else if (x === MAP_CONFIG.goalPos.x && y === MAP_CONFIG.goalPos.y) {
                    cell.classList.add('goal', 'bolivia-target');
                    cell.innerHTML = '<span class="cell-label">🇧🇴</span>';
                    cell.title = 'Objetivo: Bolivia';
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
                        cell.title = 'Océano (obstáculo)';
                    }
                    // Verificar si es montaña
                    else if (MAP_CONFIG.mountains.some(m => m.x === x && m.y === y)) {
                        cell.classList.add('mountain');
                        cell.innerHTML = '<span class="cell-label">⛰️</span>';
                        cell.title = 'Montañas (obstáculo)';
                    }
                    // Camino libre
                    else {
                        cell.classList.add('path');
                        cell.title = 'Camino libre';
                    }
                }
                
                mapGrid.appendChild(cell);
            }
        }
        
        updateAgentPosition();
        updateStatusDisplay();
        console.log('✅ Mapa inicializado correctamente');
    }
    
    // Función updateAgentPosition corregida para el posicionamiento correcto
    function updateAgentPosition(animate = false) {
        console.log('🎯 Iniciando updateAgentPosition');
        console.log(`Agent position: (${agent.x}, ${agent.y})`);
        console.log(`Map config: cellSize=${MAP_CONFIG.cellSize}, dimensions=${MAP_CONFIG.width}x${MAP_CONFIG.height}`);
        
        // Obtener referencias de los elementos
        const mapGrid = document.querySelector('.map-grid');
        const navigatingPiece = document.querySelector('.navigating-piece');
        
        if (!mapGrid || !navigatingPiece) {
            console.error('❌ No se encontraron elementos del mapa');
            return;
        }
        
        // CÁLCULO CORRECTO DE POSICIÓN
        // La posición se calcula relativa al contenedor map-grid
        // Cada celda tiene MAP_CONFIG.cellSize (60px) + gap (2px)
        const cellTotalSize = MAP_CONFIG.cellSize + 2; // 60px + 2px gap
        const pieceSize = 30; // Tamaño de la pieza
        
        // Calcular posición centrada en la celda
        const x = agent.x * cellTotalSize + (MAP_CONFIG.cellSize / 2) - (pieceSize / 2) + 10; // +10 por el padding del grid
        const y = agent.y * cellTotalSize + (MAP_CONFIG.cellSize / 2) - (pieceSize / 2) + 10; // +10 por el padding del grid
        
        console.log(`📍 Posición calculada: x=${x}px, y=${y}px`);
        console.log(`Cell total size: ${cellTotalSize}px, Piece size: ${pieceSize}px`);
        
        // Configurar animación
        if (animate) {
            navigatingPiece.style.transition = 'all 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94)';
            navigatingPiece.classList.add('moving');
            
            // Remover clase de movimiento después de la animación
            setTimeout(() => {
                navigatingPiece.classList.remove('moving');
                navigatingPiece.style.transition = 'all 0.3s ease'; // Transición suave para otros cambios
            }, 800);
        } else {
            navigatingPiece.style.transition = 'none';
        }
        
        // APLICAR POSICIÓN Y ROTACIÓN
        navigatingPiece.style.left = `${x}px`;
        navigatingPiece.style.top = `${y}px`;
        navigatingPiece.style.transform = `rotate(${agent.direction * 90}deg)`;
        
        console.log(`✅ Pieza posicionada en: left=${x}px, top=${y}px, rotation=${agent.direction * 90}deg`);
        
        // Actualizar display de estado
        updateStatusDisplay();
        
        // Verificar si llegó al objetivo
        checkGoalReached();
        
        // Añadir efecto visual a la celda actual
        highlightCurrentCell();
    }

    // Función auxiliar para resaltar la celda actual
    function highlightCurrentCell() {
        // Remover highlights anteriores
        document.querySelectorAll('.map-cell.current-position').forEach(cell => {
            cell.classList.remove('current-position');
        });
        
        // Encontrar y resaltar la celda actual
        const currentCell = document.querySelector(`[data-x="${agent.x}"][data-y="${agent.y}"]`);
        if (currentCell) {
            currentCell.classList.add('current-position');
            
            // Remover el highlight después de un tiempo
            setTimeout(() => {
                currentCell.classList.remove('current-position');
            }, 1000);
        }
    }

    // Función para verificar si el objetivo fue alcanzado
    function checkGoalReached() {
        const goalPosition = findGoalPosition();
        
        if (goalPosition && agent.x === goalPosition.x && agent.y === goalPosition.y) {
            console.log('🎉 ¡Objetivo alcanzado!');
            agent.isAtGoal = true;
            
            // Añadir animación de celebración
            const navigatingPiece = document.querySelector('.navigating-piece');
            navigatingPiece.classList.add('goal-reached');
            
            // Añadir animación a la celda objetivo
            const goalCell = document.querySelector('.map-cell.bolivia-target');
            if (goalCell) {
                goalCell.classList.add('goal-animation');
            }
            
            // Mostrar mensaje de éxito después de un delay
            setTimeout(() => {
                showSuccessMessage();
            }, 1000);
        }
    }

    // Función para encontrar la posición del objetivo
    function findGoalPosition() {
        const goalCells = document.querySelectorAll('.map-cell.bolivia-target');
        if (goalCells.length > 0) {
            const goalCell = goalCells[0];
            return {
                x: parseInt(goalCell.dataset.x),
                y: parseInt(goalCell.dataset.y)
            };
        }
        return null;
    }

    // Función para mostrar mensaje de éxito
    function showSuccessMessage() {
        if (window.onPuzzleSolved) {
            window.onPuzzleSolved();
        } else {
            alert('🎉 ¡Felicitaciones! Has encontrado Bolivia correctamente.');
        }
    }
    
    // Actualizar displays de estado
    function updateStatusDisplay() {
        const directionNames = ['Norte ⬆️', 'Este ➡️', 'Sur ⬇️', 'Oeste ⬅️'];
        
        if (agentPosition) agentPosition.textContent = `(${agent.x}, ${agent.y})`;
        if (agentDirection) agentDirection.textContent = directionNames[agent.direction];
        if (agentAtGoal) agentAtGoal.textContent = agent.isAtGoal ? 'Sí ✅' : 'No ❌';
        
        if (executionProgress) {
            executionProgress.textContent = `${executionState.currentIndex}/${executionState.commands.length}`;
        }
    }
    
    // Verificar si una posición es válida
    function isValidPosition(x, y) {
        if (x < 0 || x >= MAP_CONFIG.width || y < 0 || y >= MAP_CONFIG.height) {
            console.log(`❌ Posición fuera de límites: (${x}, ${y})`);
            return false;
        }
        
        // Verificar océanos (obstáculos)
        if (MAP_CONFIG.oceans.some(o => o.x === x && o.y === y)) {
            console.log(`❌ Posición en océano: (${x}, ${y})`);
            return false;
        }
        
        // Verificar montañas (obstáculos)
        if (MAP_CONFIG.mountains.some(m => m.x === x && m.y === y)) {
            console.log(`❌ Posición en montañas: (${x}, ${y})`);
            return false;
        }
        
        // Verificar países (obstáculos, no se puede pasar por encima)
        if (MAP_CONFIG.countries.some(c => c.x === x && c.y === y)) {
            console.log(`❌ Posición en país: (${x}, ${y})`);
            return false;
        }
        
        return true;
    }
    
    // Comandos disponibles para el agente
    const mapCommands = {
        avanzar: async function() {
            const directions = [
                {x: 0, y: -1}, // Norte
                {x: 1, y: 0},  // Este
                {x: 0, y: 1},  // Sur
                {x: -1, y: 0}  // Oeste
            ];
            
            const dir = directions[agent.direction];
            const newX = agent.x + dir.x;
            const newY = agent.y + dir.y;
            
            console.log(`🚶 Intentando avanzar de (${agent.x}, ${agent.y}) a (${newX}, ${newY})`);
            
            // Permitir movimiento al objetivo incluso si está "ocupado"
            if (isValidPosition(newX, newY) || (newX === MAP_CONFIG.goalPos.x && newY === MAP_CONFIG.goalPos.y)) {
                agent.x = newX;
                agent.y = newY;
                updateAgentPosition(true);
                console.log(`✅ Avanzar exitoso: (${agent.x}, ${agent.y})`);
                
                // Esperar a que termine la animación
                return new Promise(resolve => {
                    setTimeout(resolve, executionState.animationSpeed);
                });
            } else {
                console.log(`❌ No se puede avanzar a (${newX}, ${newY}) - posición bloqueada`);
                
                // Efecto visual de error
                navigatingPiece.classList.add('blocked-movement');
                setTimeout(() => {
                    navigatingPiece.classList.remove('blocked-movement');
                }, 500);
                
                return new Promise(resolve => {
                    setTimeout(resolve, 500);
                });
            }
        },
        
        girar_derecha: async function() {
            console.log(`🔄 Girando a la derecha desde ${['Norte', 'Este', 'Sur', 'Oeste'][agent.direction]}`);
            agent.direction = (agent.direction + 1) % 4;
            updateAgentPosition(true);
            console.log(`✅ Ahora mirando: ${['Norte', 'Este', 'Sur', 'Oeste'][agent.direction]}`);
            
            return new Promise(resolve => {
                setTimeout(resolve, executionState.animationSpeed);
            });
        },
        
        girar_izquierda: async function() {
            console.log(`🔄 Girando a la izquierda desde ${['Norte', 'Este', 'Sur', 'Oeste'][agent.direction]}`);
            agent.direction = (agent.direction + 3) % 4;
            updateAgentPosition(true);
            console.log(`✅ Ahora mirando: ${['Norte', 'Este', 'Sur', 'Oeste'][agent.direction]}`);
            
            return new Promise(resolve => {
                setTimeout(resolve, executionState.animationSpeed);
            });
        },
        
        verificar_frente: async function() {
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
            console.log(`👁️ Verificar frente: (${frontX}, ${frontY}) - ${canMove ? 'Libre ✅' : 'Bloqueado ❌'}`);
            
            // Efecto visual de verificación
            const targetCell = document.querySelector(`[data-x="${frontX}"][data-y="${frontY}"]`);
            if (targetCell) {
                targetCell.classList.add(canMove ? 'check-free' : 'check-blocked');
                setTimeout(() => {
                    targetCell.classList.remove('check-free', 'check-blocked');
                }, 1000);
            }
            
            return new Promise(resolve => {
                setTimeout(() => resolve(canMove), 1000);
            });
        }
    };
    
    // Ejecutar secuencia de comandos con animación
    async function executeCommandSequence(commands) {
        if (executionState.isExecuting) {
            console.log('⚠️ Ya hay una ejecución en curso');
            return;
        }
        
        console.log('🚀 Iniciando ejecución de comandos:', commands);
        
        executionState.commands = commands;
        executionState.currentIndex = 0;
        executionState.isExecuting = true;
        
        // Actualizar UI de ejecución
        if (currentCommand) currentCommand.textContent = 'Iniciando...';
        updateStatusDisplay();
        
        try {
            for (let i = 0; i < commands.length; i++) {
                if (!executionState.isExecuting) {
                    console.log('⏹️ Ejecución cancelada');
                    break;
                }
                
                executionState.currentIndex = i + 1;
                const command = commands[i];
                
                console.log(`📋 Ejecutando comando ${i + 1}/${commands.length}: ${command}`);
                
                // Actualizar UI
                if (currentCommand) currentCommand.textContent = command;
                updateStatusDisplay();
                
                // Resaltar comando actual visualmente
                const currentCell = document.querySelector(`[data-x="${agent.x}"][data-y="${agent.y}"]`);
                if (currentCell) {
                    currentCell.classList.add('current-position');
                    setTimeout(() => {
                        currentCell.classList.remove('current-position');
                    }, executionState.animationSpeed);
                }
                
                // Ejecutar comando
                if (mapCommands[command]) {
                    await mapCommands[command]();
                } else {
                    console.error(`❌ Comando desconocido: ${command}`);
                }
                
                // Verificar si se completó el objetivo
                if (agent.isAtGoal) {
                    console.log('🎯 Objetivo alcanzado, deteniendo ejecución');
                    break;
                }
            }
        } catch (error) {
            console.error('❌ Error durante la ejecución:', error);
        } finally {
            executionState.isExecuting = false;
            if (currentCommand) currentCommand.textContent = executionState.isExecuting ? 'Ejecutando...' : 'Completado';
            updateStatusDisplay();
            console.log('✅ Ejecución finalizada');
        }
    }
    
    // Resetear el agente y el mapa
    function resetAgent() {
        console.log('🔄 Reseteando agente...');
        
        // Detener ejecución si está en curso
        executionState.isExecuting = false;
        
        // Resetear estado del agente
        agent.x = MAP_CONFIG.startPos.x;
        agent.y = MAP_CONFIG.startPos.y;
        agent.direction = 0;
        agent.isAtGoal = false;
        
        // Resetear estado de ejecución
        executionState.commands = [];
        executionState.currentIndex = 0;
        
        // Limpiar efectos visuales
        navigatingPiece.classList.remove('goal-reached', 'moving', 'blocked-movement');
        document.querySelectorAll('.map-cell').forEach(cell => {
            cell.classList.remove('goal-animation', 'current-position', 'check-free', 'check-blocked');
        });
        
        // Actualizar posición y estado
        updateAgentPosition();
        if (currentCommand) currentCommand.textContent = '-';
        
        console.log('✅ Agente reseteado correctamente');
    }
    
    // API pública del mapa para integración con CodeEditor
    window.puzzleControls = {
        isReady: function() {
            return mapGrid && navigatingPiece && MAP_CONFIG;
        },
        
        setCommands: function(commands) {
            console.log('📝 Comandos recibidos:', commands);
            executionState.commands = commands;
            return true;
        },
        
        startExecution: function() {
            if (executionState.commands.length === 0) {
                console.log('⚠️ No hay comandos para ejecutar');
                return false;
            }
            
            executeCommandSequence(executionState.commands);
            return true;
        },
        
        resetSimulation: function() {
            resetAgent();
            return true;
        },
        
        getStatus: function() {
            return {
                agent: {
                    position: {x: agent.x, y: agent.y},
                    direction: agent.direction,
                    directionName: ['Norte', 'Este', 'Sur', 'Oeste'][agent.direction],
                    isAtGoal: agent.isAtGoal
                },
                execution: {
                    isExecuting: executionState.isExecuting,
                    currentIndex: executionState.currentIndex,
                    totalCommands: executionState.commands.length
                }
            };
        },
        
        executeCommand: function(commandName) {
            console.log(`🎯 Comando individual: ${commandName}`);
            if (mapCommands[commandName]) {
                return mapCommands[commandName]();
            }
            return false;
        }
    };
    
    // Inicialización cuando el DOM esté listo
    document.addEventListener('DOMContentLoaded', function() {
        console.log('🗺️ PuzzleMap iniciando...');
        initializeMap();
        
        // Notificar que está listo
        window.dispatchEvent(new CustomEvent('puzzleMapReady'));
        console.log('✅ PuzzleMap listo para uso');
    });
    
    console.log('🗺️ PuzzleMap módulo cargado');
</script>
|]