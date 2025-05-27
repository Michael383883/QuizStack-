module Web.View.PuzzleResolution.CodeEditor where
import Web.View.Prelude

renderCodeEditor = [hsx|
    <div class="code-editor-container">
        <h2 class="editor-title">Editor de Código</h2>
        <link rel="stylesheet" href="/css/CodeEditor.css" />
        <div class="editor-toolbar">
            <button class="tool-btn" data-command="select">Seleccionar</button>
            <button class="tool-btn" data-command="move">Mover a</button>
            <button class="tool-btn" data-command="rotate">Girar</button>
            <button class="tool-btn" data-command="if">Si</button>
            <button class="tool-btn" data-command="then">Entonces</button>
            <button class="tool-btn" data-command="loop">Repetir</button>
        </div>

        <div class="editor-workspace">
            <div class="editor-header">
                <div class="editor-dots">
                    <span class="dot dot-red"></span>
                    <span class="dot dot-yellow"></span>
                    <span class="dot dot-green"></span>
                </div>
                <span class="editor-filename">puzzle-solution.js</span>
            </div>
            
            <div class="editor-area" id="codeEditor">
                <!-- Bloques de código aparecerán aquí -->
                <div class="code-placeholder">Arrastra comandos aquí o haz clic en los botones</div>
            </div>
        </div>

        <div class="editor-actions">
            <button class="action-btn run-btn">Ejecutar</button>
            <button class="action-btn build-btn">Armar</button>
            <button class="action-btn clear-btn">Limpiar</button>
        </div>

        {editorScript}
    </div>
|]
  where
    editorScript = [hsx|
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const editor = document.getElementById('codeEditor');
                const buttons = document.querySelectorAll('.tool-btn');
                
                // Agregar comandos al editor
                buttons.forEach(btn => {
                    btn.addEventListener('click', function() {
                        const command = this.getAttribute('data-command');
                        addCodeBlock(command);
                    });
                    
                    // Hacer los botones arrastrables
                    btn.setAttribute('draggable', 'true');
                    btn.addEventListener('dragstart', function(e) {
                        e.dataTransfer.setData('text/plain', this.getAttribute('data-command'));
                    });
                });
                
                // Permitir soltar en el área de editor
                editor.addEventListener('dragover', function(e) {
                    e.preventDefault();
                    this.classList.add('drag-over');
                });
                
                editor.addEventListener('dragleave', function() {
                    this.classList.remove('drag-over');
                });
                
                editor.addEventListener('drop', function(e) {
                    e.preventDefault();
                    this.classList.remove('drag-over');
                    const command = e.dataTransfer.getData('text/plain');
                    addCodeBlock(command);
                });
                
                // Función para agregar bloques de código
                function addCodeBlock(command) {
                    const placeholder = editor.querySelector('.code-placeholder');
                    if (placeholder) placeholder.remove();
                    
                    const block = document.createElement('div');
                    block.className = 'code-block';
                    block.innerHTML = `
                        <span class="code-command">${getCommandText(command)}</span>
                        <button class="code-remove">×</button>
                    `;
                    
                    block.querySelector('.code-remove').addEventListener('click', function() {
                        block.remove();
                        if (editor.children.length === 0) {
                            editor.innerHTML = '<div class="code-placeholder">Arrastra comandos aquí o haz clic en los botones</div>';
                        }
                    });
                    
                    editor.appendChild(block);
                }
                
                // Mapear comandos a texto
                function getCommandText(command) {
                    const commands = {
                        'select': 'Seleccionar(Pieza)',
                        'move': 'MoverA(Posición)',
                        'rotate': 'Girar(90)',
                        'if': 'Si(Condición) {',
                        'then': '} Entonces {',
                        'loop': 'Repetir(5) {'
                    };
                    return commands[command] || command;
                }
                
                // Acciones de botones
                document.querySelector('.run-btn').addEventListener('click', function() {
                    alert('Ejecutando código...');
                });
                
                document.querySelector('.build-btn').addEventListener('click', function() {
                    alert('Construyendo solución...');
                });
                
                document.querySelector('.clear-btn').addEventListener('click', function() {
                    editor.innerHTML = '<div class="code-placeholder">Arrastra comandos aquí o haz clic en los botones</div>';
                });
            });
        </script>
    |]