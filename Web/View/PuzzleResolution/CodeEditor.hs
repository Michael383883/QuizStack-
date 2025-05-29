module Web.View.PuzzleResolution.CodeEditor where
import Web.View.Prelude

renderCodeEditor :: Html
renderCodeEditor = [hsx|
    <div class="code-editor-container">
        <link rel="stylesheet" href="/css/CodeEditor.css" />
        
        <!-- Toolbar de comandos -->
        <div class="command-toolbar">
            <h3 class="toolbar-title">Comandos de Navegación</h3>
            <div class="command-buttons">
                <button class="cmd-btn move-cmd" data-command="avanzar">
                  
                    <span class="cmd-text">Avanzar</span>
                </button>
                <button class="cmd-btn turn-cmd" data-command="girar_derecha">
                    
                    <span class="cmd-text">Girar Derecha</span>
                </button>
                <button class="cmd-btn turn-cmd" data-command="girar_izquierda">
                    
                    <span class="cmd-text">Girar Izquierda</span>
                </button>
                <button class="cmd-btn check-cmd" data-command="verificar_frente">
                    
                    <span class="cmd-text">Verificar Frente</span>
                </button>
            </div>
            
            <div class="control-structures">
                <h4>🔄 Estructuras de Control</h4>
                <button class="struct-btn repeat-struct" data-structure="repeat">
                    
                    <span class="struct-text">Repetir(n)</span>
                </button>
                <button class="struct-btn if-struct" data-structure="if">
                    
                    <span class="struct-text">Si(condición)</span>
                </button>
                
            </div>
        </div>
        
        <!-- Área de código visual -->
        <div class="code-area">
            <div class="code-header">
                <h3>🧩 Tu Algoritmo</h3>
                <div class="code-stats">
                    <span>Comandos: <span id="commandCount">0</span></span>
                </div>
            </div>
            
            <div class="code-canvas" id="codeCanvas">
                <div class="code-placeholder">
                    <p>Haz clic en los comandos para construir tu algoritmo</p>
                </div>
            </div>
        </div>
        
        <!-- Controles de ejecución -->
        <div class="execution-controls">
            <button class="exec-btn validate-btn" id="validateBtn">
                <span class="btn-icon">✓</span>
                <span class="btn-text">Validar</span>
            </button>
            <button class="exec-btn run-btn" id="runBtn">
                <span class="btn-icon">▶</span>
                <span class="btn-text">Ejecutar</span>
            </button>
            <button class="exec-btn clear-btn" id="clearBtn">
                <span class="btn-icon">🗑</span>
                <span class="btn-text">Limpiar</span>
            </button>
            <button class="exec-btn reset-btn" id="resetBtn">
                <span class="btn-icon">🔄</span>
                <span class="btn-text">Reiniciar</span>
            </button>
        </div>
        
        <!-- Estado de conexión -->
        <div class="connection-status">
            <span id="connectionStatus">🔗 Esperando conexión con el mapa...</span>
        </div>
    </div>
    
    <!-- Modal para estructuras repetir -->
    <div class="modal-overlay" id="repeatModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>🔁 Repetir Comandos</h3>
                <button class="modal-close" id="closeRepeatModal">×</button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="repeatCount">¿Cuántas veces repetir?</label>
                    <input type="number" id="repeatCount" min="1" max="20" value="3" />
                </div>
            </div>
            <div class="modal-footer">
                <button class="modal-btn cancel-btn" id="cancelRepeat">Cancelar</button>
                <button class="modal-btn create-btn" id="confirmRepeat">Crear</button>
            </div>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            console.log('🎮 CodeEditor iniciando...');
            
            let editorState = {
                commands: [],
                nextId: 1,
                isConnected: false
            };
            
            const codeCanvas = document.getElementById('codeCanvas');
            const commandCount = document.getElementById('commandCount');
            const repeatModal = document.getElementById('repeatModal');
            const connectionStatus = document.getElementById('connectionStatus');
            const runBtn = document.getElementById('runBtn');
            const validateBtn = document.getElementById('validateBtn');
            const resetBtn = document.getElementById('resetBtn');
            
            // Verificar conexión con PuzzleViewer
            function checkConnection() {
                if (window.puzzleControls && typeof window.puzzleControls.isReady === 'function') {
                    try {
                        const isReady = window.puzzleControls.isReady();
                        if (isReady) {
                            editorState.isConnected = true;
                            connectionStatus.textContent = '✅ Conectado al mapa';
                            connectionStatus.className = 'connection-status connected';
                            runBtn.disabled = false;
                            console.log('✅ Conexión establecida con PuzzleViewer');
                            return true;
                        }
                    } catch (error) {
                        console.log('⏳ PuzzleViewer aún no está listo:', error.message);
                    }
                }
                
                // Reintentar conexión
                setTimeout(checkConnection, 500);
                return false;
            }
            
            function createCommandBlock(command, id = null) {
                const blockId = id || `cmd_${editorState.nextId++}`;
                const block = document.createElement('div');
                block.className = 'command-block';
                block.dataset.command = command;
                block.dataset.id = blockId;
                block.draggable = true;
                
                const commandInfo = getCommandInfo(command);
                
                block.innerHTML = `
                    <div class="block-content">
                        <span class="block-icon">${commandInfo.icon}</span>
                        <span class="block-title">${commandInfo.title}</span>
                        <button class="delete-block" data-id="${blockId}">×</button>
                    </div>
                `;
                
                return block;
            }
            
            function getCommandInfo(command) {
                const commandMap = {
                    'avanzar': { icon: '↑', title: 'Avanzar' },
                    'girar_derecha': { icon: '↻', title: 'Girar Derecha' },
                    'girar_izquierda': { icon: '↺', title: 'Girar Izquierda' },
                    'verificar_frente': { icon: '👁️', title: 'Verificar Frente' }
                };
                
                return commandMap[command] || { icon: '❓', title: command };
            }
            
            function addCommandToCanvas(command) {
                const placeholder = codeCanvas.querySelector('.code-placeholder');
                if (placeholder) {
                    placeholder.remove();
                }
                
                const block = createCommandBlock(command);
                codeCanvas.appendChild(block);
                
                editorState.commands.push({
                    id: block.dataset.id,
                    command: command,
                    type: 'command'
                });
                
                updateStats();
                highlightLastCommand();
            }
            
            function createRepeatStructure(count) {
                const structureId = `repeat_${editorState.nextId++}`;
                const structure = document.createElement('div');
                structure.className = 'structure-block repeat-structure';
                structure.dataset.id = structureId;
                structure.dataset.type = 'repeat';
                structure.dataset.count = count;
                structure.draggable = true;
                
                structure.innerHTML = `
                    <div class="structure-content">
                        <span class="structure-icon">🔁</span>
                        <span class="structure-title">Repetir ${count} veces</span>
                        <button class="delete-block" data-id="${structureId}">×</button>
                    </div>
                    <div class="structure-body">
                        <div class="structure-placeholder">Arrastra comandos aquí</div>
                    </div>
                `;
                
                return structure;
            }
            
            function highlightLastCommand() {
                const blocks = codeCanvas.querySelectorAll('.command-block, .structure-block');
                blocks.forEach(block => block.classList.remove('highlight'));
                
                if (blocks.length > 0) {
                    blocks[blocks.length - 1].classList.add('highlight');
                    setTimeout(() => {
                        blocks[blocks.length - 1].classList.remove('highlight');
                    }, 1000);
                }
            }
            
            function updateStats() {
                const commands = editorState.commands.filter(cmd => cmd.type === 'command').length;
                commandCount.textContent = commands;
            }
            
            function clearCanvas() {
                codeCanvas.innerHTML = `
                    <div class="code-placeholder">
                        <p>Haz clic en los comandos para construir tu algoritmo</p>
                    </div>
                `;
                editorState.commands = [];
                updateStats();
            }
            
            // Expandir comandos con estructuras de control
            function expandCommands(commands) {
                const expanded = [];
                
                commands.forEach(cmd => {
                    if (cmd.type === 'structure' && cmd.command === 'repeat') {
                        // Expandir estructura repeat
                        const count = parseInt(cmd.count) || 1;
                        const repeatCommands = cmd.children || [];
                        
                        for (let i = 0; i < count; i++) {
                            expanded.push(...expandCommands(repeatCommands));
                        }
                    } else if (cmd.type === 'command') {
                        expanded.push(cmd.command);
                    }
                });
                
                return expanded;
            }
            
            // Validar secuencia de comandos
            function validateCommands() {
                if (editorState.commands.length === 0) {
                    alert('⚠️ No hay comandos para validar');
                    return false;
                }
                
                const expandedCommands = expandCommands(editorState.commands);
                console.log('🔍 Validando comandos:', expandedCommands);
                
                // Validaciones básicas
                if (expandedCommands.length > 100) {
                    alert('⚠️ Demasiados comandos (máximo 100)');
                    return false;
                }
                
                // Verificar comandos válidos
                const validCommands = ['avanzar', 'girar_derecha', 'girar_izquierda', 'verificar_frente'];
                const invalidCommands = expandedCommands.filter(cmd => !validCommands.includes(cmd));
                
                if (invalidCommands.length > 0) {
                    alert(`⚠️ Comandos inválidos: ${invalidCommands.join(', ')}`);
                    return false;
                }
                
                console.log('✅ Comandos válidos');
                return true;
            }
            
            // Ejecutar comandos en PuzzleViewer
            function executeCommands() {
                if (!editorState.isConnected) {
                    alert('❌ No hay conexión con el mapa');
                    return;
                }
                
                if (!validateCommands()) {
                    return;
                }
                
                const expandedCommands = expandCommands(editorState.commands);
                console.log('🚀 Enviando comandos al PuzzleViewer:', expandedCommands);
                
                try {
                    // Resetear el mapa primero
                    window.puzzleControls.resetSimulation();
                    
                    // Pequeña pausa para que se complete el reset
                    setTimeout(() => {
                        // Configurar comandos
                        window.puzzleControls.setCommands(expandedCommands);
                        
                        // Iniciar ejecución
                        window.puzzleControls.startExecution();
                        
                        // Deshabilitar botón de ejecución durante la animación
                        runBtn.disabled = true;
                        runBtn.innerHTML = '<span class="btn-icon">⏳</span><span class="btn-text">Ejecutando...</span>';
                        
                        // Reactivar después de un tiempo estimado
                        const estimatedTime = expandedCommands.length * 1000 + 2000; // 1 segundo por comando + 2 segundos extra
                        setTimeout(() => {
                            runBtn.disabled = false;
                            runBtn.innerHTML = '<span class="btn-icon">▶</span><span class="btn-text">Ejecutar</span>';
                        }, estimatedTime);
                        
                    }, 100);
                    
                } catch (error) {
                    console.error('❌ Error al ejecutar comandos:', error);
                    alert('❌ Error al ejecutar comandos: ' + error.message);
                    runBtn.disabled = false;
                    runBtn.innerHTML = '<span class="btn-icon">▶</span><span class="btn-text">Ejecutar</span>';
                }
            }
            
            // Event listeners para comandos
            document.querySelectorAll('.cmd-btn').forEach(btn => {
                btn.addEventListener('click', function() {
                    const command = this.dataset.command;
                    addCommandToCanvas(command);
                    console.log(`➕ Comando agregado: ${command}`);
                });
            });
            
            // Event listeners para estructuras
            document.querySelectorAll('.struct-btn').forEach(btn => {
                btn.addEventListener('click', function() {
                    const structure = this.dataset.structure;
                    if (structure === 'repeat') {
                        repeatModal.classList.add('show');
                    }
                });
            });
            
            // Event listeners para controles
            validateBtn.addEventListener('click', function() {
                if (validateCommands()) {
                    alert('✅ Algoritmo válido');
                }
            });
            
            runBtn.addEventListener('click', executeCommands);
            
            document.getElementById('clearBtn').addEventListener('click', function() {
                clearCanvas();
                console.log('🗑️ Canvas limpiado');
            });
            
            resetBtn.addEventListener('click', function() {
                if (editorState.isConnected && window.puzzleControls.resetSimulation) {
                    window.puzzleControls.resetSimulation();
                    console.log('🔄 Simulación reiniciada');
                }
            });
            
            // Modal handlers
            document.getElementById('closeRepeatModal').addEventListener('click', function() {
                repeatModal.classList.remove('show');
            });
            
            document.getElementById('cancelRepeat').addEventListener('click', function() {
                repeatModal.classList.remove('show');
            });
            
            document.getElementById('confirmRepeat').addEventListener('click', function() {
                const count = document.getElementById('repeatCount').value;
                if (count > 0) {
                    const placeholder = codeCanvas.querySelector('.code-placeholder');
                    if (placeholder) {
                        placeholder.remove();
                    }
                    
                    const repeatBlock = createRepeatStructure(count);
                    codeCanvas.appendChild(repeatBlock);
                    
                    editorState.commands.push({
                        id: repeatBlock.dataset.id,
                        command: 'repeat',
                        type: 'structure',
                        count: count,
                        children: [] // Para comandos anidados
                    });
                    
                    updateStats();
                    highlightLastCommand();
                    console.log(`🔁 Estructura repeat creada: ${count} veces`);
                }
                
                repeatModal.classList.remove('show');
            });
            
            // Delete blocks
            codeCanvas.addEventListener('click', function(e) {
                if (e.target.classList.contains('delete-block')) {
                    const blockId = e.target.dataset.id;
                    const block = document.querySelector(`[data-id="${blockId}"]`);
                    if (block) {
                        block.remove();
                        editorState.commands = editorState.commands.filter(cmd => cmd.id !== blockId);
                        updateStats();
                        console.log(`🗑️ Comando eliminado: ${blockId}`);
                        
                        if (editorState.commands.length === 0) {
                            clearCanvas();
                        }
                    }
                }
            });
            
            // Inicializar
            updateStats();
            
            // Deshabilitar botón de ejecutar hasta que haya conexión
            runBtn.disabled = true;
            
            // Intentar conectar con PuzzleViewer
            checkConnection();
            
            console.log('✅ CodeEditor inicializado correctamente');
        });
    </script>
|]